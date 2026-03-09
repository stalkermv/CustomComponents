//
//  EnvironmentValues+CustomContentUnavailableView.swift
//  UIComponents
//
//  Created by Valeriy Malishevskyi on 09.07.2025.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var customContentUnavailableViewStyle: any CustomContentUnavailableViewStyle =
        DefaultCustomContentUnavailableViewStyle()
}

extension View {
    /// Sets the style for ``CustomContentUnavailableView`` within this view.
    public func customContentUnavailableViewStyle<Style: CustomContentUnavailableViewStyle>(
        _ style: Style
    ) -> some View {
        environment(\.customContentUnavailableViewStyle, style)
    }
}

// MARK: - Resolver

extension CustomContentUnavailableViewStyle {
    @MainActor
    func resolve(
        _ configuration: CustomContentUnavailableViewStyleConfiguration
    ) -> some View {
        CustomContentUnavailableViewResolver(style: self, configuration: configuration)
    }
}

private struct CustomContentUnavailableViewResolver<Style: CustomContentUnavailableViewStyle>: View {
    let style: Style
    let configuration: CustomContentUnavailableViewStyleConfiguration
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}
