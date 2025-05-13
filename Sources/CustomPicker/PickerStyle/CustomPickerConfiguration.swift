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
    
    @Binding public var selection: SelectionValue
    
    public let content: Content
    public let label: Label
}
