//
//  ComplexStepper.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 16/11/24.
//

import SwiftUI

public struct ComplexStepper<Label:View, ValueType: BinaryInteger>: View {

    let value: ValueType
    
    let steps: [(Range<ValueType>, Int)]
    
    let action: (Int) -> Void
    
    @ViewBuilder let label: () -> Label
    
    public var body: some View {
        
        Stepper { label() }
        
        onIncrement: { action(step(for: value, decrementing: false)) }
        
        onDecrement: { action(step(for: value, decrementing: true)) }
    }
    
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
