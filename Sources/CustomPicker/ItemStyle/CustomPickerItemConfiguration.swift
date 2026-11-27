//
//  CustomPickerItemConfiguration.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

/// What an item style is given.
///
/// The selection is a `Binding`, so a style can read the current value and can
/// also change it. That is deliberate and not an oversight: a style is not
/// only about appearance. SwiftUI's own `PrimitiveButtonStyle` hands a style
/// `configuration.trigger()` for exactly this reason — some styles are the
/// thing that decides when the action happens.
///
/// Reading it matters too, and less obviously: a style that wants to play a
/// sound or fire haptics when the choice changes needs the value to watch, not
/// only "is this one selected".
public struct CustomPickerItemConfiguration<SelectionValue> {

    public struct Label: View {
        public let body: AnyView
    }

    @Binding public var selection: SelectionValue

    /// What this option would select. `nil` where the call site forgot a tag,
    /// in which case the item is not something the user can choose.
    public let tag: SelectionValue?

    public let isSelected: Bool

    /// Whether the option can be chosen — the option's own trait and every
    /// ancestor's `disabled(_:)` together.
    ///
    /// It used to be the trait alone, so an item inside a disabled subtree told
    /// a style it was enabled while the control underneath was not, and the
    /// style drew a live-looking option nobody could press.
    public let isEnabled: Bool

    public let label: Label
}
