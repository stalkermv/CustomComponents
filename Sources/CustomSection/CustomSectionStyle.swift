//
//  Created by Valeriy Malishevskyi on 10.06.2024.
//

import SwiftUI

extension View {
    public func customSectionStyle<S>(_ style: S) -> some View where S: CustomSectionStyle {
        environment(\.customSectionStyle, style)
    }
}

public protocol CustomSectionStyle: DynamicProperty {
    typealias Configuration = CustomSectionStyleConfiguration

    associatedtype Body: View

    @MainActor
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

public struct CustomSectionStyleConfiguration {
    
    public struct Header: View {
        public let body: AnyView
        init<V: View>(_ view: V) {
            self.body = AnyView(view)
        }
    }
    
    public struct Footer: View {
        public let body: AnyView
        init<V: View>(_ view: V) {
            self.body = AnyView(view)
        }
    }
    
    public struct Content: View {
        public let body: AnyView
        init<V: View>(_ view: V) {
            self.body = AnyView(view)
        }
    }
    
    public let header: Header
    public let footer: Footer
    public let content: Content
}
