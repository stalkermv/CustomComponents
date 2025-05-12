//
//  TextFieldStyleProxy.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

struct TextFieldStyleProxy<V: View>: TextFieldStyle {
    let makeBody: (TextField<Self._Label>) -> V
    
    func _body(configuration: TextField<Self._Label>) -> V {
        makeBody(configuration)
    }
}
