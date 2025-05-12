//
//  View+CustomTextFieldStyle.swift
//
//  Created by Valeriy Malishevskyi on 01.09.2024.
//

import SwiftUI

extension View {

    /// Sets a custom text field style for use within this view’s hierarchy.
    ///
    /// This modifier allows you to override the appearance and behavior of `CustomTextField`
    /// by injecting a `CustomTextFieldStyle` into the environment.
    ///
    /// ```swift
    /// CustomTextField(...)
    ///     .customTextFieldStyle(MyCustomStyle())
    /// ```
    ///
    /// - Parameter style: A style conforming to `CustomTextFieldStyle`.
    /// - Returns: A view that uses the provided text field style within its subtree.
    public func customTextFieldStyle<Style: CustomTextFieldStyle>(_ style: Style) -> some View {
        environment(\.customTextFieldStyle, style)
    }
}

extension EnvironmentValues {
    /// The current `CustomTextFieldStyle` used in the environment.
    ///
    /// This value is read by `CustomTextField` to determine how to render itself.
    /// If no style is explicitly set, `DefaultCustomTextFieldStyle` is used.
    var customTextFieldStyle: any CustomTextFieldStyle {
        get { self[CustomTextFieldStyleKey.self] }
        set { self[CustomTextFieldStyleKey.self] = newValue }
    }
}

private struct CustomTextFieldStyleKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CustomTextFieldStyle = DefaultCustomTextFieldStyle()
}
