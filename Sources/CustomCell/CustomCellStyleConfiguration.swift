//
//  CustomCellStyleConfiguration.swift
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI

/// A configuration object that describes the content provided to a `CustomCellStyle`.
///
/// Contains views for the main label, secondary label, image, and accessory.
public struct CustomCellStyleConfiguration {

    /// The primary label content.
    public struct Label: View {
        public let body: AnyView
    }

    /// The secondary label content.
    public struct SecondaryLabel: View {
        public let body: AnyView
    }

    /// The image content, typically displayed on the leading edge.
    public struct Image: View {
        public let body: AnyView
    }

    /// The accessory content, typically displayed on the trailing edge.
    public struct Accessory: View {
        public let body: AnyView
    }

    public let label: Label
    public let secondaryLabel: SecondaryLabel
    public let image: Image
    public let accessory: Accessory
}
