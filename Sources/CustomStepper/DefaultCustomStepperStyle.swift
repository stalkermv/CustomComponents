//
//  DefaultCustomStepperStyle.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

public struct DefaultCustomStepperStyle: CustomStepperStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label.body
            configuration.decrement
            configuration.increment
        }
    }
    
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
