//
//  EmptyFormatStyle.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

public struct EmptyParseableFormatStyle: ParseableFormatStyle {
    
    public struct Strategy: ParseStrategy {
        public func parse(_ value: String) throws -> String {
            value
        }
    }
    
    public func format(_ value: String) -> String {
        value
    }
    
    public var parseStrategy: Strategy { Strategy() }
}
