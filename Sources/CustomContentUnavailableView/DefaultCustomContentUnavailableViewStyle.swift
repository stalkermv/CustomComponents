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
        if #available(iOS 17.0, *) {
            ContentUnavailableView {
                configuration.label
            } description: {
                configuration.description
            } actions: {
                configuration.actions
            }
        } else {
            VStack(spacing: 8) {
                configuration.label
                configuration.description
                configuration.actions
            }
        }
    }
}
