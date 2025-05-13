//
//  CustomPickerStyle.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

public protocol CustomPickerStyle: CustomPickerItemStyle, DynamicProperty {
    typealias Configuration = CustomPickerConfiguration<SelectionValue>

    typealias SelectionValue = AnyHashable
    
    associatedtype Body: View
    
    @MainActor @ViewBuilder func makeBody(configuration: Configuration) -> Self.Body
}

extension CustomPickerStyle {
    public func makeItem(configuration: ItemConfiguration) -> Never {
        fatalError("makeItem(configuration:) not implemented")
    }
}
