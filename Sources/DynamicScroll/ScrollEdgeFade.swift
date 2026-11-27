import SwiftUI

/// Whether a capped scrolling block softens the edge it can still scroll
/// towards, and how far that softening reaches.
///
/// A hard cut at the ceiling says the content ended. A fade says it continues,
/// which is the only cue a list gives that there is more below when the
/// scrollbar has faded out — and every list that grows past its panel needs
/// one.
///
/// The fade belongs to the edges that still have somewhere to go. At rest
/// against the top there is nothing above to hint at, so the top edge is sharp;
/// scroll away from it and it softens. Content that fits its ceiling has no
/// fade at all — a block that is entirely visible must not look truncated.
///
/// The fade is drawn where `onScrollGeometryChange` exists: iOS 18, macOS 15,
/// tvOS 18, watchOS 11 and visionOS 2. On earlier systems the setting is
/// accepted and ignored, and the edges stay sharp.
public struct ScrollEdgeFade: Equatable, Sendable {
    public var isEnabled: Bool
    /// Which edges may soften at all.
    ///
    /// Both by default. Narrowed by a block that keeps something anchored at an
    /// edge — a pinned heading sits in the top ramp and would wash out, and a
    /// heading that fades is a heading not doing its job.
    public var edges: Edge.Set
    /// How deep the fade reaches from the edge, in points.
    public var length: CGFloat

    public init(isEnabled: Bool = true, edges: Edge.Set = [.top, .bottom], length: CGFloat = 16) {
        self.isEnabled = isEnabled
        self.edges = edges
        self.length = length
    }

    /// Fade whichever edges can still be scrolled towards.
    public static let automatic = ScrollEdgeFade()
    /// Never fade — for a block whose edge is already softened by something
    /// else, or one drawn against a background the fade would show through.
    public static let hidden = ScrollEdgeFade(isEnabled: false, edges: [], length: 0)
}

extension EnvironmentValues {
    @Entry public var scrollEdgeFade: ScrollEdgeFade = .automatic
}

extension View {
    /// Sets whether capped scrolling blocks in this subtree fade their edges.
    ///
    /// Read from the environment rather than passed down, so a whole panel can
    /// be switched over in one place instead of at every block inside it.
    public func scrollEdgeFade(_ fade: ScrollEdgeFade) -> some View {
        environment(\.scrollEdgeFade, fade)
    }

    /// Sets whether capped scrolling blocks in this subtree fade their edges,
    /// keeping everything else about the inherited fade.
    public func scrollEdgeFade(_ isEnabled: Bool) -> some View {
        transformEnvironment(\.scrollEdgeFade) { $0.isEnabled = isEnabled }
    }

    /// Narrows which edges may fade, keeping everything else about the
    /// inherited fade — including a caller further out having switched it off.
    public func scrollEdgeFade(edges: Edge.Set) -> some View {
        transformEnvironment(\.scrollEdgeFade) { $0.edges.formIntersection(edges) }
    }
}

/// Which edges are currently worth softening.
///
/// Split out of the view so the rule can be read on its own: a fade is not a
/// decoration on a scroll view, it is a statement that there is content in that
/// direction.
struct ScrollEdgeFadeMask: Equatable {
    var fadesTop: Bool
    var fadesBottom: Bool

    /// - Parameters:
    ///   - offset: How far the content has been scrolled from its top.
    ///   - contentLength: The content's full height.
    ///   - containerLength: The visible height.
    ///   - edges: Which edges are allowed to fade at all.
    init(
        offset: CGFloat,
        contentLength: CGFloat,
        containerLength: CGFloat,
        edges: Edge.Set = [.top, .bottom]
    ) {
        // A point of slack at both ends: content and container agree only to
        // within rounding when a list exactly fills its ceiling, and a
        // half-point of overflow is not something anyone can scroll to.
        let overflows = contentLength > containerLength + 1
        fadesTop = edges.contains(.top) && overflows && offset > 1
        fadesBottom = edges.contains(.bottom)
            && overflows
            && offset < contentLength - containerLength - 1
    }

    /// Both edges sharp. What a block that fits, or one with fading switched
    /// off, is masked with — the mask is applied unconditionally, because
    /// adding and removing it as the user scrolls would change the scroll
    /// view's identity and throw its offset away mid-gesture.
    static let none = ScrollEdgeFadeMask(fadesTop: false, fadesBottom: false)

    private init(fadesTop: Bool, fadesBottom: Bool) {
        self.fadesTop = fadesTop
        self.fadesBottom = fadesBottom
    }

    /// The gradient that draws it.
    ///
    /// Both stops exist whether or not their edge fades; an edge that does not
    /// fade puts its pair at the same location, which is a hard transition and
    /// leaves that end fully opaque.
    func gradient(length: CGFloat, over height: CGFloat) -> LinearGradient {
        // Never more than half from either end, or two fades on a short block
        // meet in the middle and the content disappears.
        let fraction = height > 0 ? min(length / height, 0.5) : 0
        return LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: fadesTop ? fraction : 0),
                .init(color: .black, location: fadesBottom ? 1 - fraction : 1),
                .init(color: .clear, location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
