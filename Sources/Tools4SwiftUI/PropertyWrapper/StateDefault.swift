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
//  StateDefault.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 14/05/2026.
//

public import SwiftUI
public import Observation

/// # `StateDefault<T>`
///
/// A property wrapper that provides `@Observable`-aware access to `UserDefaults`.
///
/// ## Overview
///
/// This wrapper combines `UserDefaults` persistence with Swift's `@Observable` macro,
/// allowing stored values to trigger observation notifications when they change.
/// Combined with `@MainActor`, it guarantees thread-safe access from the main queue.
///
/// ## Usage
///
/// ```swift
/// @StateDefault(key: "themeMode", defaultValue: .light)
/// var themeMode: Theme
///
/// // Reading
/// print(themeMode)
///
/// // Writing
/// themeMode = .dark
/// ```
///
/// The `projectedValue` (`$themeMode`) exposes a `Binding<T>` for use in
/// SwiftUI views, which automatically triggers observation notifications on write.
///
/// ## Thread Safety
///
/// The type is marked `@MainActor`, so all reads and writes are serialized
/// on the main actor. This prevents race conditions when accessing `wrappedValue`
/// from multiple threads.
///
/// ## Technical Details
///
/// - The `key` is stored at initialization time and reused for every read/write.
/// - `wrappedValue` is annotated with `@ObservationTracked`, so any change emits
///   observation notifications to observers registered on this instance.
/// - The initializer attempts to load the value from `UserDefaults`; if the
///   key is absent or the stored type doesn't match `T`, `defaultValue` is used.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0, *)
@propertyWrapper @Observable @MainActor
public final class StateDefault<T>: Sendable, Observation.Observable {
    
    /// The UserDefaults key for this property.
    private let key: String
    
    /// The stored value, observed by `@ObservationTracked`.
    /// Writes automatically persist to `UserDefaults.standard`.
    @ObservationTracked
    public var wrappedValue: T {
        didSet { UserDefaults.standard.set(wrappedValue, forKey: key) }
    }
    
    /// A `Binding<T>` exposed via `$wrappedValue`.
    public var projectedValue: Binding<T> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    /// Initializes the wrapper, loading the value from `UserDefaults`
    /// or falling back to `defaultValue`.
    public init(key: String, defaultValue: T) {
        self.key = key
        self.wrappedValue = UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
}

