//
//  CustomCellStyle+Environment.swift
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI

extension View {

    /// Sets a custom style to be used for `CustomCell` within the view hierarchy.
    ///
    /// - Parameter style: The custom style to apply.
    /// - Returns: A view that uses the specified `CustomCellStyle`.
    public func customCellStyle<Style: CustomCellStyle>(_ style: Style) -> some View {
        environment(\.customCellStyle, style)
    }
}

extension EnvironmentValues {

    /// The current `CustomCellStyle` from the environment.
    var customCellStyle: any CustomCellStyle {
        get { self[CustomCellStyleKey.self] }
        set { self[CustomCellStyleKey.self] = newValue }
    }
}

struct CustomCellStyleKey: EnvironmentKey {

    /// The default cell style used when no other style is set in the environment.
    nonisolated(unsafe) static let defaultValue: any CustomCellStyle = DefaultCustomCellStyle()
}
