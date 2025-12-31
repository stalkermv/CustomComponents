//
//  Created by Valeriy Malishevskyi on 10.06.2024.
//

import SwiftUI

public struct CustomSection<Header: View, Footer: View, Content: View>: View {
    @Environment(\.customSectionStyle) private var style
    
    let header: Header
    let footer: Footer
    let content: Content
    
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.footer = footer()
        self.content = content()
    }
    
    public init(@ViewBuilder content: () -> Content)
    where Header == EmptyView, Footer == EmptyView {
        self.init(content: content, header: { EmptyView() }, footer: { EmptyView() })
    }
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header)
    where Footer == EmptyView {
        self.init(content: content, header: header, footer: { EmptyView() })
    }
    
    public var body: some View {
        let configuration = CustomSectionStyleConfiguration(
            header: CustomSectionStyleConfiguration.Header(header),
            footer: CustomSectionStyleConfiguration.Footer(footer),
            content: CustomSectionStyleConfiguration.Content(content)
        )
        AnyView(style.resolve(configuration))
    }
}

private struct CustomSectionResolver<Style>: View
where Style: CustomSectionStyle {
    let style: Style
    let configuration: CustomSectionStyleConfiguration
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

extension CustomSectionStyle {
    @MainActor func resolve(_ configuration: CustomSectionStyleConfiguration) -> some View {
        CustomSectionResolver(style: self, configuration: configuration)
    }
}

extension CustomSection where Header == Text, Content : View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title, which describes
    ///     the contents of the section.
    ///   - content: The section's content.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(content: content, header: { Text(titleKey) })
    }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    @_disfavoredOverload
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(content: content, header: { Text(title) })
    }
}

private struct PreviewSectionStyle: CustomSectionStyle {
    @Environment(\.lineLimit) private var lineLimit
    func makeBody(configuration: CustomSectionStyleConfiguration) -> some View {
        VStack(alignment: .leading) {
            configuration.header
                .font(.headline)
            configuration.content
            configuration.footer
                .font(.footnote)
                .foregroundColor(.gray)
            
            Text("Line limit: \(String(describing: lineLimit))")
                .font(.subheadline)
                .foregroundColor(.green)
        }
    }
}

private struct PreviewAlternativeSectionStyle: CustomSectionStyle {
    func makeBody(configuration: CustomSectionStyleConfiguration) -> some View {
        VStack(alignment: .leading) {
            configuration.header
                .font(.title)
                .foregroundColor(.blue)
            configuration.content
            configuration.footer
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(alignment: .leading) {
        CustomSection {
            Text("Section content")
        } header: {
            Text("Section header")
        } footer: {
            Text("Section footer")
        }
        .customSectionStyle(PreviewSectionStyle())
        .environment(\.lineLimit, 20)
        
        CustomSection {
            Text("Section content")
        } header: {
            Text("Section header")
        } footer: {
            Text("Section footer")
        }
        .customSectionStyle(PreviewAlternativeSectionStyle())
    }
    .padding()
}
