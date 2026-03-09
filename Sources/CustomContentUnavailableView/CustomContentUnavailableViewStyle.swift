//
//  CustomContentUnavailableViewStyle.swift
//  UIComponents
//
//  Created by Valeriy Malishevskyi on 09.07.2025.
//

import SwiftUI

/// A protocol that defines the appearance of a ``CustomContentUnavailableView``.
///
/// Conforms to `DynamicProperty` so styles can use `@Environment`, `@State`, etc.
@MainActor
public protocol CustomContentUnavailableViewStyle: DynamicProperty {
    associatedtype Body: View
    
    typealias Configuration = CustomContentUnavailableViewStyleConfiguration
    
    /// Creates a view representing the body of the content unavailable view.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}
