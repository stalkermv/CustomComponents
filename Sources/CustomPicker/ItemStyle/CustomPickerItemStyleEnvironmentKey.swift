//
//  CustomPickerItemStyleEnvironmentKey.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

extension View {
    public func customPickerItemStyle(_ style: any CustomPickerItemStyle) -> some View {
        environment(\.customPickerItemStyle, style)
    }
}

extension EnvironmentValues {
    var customPickerItemStyle: any CustomPickerItemStyle {
        get { self[CustomPickerItemStyleEnvironmentKey.self] }
        set { self[CustomPickerItemStyleEnvironmentKey.self] = newValue }
    }
}

private struct CustomPickerItemStyleEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CustomPickerItemStyle = CustomPickerItemStyleDefault()
}
