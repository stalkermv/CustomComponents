//
//  CustomPickerItemStyle.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

/// How one option in a picker is drawn, and — where a style needs it — what
/// choosing one does.
public protocol CustomPickerItemStyle: DynamicProperty {

    typealias ItemConfiguration = CustomPickerItemConfiguration<SelectionValue>
    typealias SelectionValue = AnyHashable

    associatedtype ItemBody: View

    @MainActor @ViewBuilder func makeItem(configuration: ItemConfiguration) -> Self.ItemBody
}
