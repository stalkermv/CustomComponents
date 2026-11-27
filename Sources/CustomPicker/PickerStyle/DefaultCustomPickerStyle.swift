//
//  DefaultCustomPickerStyle.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

struct DefaultCustomPickerStyle: CustomPickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *),
           configuration.hasCustomCurrentValueLabel {
            Picker(selection: configuration.$selection) {
                configuration.content
            } label: {
                configuration.label
            } currentValueLabel: {
                configuration.currentValueLabel
            }
        } else {
            Picker(selection: configuration.$selection) {
                configuration.content
            } label: {
                configuration.label
            }
        }
    }
}
