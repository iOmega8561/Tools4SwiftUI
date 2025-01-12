//
//  DictionaryList.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 11/10/24.
//

/// `DictionaryList` is a scrollable list view that displays keys from a dictionary, with customizable sorting and content.
///
/// This view renders a list of keys from a dictionary and allows users to select an item. The selected item is highlighted,
/// and the view optionally scrolls to the selection when it changes. The content and sorting of the keys are customizable,
/// providing flexibility for different use cases.
///
/// - Note:
///   - The dictionary values (`V`) are not directly displayed but are associated with the keys for context.
///   - The keys are sorted using a custom closure provided during initialization.
///
/// - Generics:
///   - `K`: The type of the dictionary's keys. Must conform to `Hashable`.
///   - `V`: The type of the dictionary's values. Can be any type.
///   - `Label`: The view type used to render each key in the list.
public struct DictionaryList<K: Hashable, V: Any, Label: View>: View {
    
    /// The dictionary containing the keys and values to be displayed.
    ///
    /// Only the keys are displayed in the list, sorted and styled as per the provided closures.
    private let dict: [K: V]

    /// A binding to the currently selected key.
    ///
    /// When a user taps on an item in the list, this binding is updated with the selected key.
    @Binding private var selection: K?
    
    /// A closure that provides the content for each key in the list.
    ///
    /// This closure takes a key as input and returns a SwiftUI `View` to be displayed for that key.
    @ViewBuilder private var content: (K) -> Label
    
    /// A closure that defines the sorting order of the keys.
    ///
    /// This closure compares two keys and determines their order in the list. For example, sorting keys alphabetically
    /// or by specific criteria.
    private let sortingClosure: (K, K) -> Bool
    
    /// The body of the `DictionaryList`, defining its layout and behavior.
    ///
    /// The list:
    /// - Displays keys in a scrollable view, sorted by the provided `sortingClosure`.
    /// - Highlights the selected key with a distinct background color and text style.
    /// - Scrolls to the selected key with an animation when the selection changes.
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(dict.keys.sorted(by: sortingClosure), id: \.self) { item in
                    
                    Button(action: { selection = item }) {
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(item == selection ? Color.accentColor.opacity(0.65):Color.clear)
                        
                            .overlay {
                                content(item)
                                    .foregroundStyle(item == selection ? Color.white:.primary)
                            }
                        
                            .frame(height: 55)
                            
                            .padding(.horizontal)
                        
                            .contentShape(RoundedRectangle(cornerRadius: 5.0))
                    }
                    .buttonStyle(.plain)
                    
                    .onChange(of: selection) {
                        withAnimation(.linear) {
                            proxy.scrollTo(selection)
                        }
                    }
                }
            }
            .animation(.bouncy, value: dict.keys)
        }
    }
    
    /// Initializes a `DictionaryList` with the given parameters.
    ///
    /// - Parameters:
    ///   - dict: The dictionary containing the keys and values to be displayed.
    ///   - selection: A binding to the currently selected key.
    ///   - content: A closure that provides a custom view for each key.
    ///   - sortedBy: A closure that defines the sorting order of the keys.
    public init(
        _ dict: [K : V],
        selection: Binding<K?>,
        content: @escaping (K) -> Label,
        sortedBy sortingClosure: @escaping (K, K) -> Bool
    ) {
        self.dict = dict
        self._selection = selection
        self.content = content
        self.sortingClosure = sortingClosure
    }
}
