//
//  Copyright 2026 Giuseppe Rocco
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
//  Bookmark.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 14/05/2026.
//

import Foundation

/// A property wrapper that persists a file URL as security-scoped bookmark data.
///
/// This wrapper handles the complexity of creating and resolving security-scoped bookmarks
/// on macOS and iOS, providing a seamless way to persist file access across app launches.
/// It includes an internal cache to avoid redundant I/O operations.
@propertyWrapper
public struct Bookmark: Sendable {
    
    // MARK: - Configuration
    
    #if os(macOS)
    /// Options used when creating the bookmark data.
    private static let creationOptions: URL.BookmarkCreationOptions = [
        .withSecurityScope,
        .securityScopeAllowOnlyReadAccess,
        .withoutImplicitSecurityScope
    ]
    
    /// Options used when resolving the bookmark data back into a URL.
    private static let resolutionOptions: URL.BookmarkResolutionOptions = [
        .withSecurityScope,
        .withoutImplicitStartAccessing
    ]
    #else
    private static let creationOptions: URL.BookmarkCreationOptions = [
        .withoutImplicitSecurityScope
    ]
    
    private static let resolutionOptions: URL.BookmarkResolutionOptions = [
        .withoutImplicitStartAccessing
    ]
    #endif

    // MARK: - Properties
    
    /// The underlying encoded bookmark data.
    private var backingData: Data?
    
    /// An in-memory cache of the resolved URL to prevent expensive I/O on every access.
    private var resolvedURL: URL?

    /// The URL represented by the bookmark.
    /// Setting this value automatically generates new bookmark data.
    public var wrappedValue: URL? {
        get { resolvedURL }
        set {
            self.resolvedURL = newValue
            self.backingData = try? newValue?.bookmarkData(options: Self.creationOptions)
        }
    }

    // MARK: - Initialization
    
    /// Initializes the wrapper with an initial URL.
    /// - Parameter wrappedValue: The initial file URL to bookmark.
    public init(wrappedValue: URL?) {
        self.resolvedURL = wrappedValue
        self.backingData = try? wrappedValue?.bookmarkData(options: Self.creationOptions)
    }
}

// MARK: - Codable Conformance

extension Bookmark: Codable {
    
    /// Decodes the bookmark data and immediately attempts to resolve it.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data?.self)
        self.backingData = data
        
        guard let data else {
            self.resolvedURL = nil
            return
        }
        
        var isStale = false
        // Resolve the URL once during decoding to populate the cache.
        let url = try? URL(
            resolvingBookmarkData: data,
            options: Self.resolutionOptions,
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        
        // If the bookmark is stale, the 'url' returned is the updated location.
        // In a struct-based wrapper, we update the cache immediately.
        self.resolvedURL = url
    }

    /// Encodes only the backing bookmark data to the container.
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(backingData)
    }
}

// MARK: - Equatable & Hashable

extension Bookmark: Equatable, Hashable {
    /// Compares two bookmarks based on their resolved URLs.
    /// - Parameters:
    ///   - lhs: The first bookmark.
    ///   - rhs: The second bookmark.
    /// - Returns: True if the resolved URLs are equal.
    public static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        lhs.resolvedURL == rhs.resolvedURL
    }

    /// Hashes the bookmark based on its resolved URL.
    /// - Parameter hasher: The hasher to use.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(resolvedURL)
    }
}
