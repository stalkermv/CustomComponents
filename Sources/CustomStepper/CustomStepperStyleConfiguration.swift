//
//  CustomStepperStyleConfiguration.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

/// A configuration object provided to custom stepper styles.
///
/// Contains all views and action closures required to render and operate a custom stepper.
public struct CustomStepperConfiguration {

    /// A type-erased view for the stepper's label.
    public struct Label: View {
        public let body: AnyView
    }

    /// A view representing the stepper's decrement control.
    public struct Decrement: View {
        public let body: AnyView
    }

    /// A view representing the stepper's increment control.
    public struct Increment: View {
        public let body: AnyView
    }

    /// The view shown as the stepper's label.
    public let label: Label

    /// Called when the stepper is incremented.
    public let onIncrement: () -> Void

    /// Called when the stepper is decremented.
    public let onDecrement: () -> Void

    /// The decrement control view.
    public let decrement: Decrement

    /// The increment control view.
    public let increment: Increment
}
