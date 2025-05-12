//
//  View+CustomStepperElementStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

extension View {

    /// Sets a custom style for the increment and decrement controls in a `CustomStepper`.
    ///
    /// - Parameter style: A type conforming to `CustomStepperElementStyle`.
    /// - Returns: A view that uses the provided style within its subtree.
    public func customStepperElementStyle(_ style: some CustomStepperElementStyle) -> some View {
        environment(\.customStepperElementStyle, style)
    }
}

extension EnvironmentValues {
    var customStepperElementStyle: (any CustomStepperElementStyle)? {
        get { self[CustomStepperElementConfigurationKey.self] }
        set { self[CustomStepperElementConfigurationKey.self] = newValue }
    }
}

private struct CustomStepperElementConfigurationKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: (any CustomStepperElementStyle)? = nil
}
