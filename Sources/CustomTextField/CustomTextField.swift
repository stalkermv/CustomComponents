//
//  CustomTextField.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

/// A customizable and stylable text field with parsing and formatting capabilities.
///
/// `CustomTextField` supports two-way binding of optional values, using a `ParseableFormatStyle`
/// to convert between strings and model data types. It integrates with a custom text field style
/// system and provides real-time validation feedback.
///
/// Use this view to build formatted inputs (e.g. currency, dates, numbers) with custom rendering
/// and validation behavior.
///
/// ```swift
/// CustomTextField(
///     label: Text("Amount"),
///     value: $amount,
///     format: .currency(code: "USD"),
///     prompt: Text("Enter amount")
/// )
/// ```
///
/// - Parameters:
///   - label: A view describing the field (e.g., a `Text` label).
///   - value: A binding to the underlying optional parsed value.
///   - format: A `ParseableFormatStyle` used to convert between `String` and the model value.
///   - prompt: An optional prompt (placeholder).
///   - axis: Whether the text field should be single-line (`.horizontal`) or multi-line (`.vertical`).
public struct CustomTextField<Label, F> : View
where Label: View, F: ParseableFormatStyle, F.FormatOutput == String {
    @Environment(\.customTextFieldStyle) var customTextFieldStyle
    @Environment(\.parseBehavior) private var parseBehavior
    
    private let label: Label
    private let prompt: Text?
    private let axis: Axis
    private let format: F
    @Binding private var value: F.FormatInput?
    
    @FocusState private var isFocused: Bool
    @State private var latestError: LocalizedError?
    @State private var presentedError: LocalizedError?
    @State private var localText: String = ""
    @State private var debounceTask: Task<Void, Never>?
    /// The formatted value this field last wrote to the binding. A change to
    /// any other value came from outside, such as a reset.
    @State private var lastWrittenOutput: String?
    
    private var textBinding: Binding<String> {
        Binding(
            get: {
                switch parseBehavior.textDisplay {
                case .formatted:
                    return readValue() ?? localText
                case .raw:
                    return localText
                }
            },
            set: { updateValue($0) }
        )
    }
    
    /// Initializes a new `CustomTextField` using a parseable format style.
    ///
    /// - Parameters:
    ///   - label: A view describing the field.
    ///   - value: A binding to the formatted value.
    ///   - format: The formatter to use for string conversion.
    ///   - prompt: A placeholder shown when the field is empty.
    ///   - axis: Determines the layout direction of the field. Default is `.horizontal`.
    public init(
        label: Label,
        value: Binding<F.FormatInput?>,
        format: F,
        prompt: Text? = nil,
        axis: Axis = .horizontal
    ) {
        self.label = label
        self._value = value
        self.format = format
        self.prompt = prompt
        self.axis = axis
    }
    
    public var body: some View {
        let style = TextFieldStyleProxy { label in
            let configuration = CustomTextFieldStyleConfiguration(
                label: CustomTextFieldStyleConfiguration.Label(body: AnyView(label)),
                text: textBinding,
                placeholder: prompt,
                axis: axis,
                isFocused: $isFocused
            )
            
            let resolved = customTextFieldStyle.resolve(configuration: configuration)
            
            return AnyView(resolved)
        }
        
        if #available(iOS 16.0, *) {
            TextField(
                text: textBinding,
                prompt: prompt,
                axis: axis,
                label: { label }
            )
            .textFieldStyle(style)
            .focused($isFocused)
            .environment(\.customTextFieldParseError, presentedError)
            .onAppear { syncLocalText() }
            .onChange(of: readValue()) { _, newOutput in
                valueDidChange(to: newOutput)
            }
            .onChange(of: isFocused) { _, isFocused in
                if !isFocused { presentPendingError() }
            }
        } else {
            TextField(
                text: textBinding,
                prompt: prompt,
                label: { label }
            )
            .textFieldStyle(style)
            .focused($isFocused)
            .environment(\.customTextFieldParseError, presentedError)
            .onAppear { syncLocalText() }
            .onChange(of: readValue()) { _, newOutput in
                valueDidChange(to: newOutput)
            }
            .onChange(of: isFocused) { _, isFocused in
                if !isFocused { presentPendingError() }
            }
        }
    }
    
    private func updateValue(_ newText: String) {
        localText = newText
        
        // Hide error immediately when user types (if configured)
        if parseBehavior.hidesErrorOnInput {
            presentedError = nil
        }
        
        do {
            let parsedValue = try format.parseStrategy.parse(newText)
            lastWrittenOutput = format.format(parsedValue)
            self.value = parsedValue
            self.latestError = nil
            schedulePresentError(nil)
        } catch {
            // In strict/formatted mode, nil out value on parse failure.
            // In lenient/raw mode, keep the last valid value so the form
            // state doesn't change spuriously (e.g. Save button stays correct).
            if parseBehavior.textDisplay == .formatted {
                lastWrittenOutput = nil
                self.value = nil
            }
            let localized = error as? LocalizedError
            self.latestError = localized
            schedulePresentError(localized)
        }
    }
    
    private func schedulePresentError(_ error: LocalizedError?) {
        debounceTask?.cancel()
        
        switch parseBehavior.errorPresentation(for: error, isFocused: isFocused) {
        case .now:
            presentedError = error
        case .afterDelay(let debounce):
            debounceTask = Task { @MainActor in
                try? await Task.sleep(for: debounce)
                guard !Task.isCancelled else { return }
                presentedError = latestError
            }
        case .onFocusLoss:
            // Shown by `presentPendingError()` when the user leaves the field.
            break
        }
    }

    /// Shows the error that was held back while the user was typing.
    private func presentPendingError() {
        guard parseBehavior.errorPresentation(for: latestError, isFocused: true) == .onFocusLoss else { return }
        debounceTask?.cancel()
        presentedError = latestError
    }

    /// Brings the text in line with a value that changed outside the field,
    /// such as a reset. Values the field wrote itself are left alone, so the
    /// text the user is typing is not rewritten.
    private func valueDidChange(to newOutput: String?) {
        guard ParseBehavior.isExternalChange(newOutput, lastWritten: lastWrittenOutput) else { return }
        lastWrittenOutput = newOutput
        localText = newOutput ?? ""
        debounceTask?.cancel()
        latestError = nil
        presentedError = nil
    }
    
    private func readValue() -> F.FormatOutput? {
        guard let value else { return nil }
        return format.format(value)
    }
    
    /// Syncs `localText` from the current value so that `.raw` mode
    /// shows the formatted content when the view first appears.
    private func syncLocalText() {
        lastWrittenOutput = readValue()
        if let formatted = lastWrittenOutput {
            localText = formatted
        }
    }
}

