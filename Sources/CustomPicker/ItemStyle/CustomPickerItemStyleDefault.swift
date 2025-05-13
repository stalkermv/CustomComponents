//
//  CustomPickerItemStyleDefault.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//


import SwiftUI

struct CustomPickerItemStyleDefault: CustomPickerItemStyle {
    func makeItem(configuration: ItemConfiguration) -> some View {
        configuration.label
    }
}