//
//  CustomPickerStyleEnvironmentKey.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//


import SwiftUI

extension View {
    public func customPickerStyle<S: CustomPickerStyle>(_ style: S) -> some View
    where S.ItemBody == Never {
        environment(\.customPickerStyle, style)
    }
    
    @_disfavoredOverload
    public func customPickerStyle<S: CustomPickerStyle>(_ style: S) -> some View {
        self.environment(\.customPickerStyle, style)
            .environment(\.customPickerItemStyle, style)
    }
}

extension EnvironmentValues {
    var customPickerStyle: any CustomPickerStyle {
        get { self[CustomPickerStyleEnvironmentKey.self] }
        set { self[CustomPickerStyleEnvironmentKey.self] = newValue }
    }
}

private struct CustomPickerStyleEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CustomPickerStyle = DefaultCustomPickerStyle()
}