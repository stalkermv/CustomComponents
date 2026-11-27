import SwiftUI
import Testing
@testable import CustomTextField

@Suite("ParseBehavior")
struct ParseBehaviorTests {
    @Test("Strict is the default and rewrites the text, with errors shown at once")
    func strictIsTheDefault() {
        let behavior = EnvironmentValues().parseBehavior
        #expect(behavior == .strict)
        #expect(behavior.textDisplay == .formatted)
        #expect(behavior.errorDebounce == nil)
        #expect(behavior.hidesErrorOnInput == false)
    }

    @Test("Lenient keeps the raw text and hides the error while typing")
    func lenientKeepsRawText() {
        #expect(ParseBehavior.lenient.textDisplay == .raw)
        #expect(ParseBehavior.lenient.hidesErrorOnInput)
        #expect(ParseBehavior.lenient.errorDebounce == nil)
    }

    @Test("Modifiers return a changed copy and keep the other settings")
    func modifiersKeepOtherSettings() {
        let debounced = ParseBehavior.lenient.debounced(.milliseconds(300))
        #expect(debounced.errorDebounce == .milliseconds(300))
        #expect(debounced.textDisplay == .raw)
        #expect(debounced.hidesErrorOnInput)

        let shown = debounced.hidesErrorOnInput(false)
        #expect(shown.hidesErrorOnInput == false)
        #expect(shown.errorDebounce == .milliseconds(300))
    }
}