extension CustomTextField where F == EmptyParseableFormatStyle {
    /// Creates a `CustomTextField` for raw text entry without formatting or parsing.
    ///
    /// This is a shorthand initializer that bypasses format logic using `EmptyParseableFormatStyle`.
    ///
    /// - Parameters:
    ///   - label: A view describing the field.
    ///   - text: A binding to the raw string value.
    ///   - prompt: A placeholder shown when the field is empty.
    ///   - axis: Determines the layout direction of the field. Default is `.horizontal`.
    public init(
        label: Label,
        text: Binding<F.FormatInput>,
        prompt: Text? = nil,
        axis: Axis = .horizontal
    ) {
        self.init(
            label: label,
            value: Binding(text),
            format: EmptyParseableFormatStyle(),
            prompt: prompt,
            axis: axis
        )
    }
}

private struct ResolvedCustomTextField<Style: CustomTextFieldStyle>: View {
    let configuration: CustomTextFieldStyleConfiguration
    let style: Style
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

extension CustomTextFieldStyle {
    @MainActor func resolve(configuration: Configuration) -> some View {
        ResolvedCustomTextField(configuration: configuration, style: self)
    }
}

// MARK: - Preview

/// Fill behind the demo fields: the bar material, which watchOS and tvOS do not have.
private let previewBarFill: AnyShapeStyle = {
    #if os(watchOS) || os(tvOS)
    AnyShapeStyle(Color.secondary.opacity(0.2))
    #else
    AnyShapeStyle(Material.bar)
    #endif
}()

private struct DemoTextFieldStyle: CustomTextFieldStyle {
    @Environment(\.lineLimit) private var lineLimit
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            if !configuration.text.isEmpty {
                Button(action: { configuration.text = "" }) {
                    Image(systemName: "xmark")
                }
                .imageScale(.small)
            }
            Text("Line limit: \(String(describing: lineLimit))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(height: 22)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentColor, lineWidth: 1)
                .opacity(configuration.isFocused ? 1 : 0)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(previewBarFill)
        }
    }
}

@available(iOS 16.0, *)
private struct PreviewView: View {
    
    @State private var text = ""
    @State private var text2 = ""
    @State private var text3 = ""
    
    var body: some View {
        CustomTextField("Test", text: $text)
            .padding()
            .customTextFieldStyle(DemoTextFieldStyle())
        
        CustomTextField("Test", text: $text2)
            .padding()
            .customTextFieldStyle(DemoTextFieldStyle())
        
        CustomTextField("Test", text: $text3)
            .padding()
            .customTextFieldStyle(DemoTextFieldStyle())
        
        TextField("Test", text: $text)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(previewBarFill)
            }
    }
}

@available(iOS 16.0, *)
#Preview {
    PreviewView()
        .textFieldStyle(.plain)
        .customTextFieldStyle(DemoTextFieldStyle())
        .environment(\.lineLimit, 1)
}
