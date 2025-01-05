//
//  View.Extension.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 05/01/25.
//

import SwiftUI

extension View {
    
    /// Using this method we can simply call `.bootstrapTask` as a modifier on our Views
    /// - Parameter handler: The asynchronous closure to be executed only once
    ///
    /// - SeeAlso: `BootstrapTask`
    public func bootstrapTask(
        handler: @escaping () async throws -> Void
    ) -> some View {
        
        return self.modifier(
            BootstrapTask(handler: handler)
        )
    }
}
