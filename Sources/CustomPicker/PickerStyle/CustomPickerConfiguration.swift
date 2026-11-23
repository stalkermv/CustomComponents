//
//  CustomPickerConfiguration.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

public struct CustomPickerConfiguration<SelectionValue: Hashable> {
    
    public struct Content: View {
        public let body: AnyView
    }
    
    public struct Label: View {
        public let body: AnyView
    }

    /// What the closed picker shows as its value: the `currentValueLabel`
    /// the picker was given, otherwise the options whose tag is selected.
    public struct CurrentValueLabel: View {
        public let body: AnyView
    }
    
    @Binding public var selection: SelectionValue
    
    public let content: Content
    public let label: Label
    public let currentValueLabel: CurrentValueLabel
}
