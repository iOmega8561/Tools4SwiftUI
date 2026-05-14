//
//  UserDefault.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 14/05/2026.
//

import Foundation

/// # `UserDefault<T>`
///
/// A property wrapper that delegates `wrappedValue` to `UserDefaults`
/// with a fallback to a configurable default.
///
/// ## Overview
///
/// `UserDefault` is a `struct` that wraps access to `UserDefaults.standard`.
/// Every read retrieves the stored value for `key`, falling back to `defaultValue`
/// when the key is absent or type-unsafe. Every write persists immediately.
///
/// ## Usage
///
/// ```swift
/// @UserDefault(key: "lastRunDate", defaultValue: Date.now)
/// var lastRun: Date
///
/// // Reads the persisted value or the default
/// let today = lastRun
///
/// // Writes back and persists
/// lastRun = Date.now
/// ```
///
/// The wrapper works with any `Codable`-compatible type supported by
/// `UserDefaults.standard`.
///
/// ## Thread Safety
///
/// `UserDefaults.standard` is thread-safe for reads and writes.
/// For types `T` that conform to `Sendable`, an extension makes
/// `UserDefault<T>` itself `Sendable`, allowing the wrapper to be
/// used across concurrency boundaries.
///
/// ## Value Semantics
///
/// Because the wrapper is a `struct`, instances are copied on assignment.
/// The `key` and `defaultValue` are stored by value; only the interaction
/// with `UserDefaults.standard` involves shared mutable state.
///
/// ## Properties
///
/// - `key`: the `UserDefaults` key used for all reads and writes.
/// - `defaultValue`: the fallback value when the key has no entry.
/// - `wrappedValue`: a computed property that reads and writes `UserDefaults`.
/// - `projectedValue` (`$wrappedValue`): not provided (see previous version).
///
/// ## Implementation Notes
///
/// - The initializer stores `key` and `defaultValue` at creation time; these
///   are immutable for the lifetime of the instance.
/// - `wrappedValue.get` casts the stored object to `T` using `as?`; if the
///   cast fails, `defaultValue` is returned.
/// - `wrappedValue.set` calls `UserDefaults.standard.set(_:forKey:)` with
///   no additional synchronization.
@propertyWrapper
public struct UserDefault<T> {
    
    /// The UserDefaults key for this property.
    private let key: String
    
    /// The stored default value, observed by `@ObservationTracked`.
    /// Writes automatically persist to `UserDefaults.standard`.
    private let defaultValue: T

    /// The computed wrapped value without internal state
    /// Reads directly from `UserDefaults.standard`
    /// Writes directly to `UserDefaults.standard`.
    public var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// ## Thread Safety
///
/// `UserDefaults.standard` is thread-safe for reads and writes.
/// For types `T` that conform to `Sendable`, an extension makes
/// `UserDefault<T>` itself `Sendable`, allowing the wrapper to be
/// used across concurrency boundaries.
extension UserDefault<Sendable> : Sendable {}
