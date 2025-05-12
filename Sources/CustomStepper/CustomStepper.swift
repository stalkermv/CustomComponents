//
//  CustomStepper.swift
//
//  Created by Valeriy Malishevskyi on 15.09.2024.
//

import SwiftUI

/// A control that performs increment and decrement actions.
///
/// Use a stepper control when you want the user to have granular control while
/// incrementing or decrementing a value. For example, you can use a stepper
/// to:
///
///  * Change a value up or down by `1`.
///  * Operate strictly over a prescribed range.
///  * Step by specific amounts over a stepper's range of possible values.
///
/// The example below uses an array that holds a number of ``Color`` values,
/// a local state variable, `value`, to set the control's background
/// color, and title label. When the user clicks or taps the stepper's
/// increment or decrement buttons, SwiftUI executes the relevant
/// closure that updates `value`, wrapping the `value` to prevent overflow.
/// SwiftUI then re-renders the view, updating the text and background
/// color to match the current index:
///
///     struct StepperView: View {
///         @State private var value = 0
///         let colors: [Color] = [.orange, .red, .gray, .blue,
///                                .green, .purple, .pink]
///
///         func incrementStep() {
///             value += 1
///             if value >= colors.count { value = 0 }
///         }
///
///         func decrementStep() {
///             value -= 1
///             if value < 0 { value = colors.count - 1 }
///         }
///
///         var body: some View {
///             Stepper {
///                 Text("Value: \(value) Color: \(colors[value].description)")
///             } onIncrement: {
///                 incrementStep()
///             } onDecrement: {
///                 decrementStep()
///             }
///             .padding(5)
///             .background(colors[value])
///         }
///     }
///
/// ![A view displaying a stepper that uses a text view for stepper's title and that changes the background color of its view when incremented or decremented. The view selects the new background color from a predefined array of colors using the stepper's value as the index.](SwiftUI-Stepper-increment-decrement-closures.png)
///
/// The following example shows a stepper that displays the effect of
/// incrementing or decrementing a value with the step size of `step` with
/// the bounds defined by `range`:
///
///     struct StepperView: View {
///         @State private var value = 0
///         let step = 5
///         let range = 1...50
///
///         var body: some View {
///             Stepper(
///                 value: $value,
///                 in: range,
///                 step: step
///             ) {
///                 Text("Current: \(value) in \(range.description) " +
///                      "stepping by \(step)")
///             }
///             .padding(10)
///         }
///     }
///
/// ![A view displaying a stepper with a step size of five, and a prescribed range of 1 though 50.](SwiftUI-Stepper-value-step-range.png)
@available(iOS 13.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
@MainActor public struct CustomStepper<Label> : View
where Label : View {
    
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.customStepperStyle) private var style
    @Environment(\.customStepperElementStyle) private var elementStyle
    
    private let label: Label
    private let onIncrement: () -> ((() -> Void)?)
    private let onDecrement: () -> ((() -> Void)?)
    private let onEditingChanged: (Bool) -> Void

    /// Creates a stepper instance that performs the closures you provide when
    /// the user increments or decrements the stepper.
    ///
    /// Use this initializer to create a control with a custom title that
    /// executes closures you provide when the user clicks or taps the
    /// stepper's increment or decrement buttons.
    ///
    /// The example below uses an array that holds a number of ``Color`` values,
    /// a local state variable, `value`, to set the control's background
    /// color, and title label. When the user clicks or taps on the stepper's
    /// increment or decrement buttons SwiftUI executes the relevant
    /// closure that updates `value`, wrapping the `value` to prevent overflow.
    /// SwiftUI then re-renders the view, updating the text and background
    /// color to match the current index:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let colors: [Color] = [.orange, .red, .gray, .blue, .green,
    ///                                .purple, .pink]
    ///
    ///         func incrementStep() {
    ///             value += 1
    ///             if value >= colors.count { value = 0 }
    ///         }
    ///
    ///         func decrementStep() {
    ///             value -= 1
    ///             if value < 0 { value = colors.count - 1 }
    ///         }
    ///
    ///         var body: some View {
    ///             Stepper {
    ///                 Text("Value: \(value) Color: \(colors[value].description)")
    ///             } onIncrement: {
    ///                 incrementStep()
    ///             } onDecrement: {
    ///                 decrementStep()
    ///             }
    ///             .padding(5)
    ///             .background(colors[value])
    ///         }
    ///    }
    ///
    /// ![A view displaying a stepper that uses a text view for stepper's title
    ///   and that changes the background color of its view when incremented or
    ///   decremented. The view selects the new background color from a
    ///    predefined array of colors using the stepper's value as the
    ///   index.](SwiftUI-Stepper-increment-decrement-closures.png)
    ///
    /// - Parameters:
    ///     - label: A view describing the purpose of this stepper.
    ///     - onIncrement: The closure to execute when the user clicks or taps
    ///       the control's plus button.
    ///     - onDecrement: The closure to execute when the user clicks or taps
    ///       the control's minus button.
    ///     - onEditingChanged: A closure called when editing begins and ends.
    ///       For example, on iOS, the user may touch and hold the increment
    ///       or decrement buttons on a `Stepper` which causes the execution
    ///       of the `onEditingChanged` closure at the start and end of
    ///       the gesture.
    public init(
        @ViewBuilder label: () -> Label,
        onIncrement: @escaping () -> ((() -> Void)?),
        onDecrement: @escaping () -> ((() -> Void)?),
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.label = label()
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
        self.onEditingChanged = onEditingChanged
    }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SwiftUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View {
        
        let resolvedOnIncrement = onIncrement()
        let resolvedOnDecrement = onDecrement()
        
        let elementConfiguration = CustomStepperElementConfiguration(
            onIncrement: resolvedOnIncrement ?? {},
            onDecrement: resolvedOnDecrement ?? {}
        )
        
        let decrement = (elementStyle ?? style).makeDecrement(configuration: elementConfiguration)
            .disabled(resolvedOnDecrement == nil)
        
        let increment = (elementStyle ?? style).makeIncrement(configuration: elementConfiguration)
            .disabled(resolvedOnIncrement == nil)
        
        let configuration = CustomStepperConfiguration(
            label: .init(body: .init(label)),
            onIncrement: resolvedOnIncrement ?? {},
            onDecrement: resolvedOnDecrement ?? {},
            decrement: .init(body: .init(decrement)),
            increment: .init(body: .init(increment))
        )
        
        let view = style.resolve(configuration)
        AnyView(view)
    }
}

