import SwiftUI

/// A scroll view exactly as tall as its content, until that content reaches a
/// ceiling — after which it stops growing and scrolls inside itself.
///
/// A transcript is a scroll view full of other people's output, and output has
/// no length limit. A hundred-line command result laid out at full height
/// pushes the answer off screen; the same result capped at a few hundred points
/// stays a detail you can look into. Xcode's transcript entries and ChatGPT's
/// command output both solve it exactly this way.
///
/// Two behaviours matter as much as the ceiling:
///
/// - **Scrolling is off while the content fits.** Otherwise this view swallows
///   the drag from the transcript behind it, and the page stops scrolling
///   wherever the pointer happens to sit over a short tool result.
/// - **The bottom can stay pinned as content grows**, which is what makes
///   streaming output readable — new lines arrive at the bottom edge instead of
///   pushing earlier ones out of sight.
///
/// This is the SwiftUI half of the pattern, and it is the right half for
/// anything laid out by SwiftUI.
///
/// The ceiling, the scroll gesture and the pinned bottom work on every
/// supported system. The softened edges need `onScrollGeometryChange` and are
/// drawn on iOS 18, macOS 15, tvOS 18 and watchOS 11 and later; see
/// ``ScrollEdgeFade``.
public struct ScrollViewThatFits<Content: View>: View {
    public let maxHeight: CGFloat
    /// Terminal output needs both axes: a build log is tall, and a single
    /// stack-trace line is wider than any window. Only height is ever capped —
    /// width is whatever the container gives.
    public var axes: Axis.Set
    /// Whether the view follows its content down as it grows. True for output
    /// still arriving; false for anything finished, where the user expects to
    /// start reading at the top.
    public var pinsToBottom: Bool
    @ViewBuilder public let content: Content

    /// The content's unconstrained height. Measured rather than derived: only
    /// the content knows how tall it wants to be at this width, and a
    /// `ScrollView` will always claim whatever it is offered.
    @State private var contentHeight: CGFloat = 0
    public init(
        maxHeight: CGFloat,
        axes: Axis.Set = .vertical,
        pinsToBottom: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.maxHeight = maxHeight
        self.axes = axes
        self.pinsToBottom = pinsToBottom
        self.content = content()
    }

    /// Give the gesture back to the transcript when there is nothing to scroll
    /// here — but only when height was the sole axis. A one-line output that
    /// runs off the right edge still has somewhere to go.
    private var yieldsScrollGesture: Bool {
        axes == .vertical && contentHeight <= maxHeight
    }

    /// The height this view settles at, which is also what the fade is measured
    /// against.
    private var height: CGFloat {
        min(contentHeight, maxHeight)
    }

    public var body: some View {
        ScrollView(axes) {
            content
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.height
                } action: { height in
                    contentHeight = height
                }
        }
        // `height`, not `maxHeight`: a scroll view offered a range takes the
        // whole range, so the exact height has to be handed to it.
        .frame(height: height)
        .modifier(ScrollEdgeFadeModifier(height: height))
        .scrollDisabled(yieldsScrollGesture)
        .scrollBounceBehavior(.basedOnSize)
        // Leading, not centred. `.top` is (0.5, 0), so on a view that also
        // scrolls horizontally it centres the content and cuts the start of
        // every line off the left edge — which is exactly where a command's
        // output begins.
        .defaultScrollAnchor(pinsToBottom ? .bottomLeading : .topLeading)
    }
}

/// Softens the edges of a capped scroll view that can still scroll towards them.
///
/// On systems without `onScrollGeometryChange` it leaves the content alone.
private struct ScrollEdgeFadeModifier: ViewModifier {
    let height: CGFloat

    /// Which edges currently have content beyond them.
    @State private var mask: ScrollEdgeFadeMask = .none
    @Environment(\.scrollEdgeFade) private var fade

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            content
                .onScrollGeometryChange(for: ScrollEdgeFadeMask.self) { geometry in
                    ScrollEdgeFadeMask(
                        // Normalised so rest against the top reads as zero: a scroll
                        // view starts at minus its own top inset, not at nothing.
                        offset: geometry.contentOffset.y + geometry.contentInsets.top,
                        contentLength: geometry.contentSize.height,
                        containerLength: geometry.containerSize.height,
                        edges: fade.edges
                    )
                } action: { _, newMask in
                    mask = newMask
                }
                .mask((fade.isEnabled ? mask : .none).gradient(length: fade.length, over: height))
        } else {
            content
        }
    }
}

extension View {
    /// Caps this view's height and lets it scroll inside itself past the cap.
    ///
    /// The ergonomic form of ``ScrollViewThatFits``: most call sites have a
    /// block of content already and want a ceiling on it, not a new container
    /// in the middle of their view tree.
    ///
    /// ```swift
    /// CommandOutput(lines)
    ///     .scrollHeightLimit(300, pinsToBottom: true)
    /// ```
    public func scrollHeightLimit(
        _ maxHeight: CGFloat,
        axes: Axis.Set = .vertical,
        pinsToBottom: Bool = false
    ) -> some View {
        ScrollViewThatFits(maxHeight: maxHeight, axes: axes, pinsToBottom: pinsToBottom) {
            self
        }
    }
}

#Preview("Fits, and does not", traits: .fixedLayout(width: 420, height: 620)) {
    VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 6) {
            Text("Shorter than the ceiling — hugs its content")
                .font(.caption)
                .foregroundStyle(.secondary)
            SampleLines(count: 3)
                .scrollHeightLimit(200)
                .background(.background.secondary, in: .rect(cornerRadius: 8))
        }

        VStack(alignment: .leading, spacing: 6) {
            Text("Taller than the ceiling — caps and scrolls")
                .font(.caption)
                .foregroundStyle(.secondary)
            SampleLines(count: 40)
                .scrollHeightLimit(200)
                .background(.background.secondary, in: .rect(cornerRadius: 8))
        }
    }
    .scenePadding()
}

private struct SampleLines: View {
    let count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(0..<count, id: \.self) { index in
                Text("line \(index + 1)")
                    .font(.system(.callout, design: .monospaced))
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
