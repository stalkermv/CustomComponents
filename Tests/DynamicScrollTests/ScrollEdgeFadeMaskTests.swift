import Foundation
import Testing
@testable import DynamicScroll

@Suite("Deciding which edges of a capped block are worth softening")
struct ScrollEdgeFadeMaskTests {
    @Test("Content that fits its ceiling fades at neither edge")
    func contentThatFitsIsNeverSoftened() {
        let mask = ScrollEdgeFadeMask(offset: 0, contentLength: 120, containerLength: 280)
        #expect(mask.fadesTop == false)
        #expect(mask.fadesBottom == false)
    }

    @Test("At rest against the top, only the bottom fades")
    func atTheTopOnlyTheBottomSoftens() {
        let mask = ScrollEdgeFadeMask(offset: 0, contentLength: 600, containerLength: 280)
        #expect(mask.fadesTop == false)
        #expect(mask.fadesBottom)
    }

    @Test("Scrolled to the bottom, only the top fades")
    func atTheBottomOnlyTheTopSoftens() {
        let mask = ScrollEdgeFadeMask(offset: 320, contentLength: 600, containerLength: 280)
        #expect(mask.fadesTop)
        #expect(mask.fadesBottom == false)
    }

    @Test("Somewhere in the middle, both edges fade")
    func inTheMiddleBothSoften() {
        let mask = ScrollEdgeFadeMask(offset: 160, contentLength: 600, containerLength: 280)
        #expect(mask.fadesTop)
        #expect(mask.fadesBottom)
    }

    @Test("Content that overruns by less than a point is not something to scroll to")
    func roundingIsNotOverflow() {
        let mask = ScrollEdgeFadeMask(offset: 0, contentLength: 280.4, containerLength: 280)
        #expect(mask.fadesTop == false)
        #expect(mask.fadesBottom == false)
    }

    @Test("A block with no height yet fades at neither edge")
    func unmeasuredBlockIsSharp() {
        let mask = ScrollEdgeFadeMask(offset: 0, contentLength: 0, containerLength: 0)
        #expect(mask.fadesTop == false)
        #expect(mask.fadesBottom == false)
    }

    @Test("A block that keeps its top anchored fades only at the bottom")
    func narrowedEdgesAreHonoured() {
        let mask = ScrollEdgeFadeMask(
            offset: 160,
            contentLength: 600,
            containerLength: 280,
            edges: .bottom
        )
        #expect(mask.fadesTop == false)
        #expect(mask.fadesBottom)
    }

    @Test("Narrowing an edge does not make a block that fits fade at the other")
    func narrowedEdgesStillRespectOverflow() {
        let mask = ScrollEdgeFadeMask(
            offset: 0,
            contentLength: 120,
            containerLength: 280,
            edges: .bottom
        )
        #expect(mask.fadesBottom == false)
    }

    @Test("Two fades on a short block stop at half its height instead of meeting")
    func fadeNeverSwallowsTheContent() {
        let mask = ScrollEdgeFadeMask(offset: 10, contentLength: 100, containerLength: 20)
        // A 16pt fade from both ends of a 20pt block would leave nothing opaque;
        // the fraction is clamped so each reaches at most halfway.
        _ = mask.gradient(length: 16, over: 20)
        #expect(mask.fadesTop)
        #expect(mask.fadesBottom)
    }
}
