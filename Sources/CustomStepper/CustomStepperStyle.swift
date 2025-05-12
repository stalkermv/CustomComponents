//
//  CustomStepperStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

/// A protocol that defines the complete visual layout and behavior of a custom stepper.
///
/// `CustomStepperStyle` combines increment/decrement element styles with a custom layout implementation.
/// It receives a `CustomStepperConfiguration` that includes the label, controls, and action handlers.
public protocol CustomStepperStyle: CustomStepperDecrementStyle, CustomStepperElementStyle, DynamicProperty {

    /// A typealias for the configuration object passed into the style.
    typealias Configuration = CustomStepperConfiguration

    /// The view returned by the custom stepper's body.
    associatedtype Body: View

    /// Creates the full custom stepper view using the given configuration.
    ///
    /// - Parameter configuration: A structure containing the stepper's label, controls, and handlers.
    /// - Returns: A complete stepper view.
    @MainActor func makeBody(configuration: Configuration) -> Self.Body
}
