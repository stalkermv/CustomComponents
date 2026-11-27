// This target imports the umbrella module and nothing else, and does not use
// `@testable`, so it sees the package the way an app does.
import SwiftUI
import Testing
import CustomComponents

@MainActor
@Suite("import CustomComponents")
struct ImportTests {
    @Test("One import exposes the types of every component")
    func umbrellaReExportsComponents() {
        _ = ParseBehavior.strict
        _ = ScrollEdgeFade.automatic
        _ = AsyncButtonOptions()
        _ = ScrollViewThatFits(maxHeight: 100) { Text("x") }
        _ = CustomSection { Text("content") }
        _ = CustomCell { Text("cell") }
        _ = AsyncButton(action: {}) { Text("go") }
        _ = Text("x").scrollHeightLimit(50)
        _ = CustomTextField("name", text: .constant(""))
        _ = CustomPicker(selection: .constant(1)) { Text("one").tag(1) } label: { Text("pick") }
        _ = CustomPicker(selection: .constant(Int?.some(1))) { Text("one").tag(1) }
        #if !os(tvOS)
        _ = CustomStepper("n", value: .constant(1), step: 1)
        #endif
    }
}
