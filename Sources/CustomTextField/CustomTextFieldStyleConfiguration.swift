//
//  CustomTextFieldStyleConfiguration.swift
//
//  Created by Valeriy Malishevskyi on 01.09.2024.
//

import SwiftUI

/// A configuration object that provides context and content for rendering a `CustomTextFieldStyle`.
///
/// This structure is passed to the `makeBody(configuration:)` method of a `CustomTextFieldStyle`,
/// giving the style access to the label, text binding, placeholder, layout axis, and focus state.
///
/// Use this data to render a custom layout or behavior for the text field.
public struct CustomTextFieldStyleConfiguration {

    /// A view representing the field's label.
    ///
    /// Typically a `Text`, but may be any view supplied during the `CustomTextField`'s initialization.
    public struct Label: View {

        /// The rendered body of the label.
        public let body: AnyView
    }

    /// The label view associated with the field.
    public let label: Label

    /// A binding to the user-entered or formatted string content.
    ///
    /// Use this to create the actual `TextField` within your style implementation.
    @Binding public var text: String

    /// An optional placeholder to show when the field is empty.
    public let placeholder: Text?

    /// The layout axis of the field, either `.horizontal` (single-line) or `.vertical` (multi-line).
    public let axis: Axis

    /// A binding to the focus state of the text field.
    ///
    /// Use this to customize the visual appearance based on whether the field is currently focused.
    @FocusState.Binding public var isFocused: Bool
}
