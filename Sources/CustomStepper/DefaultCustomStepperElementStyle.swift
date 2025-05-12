//
//  DefaultCustomStepperElementStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

public struct DefaultCustomStepperElementStyle: CustomStepperElementStyle {
    public func makeDecrement(configuration: CustomStepperElementConfiguration) -> some View {
        Button(action: configuration.onDecrement) {
            Image(systemName: "minus")
        }
    }

    public func makeIncrement(configuration: CustomStepperElementConfiguration) -> some View {
        Button(action: configuration.onIncrement) {
            Image(systemName: "plus")
        }
    }
}
