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
//  Optional<URL>.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 17/12/25.
//

public extension Optional where Wrapped == URL {

    /// Executes a closure while safely accessing an optional security-scoped resource.
    ///
    /// This method behaves like `URL.whileAccessingSecurityScopedResource(handler:)`, but it
    /// works when the URL is optional.
    ///
    /// If the optional contains a URL, the method attempts to start security-scoped access
    /// by calling `startAccessingSecurityScopedResource()`. A `defer` block ensures that
    /// `stopAccessingSecurityScopedResource()` is called after the closure completes—whether
    /// it returns normally or throws.
    ///
    /// If the optional is `nil`, the handler is executed normally (no security-scoped access
    /// is started or stopped).
    ///
    /// - Parameter handler: A closure that performs operations on the resource.
    ///   It can throw an error and returns a value of type `T`.
    ///
    /// - Returns: The value returned by the `handler` closure.
    ///
    /// - Throws: Re-throws any error thrown by the `handler` closure.
    ///
    /// Usage:
    ///
    ///     let result = try maybeFileURL.whileAccessingSecurityScopedResource {
    ///         // If maybeFileURL is nil, this just runs normally.
    ///         // If it's non-nil, security-scoped access is active for the duration.
    ///         return try processIfNeeded()
    ///     }
    func whileAccessingSecurityScopedResource<T>(handler: () throws -> T) rethrows -> T {

        // Attempt to start accessing the security-scoped resource.
        let accessingScopedResource: Bool = self?.startAccessingSecurityScopedResource() ?? false

        // Ensure that access is stopped after the handler executes.
        defer {
            if accessingScopedResource {
                self?.stopAccessingSecurityScopedResource()
            }
        }
        
        // Execute the handler closure while the resource is accessible.
        return try handler()
    }

    /// Executes an async closure while safely accessing an optional security-scoped resource.
    ///
    /// This async overload matches the synchronous optional variant, but allows `handler`
    /// to suspend using `await`.
    ///
    /// If the optional contains a URL, the method attempts to begin security-scoped access
    /// by calling `startAccessingSecurityScopedResource()`. A `defer` block guarantees that
    /// `stopAccessingSecurityScopedResource()` is invoked when the async operation completes,
    /// whether it returns successfully or throws.
    ///
    /// If the optional is `nil`, the handler is executed without starting or stopping any
    /// security-scoped access.
    ///
    /// - Important:
    ///   Keep the async work inside `handler` as short as practical. Avoid holding the
    ///   security-scoped access across long waits or unrelated asynchronous work.
    ///
    /// - Parameter handler: An async closure that performs operations on the resource.
    ///   It may suspend, can throw an error, and returns a value of type `T`.
    ///
    /// - Returns: The value returned by the `handler` closure.
    ///
    /// - Throws: Re-throws any error thrown by the `handler` closure.
    ///
    /// Usage:
    ///
    ///     let data = try await maybeFileURL.whileAccessingSecurityScopedResource {
    ///         // Runs with scoped access only if maybeFileURL is non-nil.
    ///         return try await loadDataIfNeeded()
    ///     }
    func whileAccessingSecurityScopedResource<T>(handler: () async throws -> T) async rethrows -> T {
        
        // Attempt to start accessing the security-scoped resource.
        let accessingScopedResource: Bool = self?.startAccessingSecurityScopedResource() ?? false

        // Ensure that access is stopped after the handler executes.
        defer {
            if accessingScopedResource {
                self?.stopAccessingSecurityScopedResource()
            }
        }
        
        // Execute the handler closure while the resource is accessible.
        return try await handler()
    }
}
