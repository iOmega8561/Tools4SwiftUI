//
//  ComplexPicker.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 17/11/24.
//

import SwiftUI

public struct ComplexPicker<Value: RandomAccessCollection, Label: View>: View where Value.Element: Hashable {
    
    let array: Value
    
    let filter: (Value.Element) -> Bool
    
    @Binding var value: Value.Element
    
    @ViewBuilder var label: (Value.Element) -> Label
            
    public var body: some View {
        
        HStack {
            
            ForEach(array.filter(filter), id: \.self) { current in
                
                Button { value = current } label: {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(fill(current))
                        .overlay {
                            label(current)
                                .foregroundStyle(isSelected(current) ? .white: .primary)
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .allowsHitTesting(!isSelected(current))
                
            }
        }
        
    }
    
    private func isSelected(_ current: Value.Element) -> Bool {
        
        let rightComparable = Mirror(reflecting: current)
                                    .children.first?.label ?? String(describing: current)
        
        let leftComparable = Mirror(reflecting: value)
                                    .children.first?.label ?? String(describing: value)
        
        return rightComparable == leftComparable
    }
    
    private func fill(_ current: Value.Element) -> AnyShapeStyle {
        
        if isSelected(current) {
            return AnyShapeStyle(Color.accentColor.opacity(0.9))
        }
        
        return AnyShapeStyle(BackgroundStyle.background)
    }
    
    public init(
        _ array: Value,
        value: Binding<Value.Element>,
        label: @escaping (Value.Element) -> Label,
        filterUsing: @escaping (Value.Element) -> Bool = { _ in return true }
    ) {
        self.array = array
        _value = value
        self.label = label
        self.filter = filterUsing
    }
}
