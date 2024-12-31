//
//  ComplexStepper.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 16/11/24.
//

import SwiftUI

/// `ComplexStepper` is a customizable stepper control with dynamic step sizes based on value ranges.
///
/// This view provides a `Stepper` component that adjusts its increment and decrement steps dynamically
/// based on the current value. The steps and their associated ranges are customizable, making this component
/// ideal for scenarios where step size varies depending on the value.
///
/// - Note:
///   - The step size is determined by a list of `(Range, Int)` tuples, where each range defines the
///     values for which the associated step size applies.
///   - The control gracefully handles edge cases, such as when the value reaches the lower bound of the first range.
///
/// - Generics:
///   - `Label`: The view type used for the stepper's label.
///   - `ValueType`: The numeric type of the value being stepped. Must conform to `BinaryInteger`.
public struct ComplexStepper<Label:View, ValueType: BinaryInteger>: View {

    /// The current value of the stepper.
    ///
    /// This value determines the starting point and is used to calculate the next step size
    /// when incrementing or decrementing.
    private let value: ValueType
    
    /// The list of ranges and their associated step sizes.
    ///
    /// Each tuple contains:
    /// - `Range`: A range of values for which the step size applies.
    /// - `Int`: The step size for that range.
    ///
    /// The ranges must cover the desired value domain and must not overlap.
    private let steps: [(Range<ValueType>, Int)]
    
    /// A closure to perform an action whenever the stepper value changes.
    ///
    /// The closure takes an `Int` argument representing the step size (positive or negative).
    private let action: (Int) -> Void
    
    /// The label displayed next to the stepper control.
    ///
    /// This closure provides a custom SwiftUI `View` that serves as the label.
    @ViewBuilder private let label: () -> Label
    
    /// The body of the `ComplexStepper`, defining its layout and behavior.
    ///
    /// The stepper:
    /// - Displays a customizable label.
    /// - Dynamically calculates the step size based on the current value and the configured ranges.
    /// - Invokes the `action` closure with the calculated step size on value change.
    public var body: some View {
        
        Stepper { label() }
        
        onIncrement: { action(step(for: value, decrementing: false)) }
        
        onDecrement: { action(step(for: value, decrementing: true)) }
    }
    
    /// Determines the step size for the given value and direction.
    ///
    /// - Parameters:
    ///   - value: The current value of the stepper.
    ///   - decrementing: A Boolean indicating whether the step is decrementing (`true`) or incrementing (`false`).
    /// - Returns: The step size as an `Int`. Negative values indicate a decrement step.
    private func step(for value: ValueType, decrementing: Bool) -> Int {
        
        var previousStep: Int = steps.first!.1
        
        for (range, step) in steps {
            
            if value == range.lowerBound && decrementing {
                return value == steps.first!.0.lowerBound ? 0:-previousStep
            }
            
            if range.contains(value) {
                return decrementing ? -step:step
            }
            
            previousStep = step
        }
        
        return decrementing ? -previousStep:0
    }
    
    /// Initializes a `ComplexStepper` with the specified parameters.
    ///
    /// - Parameters:
    ///   - value: The current value of the stepper.
    ///   - steps: A list of `(Range, Int)` tuples defining the step sizes for specific ranges.
    ///   - action: A closure invoked with the step size whenever the value changes.
    ///   - label: A closure providing a custom label for the stepper.
    ///
    /// - Returns: A `ComplexStepper` instance, or `nil` if the `steps` array is empty.
    public init?(
        value: ValueType,
        steps: [(Range<ValueType>, Int)],
        action: @escaping (Int) -> Void,
        label: @escaping () -> Label
    ) {
        
        guard !steps.isEmpty else { return nil }
        
        self.steps = steps
        self.value = value
        self.action = action
        self.label = label
    }
}
