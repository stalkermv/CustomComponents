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
    
    private let label: Label
    private let prompt: Text?
    private let axis: Axis
    private let format: F
    @Binding private var value: F.FormatInput?
    
    @FocusState private var isFocused: Bool
    @State private var error: LocalizedError?
    @State private var localText: String = ""
    
    private var textBinding: Binding<String> {
        Binding(
            get: { readValue() ?? localText },
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
            .environment(\.customTextFieldParseError, error)
        } else {
            TextField(
                text: textBinding,
                prompt: prompt,
                label: { label }
            )
            .textFieldStyle(style)
            .focused($isFocused)
            .environment(\.customTextFieldParseError, error)
        }
    }
    
    private func updateValue(_ value: String) {
        do {
            let parsedValue = try format.parseStrategy.parse(value)
            self.value = parsedValue
            self.error = nil
        } catch {
            self.localText = value
            self.value = nil
            self.error = error as? LocalizedError
        }
    }
    
    private func readValue() -> F.FormatOutput? {
        guard let value else { return nil }
        return format.format(value)
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
                .foregroundStyle(.bar)
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
                    .foregroundStyle(.bar)
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
