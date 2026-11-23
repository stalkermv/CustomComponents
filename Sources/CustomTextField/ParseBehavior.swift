//
//  ParseBehavior.swift
//  CustomComponents
//

import SwiftUI

/// Controls how `CustomTextField` handles parsing, error display, and text presentation
/// when using a `ParseableFormatStyle`.
///
/// Two base modes are provided:
///
/// - ``strict``: Rewrites displayed text to the formatted output on every keystroke.
///   Errors appear immediately when parsing fails. This is the default behavior.
///
/// - ``lenient``: Keeps the user's raw input visible. Error and value are updated
///   on every keystroke, but error display can be debounced for a smoother experience.
///
/// Both modes support optional debouncing and automatic error hiding when typing resumes:
///
/// ```swift
/// CustomTextField(value: $username, format: .instagramUsername)
///     .parseBehavior(.lenient.debounced(.milliseconds(300)))
///
/// CustomTextField(value: $amount, format: .currency(code: "USD"))
///     .parseBehavior(.strict)
/// ```
public struct ParseBehavior: Sendable, Equatable {

    /// How the text field displays the current text content.
    public enum TextDisplay: Sendable, Equatable {
        /// Show the formatted output when parsing succeeds (characters may be rewritten/removed).
        case formatted
        /// Always show the user's raw input without rewriting.
        case raw
    }

    /// How the text field displays text.
    public let textDisplay: TextDisplay

    /// Delay before propagating a parse error to the environment.
    /// `nil` means errors appear immediately.
    public let errorDebounce: Duration?

    /// When `true`, any new keystroke hides the current error until the debounce fires again.
    public let hidesErrorOnInput: Bool

    public init(
        textDisplay: TextDisplay,
        errorDebounce: Duration? = nil,
        hidesErrorOnInput: Bool = false
    ) {
        self.textDisplay = textDisplay
        self.errorDebounce = errorDebounce
        self.hidesErrorOnInput = hidesErrorOnInput
    }

    // MARK: - Factory Methods

    /// Rewrites displayed text to the formatted output.  
    /// Errors appear immediately. Default behavior.
    public static let strict = ParseBehavior(textDisplay: .formatted)

    /// Keeps user's raw input visible.  
    /// Errors appear immediately, hidden when typing resumes.
    public static let lenient = ParseBehavior(
        textDisplay: .raw,
        hidesErrorOnInput: true
    )

    // MARK: - Modifiers

    /// Returns a copy with debounced error display.
    ///
    /// ```swift
    /// .parseBehavior(.lenient.debounced(.milliseconds(300)))
    /// ```
    public func debounced(_ duration: Duration) -> ParseBehavior {
        ParseBehavior(
            textDisplay: textDisplay,
            errorDebounce: duration,
            hidesErrorOnInput: hidesErrorOnInput
        )
    }

    /// Returns a copy that hides the error as soon as the user types again.
    public func hidesErrorOnInput(_ hides: Bool = true) -> ParseBehavior {
        ParseBehavior(
            textDisplay: textDisplay,
            errorDebounce: errorDebounce,
            hidesErrorOnInput: hides
        )
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry public var parseBehavior: ParseBehavior = .strict
}

extension View {
    /// Sets the parse behavior for `CustomTextField` descendants.
    public func parseBehavior(_ behavior: ParseBehavior) -> some View {
        environment(\.parseBehavior, behavior)
    }
}
