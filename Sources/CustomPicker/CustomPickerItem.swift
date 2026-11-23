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
    /// Whether an ancestor has disabled everything here. The option's own trait
    /// is only half the answer, and a style told the wrong half draws a live
    /// option over a control that cannot be pressed.
    @Environment(\.isEnabled) private var isEnvironmentEnabled

    let subview: Subview
    let selection: Selection<SelectionValue>

    var body: some View {
        let tag = subview.traitValues.tag(for: SelectionValue.self)
        let isSelected = tag.map(selection.contains(_:)) ?? false
        // An option with no tag cannot be chosen, so it is not a control the
        // user can aim at either — otherwise it looks pressable and answers
        // with nothing.
        let isDisabled = subview.traitValues.selectionDisabled || tag == nil

        let configuration = CustomPickerItemConfiguration(
            selection: selection.binding,
            tag: tag,
            isSelected: isSelected,
            isEnabled: isDisabled == false && isEnvironmentEnabled,
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
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
