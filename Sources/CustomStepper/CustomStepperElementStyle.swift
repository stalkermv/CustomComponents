//
//  CustomStepperElementStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

/// A protocol that defines both increment and decrement styles for a custom stepper.
///
/// Conform to this protocol to provide buttons or views for both ends of the stepper UI.
public protocol CustomStepperElementStyle: CustomStepperDecrementStyle, CustomStepperIncrementStyle { }

/// A protocol that defines the style for a stepper's decrement button or view.
public protocol CustomStepperDecrementStyle {

    /// The view type to render the decrement element.
    associatedtype DecrementBody: View

    /// Creates the decrement view using the given configuration.
    ///
    /// - Parameter configuration: The increment/decrement action handler.
    /// - Returns: A view that performs a decrement action.
    @MainActor func makeDecrement(configuration: CustomStepperElementConfiguration) -> DecrementBody
}

/// A protocol that defines the style for a stepper's increment button or view.
public protocol CustomStepperIncrementStyle {

    /// The view type to render the increment element.
    associatedtype IncrementBody: View

    /// Creates the increment view using the given configuration.
    ///
    /// - Parameter configuration: The increment/decrement action handler.
    /// - Returns: A view that performs an increment action.
    @MainActor func makeIncrement(configuration: CustomStepperElementConfiguration) -> IncrementBody
}
