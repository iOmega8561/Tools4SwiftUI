//
//  BubbleContainer.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 14/10/24.
//

import SwiftUI

public struct BubbleContainer<Content: View>: View {
    
    private let label: String
    
    private let withPadding: Bool
    
    @ViewBuilder private let content: () -> Content
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(LocalizedStringKey(label))
                .font(.title3)
                .padding(.leading)
            
            ZStack {
                
                Rectangle()
                    .fill(.thinMaterial)
                
                VStack {
                    content()
                }
                .padding(.vertical, withPadding ? 10:0)
                .padding(.horizontal, withPadding ? nil:0)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 2.0)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    public init(
        _ label: String,
        withPadding: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.content = content
        self.withPadding = withPadding
    }
    
}
