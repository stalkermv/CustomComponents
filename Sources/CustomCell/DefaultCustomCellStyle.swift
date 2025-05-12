//
//  DefaultCustomCellStyle.swift
//
//  Created by Valeriy Malishevskyi on 06.08.2024.
//

import SwiftUI
import SwiftUIHelpers

extension CustomCellStyle where Self == DefaultCustomCellStyle {
    static var `default`: DefaultCustomCellStyle {
        DefaultCustomCellStyle()
    }
}

public struct DefaultCustomCellStyle: CustomCellStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.image

            VStack(alignment: .leading) {
                configuration.label
                
                configuration.secondaryLabel
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            configuration.accessory
                .foregroundStyle(.tint)
        }
    }
}
