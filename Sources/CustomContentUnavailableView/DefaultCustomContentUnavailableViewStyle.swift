//
//  DefaultCustomContentUnavailableViewStyle.swift
//  UIComponents
//
//  Created by Valeriy Malishevskyi on 09.07.2025.
//

import SwiftUI

/// Default style that delegates rendering to the system `ContentUnavailableView`.
struct DefaultCustomContentUnavailableViewStyle: CustomContentUnavailableViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ContentUnavailableView {
            configuration.label
        } description: {
            configuration.description
        } actions: {
            configuration.actions
        }
    }
}
