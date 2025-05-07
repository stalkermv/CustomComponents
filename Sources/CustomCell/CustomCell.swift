//
//  CustomCell.swift
//  UIComponentsLibrary
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
import SwiftUIHelpers

/// A configurable cell component that adapts to a custom style and supports image, label, secondary text, and accessory views.
///
/// `CustomCell` is a generic, reusable building block for list items or rows. It supports the injection
/// of four content types: a main `content`, a `secondary` label, an optional leading `image`, and a trailing `accessory`.
/// The appearance is driven by a `CustomCellStyle` provided via the environment.
///
/// ```swift
/// CustomCell {
///     Text("Title")
/// } secondary: {
///     Text("Subtitle")
/// } image: {
///     Image(systemName: "star")
/// } accessory: {
///     Image(systemName: "chevron.right")
/// }
/// ```
///
/// You can override the visual style using `.customCellStyle(...)`.
public struct CustomCell<Content, Image, Secondary, Accessory> : View
where Content: View, Image: View, Secondary: View, Accessory: View {
    
    @Environment(\.customCellStyle) var style
    
    @ViewBuilder var content: Content
    @ViewBuilder var image: Image
    @ViewBuilder var secondary: Secondary
    @ViewBuilder var accessory: Accessory
        
    public var body: some View {
        let configuration = CustomCellStyleConfiguration(
            label: .init(body: AnyView(content)),
            secondaryLabel: .init(body: AnyView(secondary)),
            image: .init(body: AnyView(image)),
            accessory: .init(body: AnyView(accessory))
        )
        
        AnyView(style.makeBody(configuration: configuration))
    }
}

extension CustomCell {
    /// Creates a `CustomCell` with optional secondary, image, and accessory views.
    ///
    /// - Parameters:
    ///   - content: The primary content view.
    ///   - secondary: A secondary label view (e.g. subtitle). Defaults to `EmptyView`.
    ///   - image: A leading image view. Defaults to `EmptyView`.
    ///   - accessory: A trailing accessory view. Defaults to `EmptyView`.
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder secondary: () -> Secondary = EmptyView.init,
        @ViewBuilder image: () -> Image = EmptyView.init,
        @ViewBuilder accessory: () -> Accessory = EmptyView.init
    ) {
        self.init(
            content: content,
            image: image,
            secondary: secondary,
            accessory: accessory
        )
    }
}

#Preview {
    List {
        CustomCell {
            Text("Default")
        }
        
        CustomCell {
            Text("With image")
        } image: {
            Image(systemName: "star")
        }
        
        CustomCell {
            Text("Subtitle")
        } secondary: {
            Text("Secondary")
        }
        
        CustomCell {
            Text("Accessory")
        } accessory: {
            Image(systemName: "arrow.right")
        }
    }
}
