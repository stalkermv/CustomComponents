//
//  CustomStepperElementConfiguration.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

/// A configuration object passed to custom increment and decrement element styles.
///
/// Provides closures for handling user-initiated increment and decrement actions.
public struct CustomStepperElementConfiguration {

    /// A closure that should be called to perform an increment action.
    public let onIncrement: () -> Void

    /// A closure that should be called to perform a decrement action.
    public let onDecrement: () -> Void
}
