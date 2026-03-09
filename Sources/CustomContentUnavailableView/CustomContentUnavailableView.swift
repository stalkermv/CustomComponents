//
//  CustomContentUnavailableView.swift
//  UIComponents
//
//  Created by Valeriy Malishevskyi on 09.07.2025.
//

import SwiftUI

/// A styleable replacement for SwiftUI's `ContentUnavailableView`.
///
/// Provides the same public API as the system view but supports
/// custom styling through ``CustomContentUnavailableViewStyle``.
///
/// ```swift
/// CustomContentUnavailableView("No results", systemImage: "magnifyingglass")
///     .customContentUnavailableViewStyle(.myStyle)
/// ```
public struct CustomContentUnavailableView<Label: View, Description: View, Actions: View>: View {
    @Environment(\.customContentUnavailableViewStyle) private var style
    
    private let label: Label
    private let description: Description
    private let actions: Actions
    
    /// Creates an unavailable content view with label, description, and actions builders.
    public init(
        @ViewBuilder label: () -> Label,
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.label = label()
        self.description = description()
        self.actions = actions()
    }
    
    public var body: some View {
        let configuration = CustomContentUnavailableViewStyleConfiguration(
            label: .init(body: AnyView(label)),
            description: .init(body: AnyView(description)),
            actions: .init(body: AnyView(actions))
        )
        AnyView(style.resolve(configuration))
    }
}
