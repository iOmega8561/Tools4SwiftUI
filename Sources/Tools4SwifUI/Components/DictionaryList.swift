//
//  DictionaryList.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 11/10/24.
//

import SwiftUI

public struct DictionaryList<K: Hashable, V: Any, Label: View>: View {
    
    private let dict: [K: V]

    @Binding private var selection: K?
    
    @ViewBuilder private var content: (K) -> Label
    
    private let sortingClosure: (K, K) -> Bool
    
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
