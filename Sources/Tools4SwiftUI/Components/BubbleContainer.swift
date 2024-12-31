//
//  BubbleContainer.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 14/10/24.
//

import SwiftUI

/// `BubbleContainer` is a reusable container view with a styled background and an optional label.
///
/// This view provides a visually distinct "bubble" container with a rounded rectangle background and
/// an optional label. It is designed to wrap custom content provided by the user, applying padding and
/// additional styling such as a material background and a border.
///
/// - Note:
///   - The container's label is localized using `LocalizedStringKey`.
///   - The content is styled with optional padding, and the background uses a `thinMaterial` effect for a modern appearance.
///   - The container also includes a border with a customizable corner radius.
///
/// - Generics:
///   - `Content`: The type of view that will be wrapped by the container.
public struct BubbleContainer<Content: View>: View {
    
    /// The label displayed at the top of the container.
    ///
    /// This text is localized using `LocalizedStringKey`, making it compatible with SwiftUI's localization system.
    private let label: String
    
    /// A Boolean value that determines whether the content should have padding.
    ///
    /// When set to `true`, vertical and horizontal padding is applied to the content. When set to `false`,
    /// only minimal vertical padding is applied, and horizontal padding is removed.
    private let withPadding: Bool
    
    /// The content to be displayed inside the bubble container.
    ///
    /// This is a `ViewBuilder` closure, allowing flexible customization of the container's content.
    @ViewBuilder private let content: () -> Content
    
    /// The body of the `BubbleContainer`, defining its appearance and behavior.
    ///
    /// The container includes:
    /// - A label displayed at the top with a title font.
    /// - A rounded rectangle background with a `thinMaterial` fill and a border.
    /// - The custom content wrapped within a vertical stack.
    /// - Optional padding controlled by the `withPadding` parameter.
    public var body: some View {
        
        VStack(alignment: .leading) {
            
            // Label at the top of the container
            Text(LocalizedStringKey(label))
                .font(.title3)
                .padding(.leading)
            
            // Main content container with background and border
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
    
    /// Initializes a `BubbleContainer` with the specified label, padding option, and content.
    ///
    /// - Parameters:
    ///   - label: A `String` displayed as the container's label, localized using `LocalizedStringKey`.
    ///   - withPadding: A Boolean value determining whether the content should have padding. Default is `true`.
    ///   - content: A closure that defines the custom content to display inside the container.
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