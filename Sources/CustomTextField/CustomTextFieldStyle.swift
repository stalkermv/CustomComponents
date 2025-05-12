//
//  CustomTextFieldStyle.swift
//
//  Created by Valeriy Malishevskyi on 01.09.2024.
//

import SwiftUI

/// A protocol that defines the visual and behavioral style of a `CustomTextField`.
///
/// Conform to `CustomTextFieldStyle` to customize how `CustomTextField` is rendered,
/// including layout, focus appearance, placeholder display, and other visual aspects.
///
/// A `CustomTextFieldStyle` is provided via the SwiftUI environment and must implement
/// `makeBody(configuration:)` to return a view that renders the styled text field.
///
/// ```swift
/// struct RoundedBorderTextFieldStyle: CustomTextFieldStyle {
///     func makeBody(configuration: Configuration) -> some View {
///         HStack {
///             configuration.label.body
///             TextField("", text: configuration.text)
///                 .padding(8)
///                 .background(RoundedRectangle(cornerRadius: 8).stroke())
///         }
///     }
/// }
/// ```
///
/// Apply a custom style using:
/// ```swift
/// CustomTextField(...)
///     .customTextFieldStyle(RoundedBorderTextFieldStyle())
/// ```
public protocol CustomTextFieldStyle: DynamicProperty {

    /// The associated view returned by the custom style.
    associatedtype Body: View

    /// The configuration structure passed into `makeBody`, containing all necessary
    /// data to render a styled field.
    typealias Configuration = CustomTextFieldStyleConfiguration

    /// Creates the styled view representing the body of a `CustomTextField`.
    ///
    /// - Parameter configuration: The current state and metadata of the field.
    /// - Returns: A view describing the styled appearance of the field.
    @MainActor func makeBody(configuration: Configuration) -> Self.Body
}
