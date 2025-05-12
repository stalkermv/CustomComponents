//
//  EnvironmentValues.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

extension EnvironmentValues {
    /// An error representing the most recent parse failure from a `CustomTextField`, if any.
    ///
    /// This environment value is automatically set by `CustomTextField` when parsing user input fails,
    /// allowing styles or other views to react to validation errors and display feedback.
    ///
    /// You can access this in a custom `CustomTextFieldStyle` or surrounding views to show error messages.
    ///
    /// ```swift
    /// @Environment(\.customTextFieldParseError) var error
    ///
    /// if let error = error {
    ///     Text(error.localizedDescription)
    ///         .foregroundColor(.red)
    /// }
    /// ```
    ///
    /// - Note: This value is `nil` when parsing succeeds or no attempt has been made.
    @Entry public var customTextFieldParseError: Error?
}
