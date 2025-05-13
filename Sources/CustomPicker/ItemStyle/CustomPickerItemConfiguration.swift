//
//  CustomPickerItemConfiguration.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

public struct CustomPickerItemConfiguration<SelectionValue> {
    
    public struct Label: View {
        public let body: AnyView
    }
    
    @Binding public var selection: SelectionValue
    public let tag: SelectionValue?
    public let isSelected: Bool
    public let isEnabled: Bool
    public let label: Label
}
