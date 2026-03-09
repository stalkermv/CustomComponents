//
//  CustomContentUnavailableViewStyleConfiguration.swift
//  UIComponents
//
//  Created by Valeriy Malishevskyi on 09.07.2025.
//

import SwiftUI

/// Configuration for a ``CustomContentUnavailableViewStyle``.
///
/// Contains type-erased label, description, and actions views
/// that the style uses to compose its layout.
public struct CustomContentUnavailableViewStyleConfiguration {
    
    /// A type-erased label view.
    public struct Label: View {
        public let body: AnyView
    }
    
    /// A type-erased description view.
    public struct Description: View {
        public let body: AnyView
    }
    
    /// A type-erased actions view.
    public struct Actions: View {
        public let body: AnyView
    }
    
    /// The label content of the unavailable view.
    public let label: Label
    /// The description content of the unavailable view.
    public let description: Description
    /// The actions content of the unavailable view.
    public let actions: Actions
}
