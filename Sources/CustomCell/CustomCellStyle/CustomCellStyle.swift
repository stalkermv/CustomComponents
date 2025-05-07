//
//  CustomCellStyle.swift
//  UIComponentsLibrary
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI

/// A protocol that defines the visual appearance of a `CustomCell`.
///
/// Conform to `CustomCellStyle` to customize the layout and appearance of cells across your app.
/// Apply your style with `.customCellStyle(...)` on any view.
public protocol CustomCellStyle {

    /// The configuration passed into a custom cell style.
    typealias Configuration = CustomCellStyleConfiguration

    /// The type of view produced by the style.
    associatedtype Body: View

    /// Creates a view representing the body of a custom cell using the given configuration.
    ///
    /// - Parameter configuration: The current configuration of the custom cell.
    /// - Returns: A view representing the styled cell.
    @MainActor func makeBody(configuration: Self.Configuration) -> Self.Body
}
