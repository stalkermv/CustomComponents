import SwiftUI
import Testing
@testable import CustomTextField

private struct SampleError: LocalizedError {}

@Suite("Error presentation")
struct ErrorPresentationTests {
    @Test("Strict shows an error at once")
    func strictShowsAtOnce() {
        #expect(ParseBehavior.strict.errorPresentation(for: SampleError(), isFocused: true) == .now)
    }

    @Test("Lenient holds an error back while the field is focused")
    func lenientHoldsErrorWhileTyping() {
        #expect(ParseBehavior.lenient.errorPresentation(for: SampleError(), isFocused: true) == .onFocusLoss)
        #expect(ParseBehavior.lenient.errorPresentation(for: SampleError(), isFocused: false) == .now)
    }

    @Test("A debounce delays the error in either mode")
    func debounceDelays() {
        let delay = Duration.milliseconds(300)
        #expect(ParseBehavior.lenient.debounced(delay).errorPresentation(for: SampleError(), isFocused: true) == .afterDelay(delay))
        #expect(ParseBehavior.strict.debounced(delay).errorPresentation(for: SampleError(), isFocused: true) == .afterDelay(delay))
    }

    @Test("Clearing an error is never delayed")
    func clearingIsImmediate() {
        #expect(ParseBehavior.lenient.errorPresentation(for: nil, isFocused: true) == .now)
        #expect(ParseBehavior.lenient.debounced(.seconds(1)).errorPresentation(for: nil, isFocused: true) == .now)
    }

    @Test("Only a value the field did not write counts as an outside change")
    func externalChange() {
        #expect(ParseBehavior.isExternalChange("5", lastWritten: "5") == false)
        #expect(ParseBehavior.isExternalChange(nil, lastWritten: nil) == false)
        #expect(ParseBehavior.isExternalChange(nil, lastWritten: "5"))
        #expect(ParseBehavior.isExternalChange("7", lastWritten: "5"))
    }
}

/// The README example, kept here so it keeps compiling.
private struct ReadmeParsingExample: View {
    @State private var amount: Double?

    var body: some View {
        CustomTextField("Amount", value: $amount, format: .currency(code: "USD"))
            .parseBehavior(.lenient.debounced(.milliseconds(300)))
    }
}
