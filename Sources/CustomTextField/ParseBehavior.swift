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
/// - ``lenient``: Keeps the user's raw input visible. The value is updated on every
///   keystroke. A parse error stays hidden while the user types and appears when the
///   field loses focus, or after a pause in typing with ``debounced(_:)``.
///
/// Both modes support optional debouncing and automatic error hiding when typing resumes:
///
/// ```swift
/// CustomTextField("Username", value: $username, format: .instagramUsername)
///     .parseBehavior(.lenient.debounced(.milliseconds(300)))
///
/// CustomTextField("Amount", value: $amount, format: .currency(code: "USD"))
///     .parseBehavior(.strict)
/// ```
///
/// When the bound value changes from outside the field, such as a reset, the field
/// shows the new value and clears its error in either mode.
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
    /// With no debounce, the error stays hidden until the field loses focus.
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
    /// Errors stay hidden while the user types and appear when the field loses focus.
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

// MARK: - Error presentation

extension ParseBehavior {
    /// When `CustomTextField` shows a parse error.
    enum ErrorPresentation: Equatable {
        case now
        case afterDelay(Duration)
        case onFocusLoss
    }

    /// When to show `error`, which is `nil` once the text parses again.
    func errorPresentation(for error: (any Error)?, isFocused: Bool) -> ErrorPresentation {
        guard error != nil else { return .now }
        if let errorDebounce { return .afterDelay(errorDebounce) }
        // Showing the error at once would undo the hiding on every keystroke.
        if hidesErrorOnInput && isFocused { return .onFocusLoss }
        return .now
    }

    /// Whether a new formatted value came from outside the field rather than
    /// from the text the field last parsed.
    static func isExternalChange(_ newOutput: String?, lastWritten: String?) -> Bool {
        newOutput != lastWritten
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
