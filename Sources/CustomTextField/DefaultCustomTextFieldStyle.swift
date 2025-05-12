//
//  DefaultCustomTextFieldStyle.swift
//
//  Created by Valeriy Malishevskyi on 01.09.2024.
//

import SwiftUI

public struct DefaultCustomTextFieldStyle: CustomTextFieldStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