private struct CustomStepperResolver<Style>: View
where Style: CustomStepperStyle {
    let style: Style
    let configuration: CustomStepperConfiguration
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

extension CustomStepperStyle {
    @MainActor func resolve(_ configuration: CustomStepperConfiguration) -> some View {
        CustomStepperResolver(style: self, configuration: configuration)
    }
}

private struct PreviewStepperStyle: CustomStepperStyle {
    @Environment(\.lineLimit) private var lineLimit
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.decrement
            VStack {
                configuration.label
                Text("Line limit: \(String(describing: lineLimit))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            configuration.increment
        }
        .padding()
        .background(Color.gray)
    }
    
    func makeIncrement(configuration: CustomStepperElementConfiguration) -> some View {
        Button(action: configuration.onIncrement) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundStyle(.purple)
                .bold()
        }
    }
    
    func makeDecrement(configuration: CustomStepperElementConfiguration) -> some View {
        Button(action: configuration.onDecrement) {
            Image(systemName: "minus")
        }
        .clipShape(.circle)
    }
}

private struct PreviewView: View {
    @State private var value = 0

    private let step = 1
    
    var body: some View {
        VStack {
            CustomStepper("Value is \(value)", value: $value, step: step) { isChanged in
                print("Is changed: \(isChanged)")
            }
            .customStepperStyle(PreviewStepperStyle())
            
            CustomStepper(value: $value, in: 0...10, step: step) {
                Text("Value is \(value)")
            } onEditingChanged: {
                print("Is editing: \($0)")
            }
        }
        .environment(\.lineLimit, 20)
    }
}

#Preview {
    PreviewView()
}
