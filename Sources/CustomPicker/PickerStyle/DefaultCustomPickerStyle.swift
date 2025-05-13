//
//  DefaultCustomPickerStyle.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

struct DefaultCustomPickerStyle: CustomPickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        Picker(selection: configuration.$selection) {
            configuration.content
        } label: {
            configuration.label
        }
    }
}
