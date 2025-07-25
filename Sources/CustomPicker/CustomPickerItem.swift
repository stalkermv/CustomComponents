//
//  CustomPickerItem.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI
import SwiftUIBackports
import struct SwiftUIBackports.Subview

struct CustomPickerItem<SelectionValue: Hashable> : View {
    @Environment(\.customPickerItemStyle) private var style
    
    let subview: Subview
    let selection: Selection<SelectionValue>
    
    var body: some View {
        let tag = subview.traitValues.tag(for: SelectionValue.self)
        let isSelected = tag.map(selection.contains(_:)) ?? false
        let isDisabled = subview.traitValues.selectionDisabled
        
        let configuration = CustomPickerItemConfiguration(
            selection: selection.binding,
            tag: tag,
            isSelected: isSelected,
            isEnabled: !isDisabled,
            label: .init(body: AnyView(subview))
        )
        
        Button {
            if let tag {
                selection.toggle(tag)
            }
        } label: {
            AnyView(style.resolve(configuration: configuration))
        }
        .disabled(isDisabled)
    }
}

struct CustomPickerItemResolver<Style>: View
where Style: CustomPickerItemStyle {
    let style: Style
    let configuration: CustomPickerItemConfiguration<AnyHashable>
    
    var body: some View {
        style.makeItem(configuration: configuration)
    }
}

extension CustomPickerItemStyle {
    @MainActor func resolve(configuration: CustomPickerItemConfiguration<SelectionValue>) -> some View {
        CustomPickerItemResolver(style: self, configuration: configuration)
    }
}
