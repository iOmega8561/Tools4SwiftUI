//
//  InfoWarningPopover.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 16/11/24.
//

import SwiftUI

public struct InfoWarningPopover: View {
    
    public let textWhenNormal: String
    public let textWhenWarning: String
    @Binding public var warningIsShown: Bool
    
    @State private var popoverIsShown: Bool = false
    
    public var body: some View {
        Button { popoverIsShown.toggle() } label: {
            
            Image(systemName: warningIsShown ? "exclamationmark.triangle":"info.circle")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: 18.5, height: 18.5)
                .foregroundStyle(warningIsShown ? .yellow:.secondary)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $popoverIsShown) {
            
            Text(LocalizedStringKey(warningIsShown ? textWhenWarning:textWhenNormal))
                .multilineTextAlignment(.leading)
                .frame(width: 300)
                .padding()
        }
    }
}
