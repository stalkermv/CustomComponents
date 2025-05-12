//
//  CustomTextField+Init.swift
//
//  Created by Valeriy Malishevskyi on 02.09.2024.
//

import SwiftUI

extension CustomTextField where Label == Text, F == EmptyParseableFormatStyle {

    /// Creates a text field with a preferred axis and a text label generated
    /// from a localized title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, axis: Axis) {
        self.init(label: Text(titleKey), text: text, prompt: nil, axis: axis)
    }

    /// Creates a text field with a preferred axis and a text label generated
    /// from a localized title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?, axis: Axis) {
        self.init(label: Text(titleKey), text: text, prompt: prompt, axis: axis)
    }

    /// Creates a text field with a preferred axis and a text label generated
    /// from a title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<S>(_ title: S, text: Binding<String>, axis: Axis) where S : StringProtocol {
        self.init(label: Text(title), text: text, prompt: nil, axis: axis)
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init<S>(_ title: S, text: Binding<String>, prompt: Text?, axis: Axis) where S : StringProtocol {
        self.init(label: Text(title), text: text, prompt: prompt, axis: axis)
    }
}

extension CustomTextField where F == EmptyParseableFormatStyle {

    /// Creates a text field with a preferred axis and a prompt generated from
    /// a `Text`.
    ///
    /// Specify a preferred axis in which the text field should scroll
    /// its content when it does not fit in the available space. Depending
    /// on the style of the field, this axis may not be respected.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - axis: The axis in which to scroll text when it doesn't fit
    ///     in the available space.
    ///   - label: A view that describes the purpose of the text field.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(text: Binding<String>, prompt: Text? = nil, axis: Axis, @ViewBuilder label: () -> Label) {
        self.init(label: label(), text: text, prompt: prompt, axis: axis)
    }
}

extension CustomTextField where Label == Text, F == EmptyParseableFormatStyle {

    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) {
        self.init(label: Text(titleKey), text: text, prompt: prompt)
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init<S>(_ title: S, text: Binding<String>, prompt: Text?) where S : StringProtocol {
        self.init(label: Text(title), text: text, prompt: prompt)
    }
}

extension CustomTextField where F == EmptyParseableFormatStyle {

    /// Creates a text field with a prompt generated from a `Text`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// - Parameters:
    ///   - text: The text to display and edit.
    ///   - prompt: A `Text` representing the prompt of the text field
    ///     which provides users with guidance on what to type into the text
    ///     field.
    ///   - label: A view that describes the purpose of the text field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public init(text: Binding<String>, prompt: Text? = nil, @ViewBuilder label: () -> Label) {
        self.init(label: label(), text: text, prompt: prompt)
    }
}

extension CustomTextField where Label == Text, F == EmptyParseableFormatStyle {

    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.init(label: Text(titleKey), text: text, prompt: nil)
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - text: The text to display and edit.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<S>(_ title: S, text: Binding<String>) where S : StringProtocol {
        self.init(label: Text(title), text: text, prompt: nil)
    }
}

extension CustomTextField where Label == Text, F == EmptyParseableFormatStyle {
    
    /// Create an instance which binds over an arbitrary type, `V`.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// <doc://com.apple.documentation/documentation/Foundation/Formatter>
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the formatter can parse the
    /// text. If the format style can't parse the input, the bound value
    /// remains unchanged.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses a
    /// <doc://com.apple.documentation/documentation/Swift/Double>
    /// as the bound value, and a
    /// <doc://com.apple.documentation/documentation/Foundation/NumberFormatter>
    /// instance to convert to and from a string representation. The formatter
    /// uses the
    /// <doc://com.apple.documentation/documentation/Foundation/NumberFormatter/Style/decimal>
    /// style, to allow entering a fractional part. As the user types, the bound
    /// value updates, which in turn updates three ``Text`` views that use
    /// different format styles. If the user enters text that doesn't represent
    /// a valid `Double`, the bound value doesn't update.
    ///
    ///     @State private var myDouble: Double = 0.673
    ///     @State private var numberFormatter: NumberFormatter = {
    ///         var nf = NumberFormatter()
    ///         nf.numberStyle = .decimal
    ///         return nf
    ///     }()
    ///
    ///     var body: some View {
    ///         VStack {
    ///             TextField(
    ///                 value: $myDouble,
    ///                 formatter: numberFormatter
    ///             ) {
    ///                 Text("Double")
    ///             }
    ///             Text(myDouble, format: .number)
    ///             Text(myDouble, format: .number.precision(.significantDigits(5)))
    ///             Text(myDouble, format: .number.notation(.scientific))
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value of type `V`.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public init<V>(_ titleKey: LocalizedStringKey, value: Binding<V>, formatter: Formatter) {
        let binding = Binding<String>(
            get: { formatter.string(for: value.wrappedValue) ?? "" },
            set: { newValue in
                var object: AnyObject?
                var errorDescription: NSString?
                
                if formatter.getObjectValue(&object, for: newValue, errorDescription: &errorDescription),
                   let formattedValue = object as? V {
                    value.wrappedValue = formattedValue
                }
            }
        )
        
        self.init(label: Text(titleKey), text: binding, prompt: nil)
    }
}

extension CustomTextField where Label == Text {
    
    /// Creates a text field that applies a format style to a bound optional
    /// value, with a label generated from a localized title string.
    ///
    /// Use this initializer to create a text field that binds to a bound optional
    /// value, using a
    /// <doc://com.apple.documentation/documentation/Foundation/ParseableFormatStyle>
    /// to convert to and from this type. Changes to the bound value update
    /// the string displayed by the text field. Editing the text field
    /// updates the bound value, as long as the format style can parse the
    /// text. If the format style can't parse the input, the text field
    /// sets the bound value to `nil`.
    ///
    /// Use the ``View/onSubmit(of:_:)`` modifier to invoke an action
    /// whenever the user submits this text field.
    ///
    /// The following example uses an optional
    /// <doc://com.apple.documentation/documentation/Swift/Double>
    /// as the bound currency value, and a
    /// <doc://com.apple.documentation/documentation/Foundation/FloatingPointFormatStyle/Currency>
    /// instance to convert to and from a representation as U.S. dollars. As
    /// the user types, a `View.onChange(of:_:)` modifier logs the new value to
    /// the console. If the user enters an invalid currency value, like letters
    /// or emoji, the console output is `Optional(nil)`.
    ///
    ///     @State private var myMoney: Double? = 300.0
    ///     var body: some View {
    ///         TextField(
    ///             "Currency (USD)",
    ///             value: $myMoney,
    ///             format: .currency(code: "USD")
    ///         )
    ///         .onChange(of: myMoney) { newValue in
    ///             print ("myMoney: \(newValue)")
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - titleKey: The title of the text field, describing its purpose.
    ///   - value: The underlying value to edit.
    ///   - format: A format style of type `F` to use when converting between
    ///     the string the user edits and the underlying value of type
    ///     `F.FormatInput`. If `format` can't perform the conversion, the text
    ///     field sets `binding.value` to `nil`.
    ///   - prompt: A `Text` which provides users with guidance on what to type
    ///     into the text field.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor public init(_ titleKey: LocalizedStringKey, value: Binding<F.FormatInput?>, format: F, prompt: Text? = nil)
    where F : ParseableFormatStyle, F.FormatOutput == String {
        self.init(
            label: .init(titleKey),
            value: value,
            format: format,
            prompt: prompt
        )
    }
}
