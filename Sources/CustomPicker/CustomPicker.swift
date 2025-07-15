//
//  CustomPicker.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI
import SwiftUIBackports

public struct CustomPicker<SelectionValue: Hashable, Content: View, Label: View>: View {
    @Environment(\.customPickerStyle) private var style
    
    private let selection: Selection<SelectionValue>
    
    private let content: Content
    private let label: Label
    
    @_disfavoredOverload
    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.selection = .init(selection)
        self.content = content()
        self.label = label()
    }
    
    public init(
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.selection = .init(selection)
        self.content = content()
        self.label = label()
    }
    
    public var body: some View {
        let configuration = CustomPickerConfiguration(
            selection: selection.binding,
            content: .init(body: AnyView(makeContent())),
            label: .init(body: AnyView(label))
        )
        
        AnyView(style.resolve(configuration))
    }
    
    private func makeContent() -> some View {
        ForEach(subviews: content) { subview in
            CustomPickerItem(
                subview: subview,
                selection: selection
            )
        }
    }
}

struct CustomPickerResolver<Style>: View
where Style: CustomPickerStyle {
    let style: Style
    let configuration: CustomPickerConfiguration<AnyHashable>
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

extension CustomPickerStyle {
    @MainActor func resolve(_ configuration: CustomPickerConfiguration<SelectionValue>) -> some View {
        CustomPickerResolver(style: self, configuration: configuration)
    }
}

extension CustomPicker {
    public init(
        _ titleKey: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == Text {
        self.init(selection: selection, content: content) {
            Text(titleKey)
        }
    }
    
    public init(
        _ title: String,
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == Text {
        self.init(selection: selection, content: content) {
            Text(title)
        }
    }
}

extension CustomPicker where Label == EmptyView {
    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(selection: selection, content: content) {
            EmptyView()
        }
    }
}

private struct PreviewView: View {
    @State private var selectedValue: Int = 1
    
    var body: some View {
        CustomPicker(selection: $selectedValue) {
            ForEach(0..<10) { value in
                Text("\(value)")
                    .tag(value)
            }
        } label: {
            Text("Select value")
        }
        .pickerStyle(.segmented)
        .customPickerStyle(MyPickerStyle())
    }
}

struct MyPickerStyle: CustomPickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.content
        }
        .background(.red)
    }
    
    func makeItem(configuration: ItemConfiguration) -> some View {
        configuration.label
            .padding(10)
            .background(configuration.isSelected ? .blue : .green)
    }
}

struct MyPickerItemStyle: CustomPickerItemStyle {
    func makeItem(configuration: ItemConfiguration) -> some View {
        configuration.label
            .padding(5)
            .foregroundStyle(.white)
    }
}

#Preview {
    PreviewView()
}
