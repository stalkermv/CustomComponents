//
//  View+CustomStepperStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

extension View {

    /// Sets a custom full layout style for a `CustomStepper`.
    ///
    /// Use this to override the appearance of the stepper’s structure and behavior.
    ///
    /// - Parameter style: A style conforming to `CustomStepperStyle`.
    /// - Returns: A view that uses the provided stepper style in the environment.
    public func customStepperStyle<S>(_ style: S) -> some View where S: CustomStepperStyle {
        self.environment(\.customStepperStyle, style)
    }
}

extension EnvironmentValues {
    var customStepperStyle: any CustomStepperStyle {
        get { self[CustomStepperStyleKey.self] }
        set { self[CustomStepperStyleKey.self] = newValue }
    }
}

private struct CustomStepperStyleKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CustomStepperStyle = DefaultCustomStepperStyle()
}
