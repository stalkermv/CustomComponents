import SwiftUI
import Testing
@testable import CustomPicker

@MainActor
@Suite("CustomPicker Selection")
struct SelectionTests {
    @Test("Single selection replaces value and ignores deselect")
    func singleSelection() {
        var value = "a"
        let selection = Selection(Binding(get: { value }, set: { value = $0 }))

        #expect(selection.contains("a"))
        #expect(!selection.contains("b"))

        selection.toggle("a")
        #expect(value == "a")

        selection.toggle("b")
        #expect(value == "b")
        #expect(selection.contains("b"))
    }

    @Test("Optional selection selects from nil, switches, and toggles active value back to nil")
    func optionalSelection() {
        var value: String?
        let selection = Selection(Binding(get: { value }, set: { value = $0 }))

        #expect(!selection.contains("👍"))

        selection.toggle("👍")
        #expect(value == "👍")
        #expect(selection.contains("👍"))

        selection.toggle("❤️")
        #expect(value == "❤️")
        #expect(!selection.contains("👍"))
        #expect(selection.contains("❤️"))

        selection.toggle("❤️")
        #expect(value == nil)
        #expect(!selection.contains("❤️"))
    }

    @Test("Multiple selection inserts and removes values independently")
    func multipleSelection() {
        var values: Set<String> = []
        let selection = Selection(Binding(get: { values }, set: { values = $0 }))

        selection.toggle("👍")
        selection.toggle("❤️")
        #expect(values == ["👍", "❤️"])

        selection.toggle("👍")
        #expect(values == ["❤️"])
    }

    @Test("CustomPicker overloads resolve required, optional, and multiple bindings")
    func overloadResolution() {
        _ = CustomPicker(selection: .constant("a")) {
            Text("A").tag("a")
        }

        _ = CustomPicker(selection: .constant(Optional("a"))) {
            Text("A").tag("a")
        }

        _ = CustomPicker(selection: .constant(Set(["a"]))) {
            Text("A").tag("a")
        }

        _ = CustomPicker("Mode", selection: .constant(Optional("a"))) {
            Text("A").tag("a")
        }

        _ = CustomPicker(selection: .constant(Optional("a"))) {
            Text("A").tag("a")
        } label: {
            Text("Mode")
        } currentValueLabel: {
            Text("A")
        }
    }
}
