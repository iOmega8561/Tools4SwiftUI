//
//  Copyright 2025 Giuseppe Rocco
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  -----------------------------------------------------------------------
//
//  ComplexPicker.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 17/11/24.
//

/// `ComplexPicker` is a flexible picker component for selecting an item from a heterogeneous collection.
///
/// This view is designed to handle collections of heterogeneous types, allowing for highly customizable item
/// rendering and filtering. The picker displays the filtered items as buttons, each styled with a rounded rectangle.
/// Selected items are visually distinguished, and the component ensures smooth interaction.
///
/// - Note:
///   - The component is generic over the collection (`Value`) and its elements (`Value.Element`), requiring
///     the elements to conform to `Hashable` for unique identification.
///   - The rendering and filtering of items are fully customizable via closures provided during initialization.
///
/// - Generics:
///   - `Value`: The collection type (e.g., `Array`, `Set`) from which items are picked. Must conform to `RandomAccessCollection`.
///   - `Label`: The view used to display each item.
public struct ComplexPicker<Value: RandomAccessCollection, Label: View>: View where Value.Element: Hashable {
    
    /// The collection of items to display in the picker.
    ///
    /// The items in `array` can be of any type, as long as they conform to `Hashable`. Only the items that pass
    /// the filtering criteria specified by `filter` are displayed.
    private let array: Value
    
    /// A closure used to filter the items in the collection.
    ///
    /// The `filter` closure is applied to each element in `array` to determine whether it should be displayed.
    /// By default, all items are included.
    private let filter: (Value.Element) -> Bool
    
    /// A binding to the currently selected item.
    ///
    /// The selected item is updated when a button representing an item is tapped. The binding ensures two-way
    /// synchronization with the state in the parent view.
    @Binding private var value: Value.Element
    
    /// A closure that provides the label view for each item.
    ///
    /// This closure takes an item from the collection as input and returns a SwiftUI `View` to be displayed
    /// for that item.
    @ViewBuilder private var label: (Value.Element) -> Label
    
    /// The body of the `ComplexPicker`, which defines its layout and behavior.
    ///
    /// The picker:
    /// - Filters the items using the `filter` closure.
    /// - Displays each filtered item as a button styled with a rounded rectangle.
    /// - Highlights the selected item using a distinct style.
    /// - Prevents interactions with already selected items.
    public var body: some View {
        
        HStack {
            
            ForEach(array.filter(filter), id: \.self) { current in
                
                Button { value = current } label: {
                    
                    RoundedRectangle(cornerRadius: .bestRadius)
                        .fill(fill(current))
                        .overlay {
                            label(current)
                                .foregroundStyle(isSelected(current) ? .white: .primary)
                        }
                        .contentShape(.rect(cornerRadius: .bestRadius))
                }
                .buttonStyle(.plain)
                .allowsHitTesting(!isSelected(current))
                
            }
        }
        
    }
    
    /// Determines whether the given item is the currently selected item.
    ///
    /// - Parameter current: The item to check.
    /// - Returns: `true` if `current` is the selected item; otherwise, `false`.
    private func isSelected(_ current: Value.Element) -> Bool {
        
        let rightComparable = Mirror(reflecting: current)
                                    .children.first?.label ?? String(describing: current)
        
        let leftComparable = Mirror(reflecting: value)
                                    .children.first?.label ?? String(describing: value)
        
        return rightComparable == leftComparable
    }
    
    /// Provides the fill style for the button representing a given item.
    ///
    /// - Parameter current: The item to style.
    /// - Returns: A shape style indicating whether the item is selected or not.
    private func fill(_ current: Value.Element) -> AnyShapeStyle {
        
        if isSelected(current) {
            return AnyShapeStyle(Color.accentColor)
        }
        
        return AnyShapeStyle(BackgroundStyle.background)
    }
    
    /// Initializes a `ComplexPicker` with the given parameters.
    ///
    /// - Parameters:
    ///   - array: The collection of items to display in the picker.
    ///   - value: A binding to the currently selected item.
    ///   - label: A closure that provides a view for each item.
    ///   - filterUsing: A closure to filter the items in `array`. Defaults to a closure that includes all items.
    public init(
        _ array: Value,
        value: Binding<Value.Element>,
        @ViewBuilder label: @escaping (Value.Element) -> Label,
        filterUsing: @escaping (Value.Element) -> Bool = { _ in return true }
    ) {
        self.array = array
        _value = value
        self.label = label
        self.filter = filterUsing
    }
}
