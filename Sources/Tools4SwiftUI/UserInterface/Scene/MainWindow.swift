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
//  MainWindow.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 08/12/25.
//

/// A reusable scene that configures the main application window with
/// a localized title, a stable window identifier, and a matching menu
/// command to reopen the same window.
///
/// `MainWindow` centralizes common window setup so that you do not have
/// to repeat the same configuration in every app target that uses this
/// package. It ensures that:
/// - The window title is resolved using `String.crossLocalized`, so the
///   app can override package-provided translations when needed.
/// - The window has a stable identifier, which is required by the
///   `openWindow` environment action and helps keep window management
///   predictable across the app.
/// - A command is added to the app’s menu (before the `.windowSize`
///   group) that reopens this window with a consistent label and icon.
///
/// By providing a single generic `Content` view builder, `MainWindow`
/// acts as a convenient wrapper around `Window` while enforcing a
/// consistent localization and window-management pattern throughout the app.
@available(macOS 13, visionOS 26.0, *)
public struct MainWindow<Content: View>: Scene {
    
    /// The static localization key used for the window’s title and for
    /// the corresponding menu item label.
    ///
    /// This is a `StaticString` so that it can be used reliably with
    /// `String.crossLocalized`, allowing the app to provide an override
    /// in its own string catalog while still falling back to the
    /// package’s default translation when no override is available.
    private let titleKey: StaticString
    
    /// A stable identifier for this window, used both when declaring
    /// the `Window` scene and when reopening it via `openWindow(id:)`.
    ///
    /// Keeping the identifier explicit and predictable helps avoid
    /// subtle bugs where multiple windows might accidentally share
    /// the same identity or where commands target the wrong window.
    private let windowIdentifier: String
    
    /// The name of the system symbol that will be used as the icon in
    /// the menu command associated with this window.
    ///
    /// Using SF Symbols here ensures the menu command has a consistent,
    /// platform-appropriate icon while still allowing customization by
    /// passing a different symbol name from the caller.
    private let systemImage: String
    
    /// A closure that builds the content view for the window.
    ///
    /// This is stored as an escaping closure so that SwiftUI can create
    /// and recreate the window’s content as needed, while the scene
    /// itself remains simple to construct and configure.
    private let content: () -> Content
    
    /// The environment-provided action used to programmatically open a
    /// window by its identifier.
    ///
    /// This is injected by SwiftUI at runtime and allows the menu
    /// command declared in `.commands` to reopen the same window that
    /// this scene defines, keeping the identifier and behavior in sync.
    @Environment(\.openWindow) private var openWindow
    
    /// The scene definition for the main window, including both the
    /// window itself and the command used to reopen it from the menu.
    ///
    /// The window title is built using `String.crossLocalized(titleKey)`
    /// so that the app can override the translation when desired,
    /// while the package still provides a sensible default. The same
    /// key is also used in the menu label so that the title and the
    /// corresponding command remain consistent in all locales.
    @SceneBuilder public var body: some Scene {
        
        Window(
            String.crossLocalized(titleKey),
            id: windowIdentifier,
            content: content
        )
        .commands {
            CommandGroup(before: .windowSize) {
                Button {
                    openWindow(id: windowIdentifier)
                } label: {
                    Label {
                        Text(verbatim: .crossLocalized(titleKey))
                    } icon: {
                        Image(systemName: systemImage)
                    }
                }
                Divider()
            }
        }
    }
    
    /// Creates a new `MainWindow` scene with configurable title key,
    /// window identifier, system image, and content builder.
    ///
    /// The default values are chosen to be reasonable for a typical
    /// “main” window:
    /// - `titleKey` defaults to `"window-main-title"`, which allows the
    ///   package to ship a default translation while still giving the
    ///   app a chance to override it via `String.crossLocalized`.
    /// - `windowIdentifier` defaults to `"main"`, providing a stable and
    ///   memorable identifier for the primary window of the app.
    /// - `systemImage` defaults to `"macwindow.and.pointer.arrow.rtl"`,
    ///   an SF Symbol that visually communicates a main window action
    ///   in the menu.
    ///
    /// By routing the window title and menu label text through
    /// `String.crossLocalized`, this initializer ensures that any app
    /// integrating the package can customize user-facing strings in its
    /// own string catalog, while the package remains self-contained
    /// with its own localization defaults.
    ///
    /// - Parameters:
    ///   - titleKey: The static localization key used for the window
    ///     title and the menu label. Defaults to `"window-main-title"`.
    ///   - windowIdentifier: The unique identifier for this window,
    ///     used with `openWindow(id:)`. Defaults to `"main"`.
    ///   - systemImage: The SF Symbol name for the menu command icon.
    ///     Defaults to `"macwindow.and.pointer.arrow.rtl"`.
    ///   - content: A closure that produces the view hierarchy displayed
    ///     inside the main window.
    public init(
        _ titleKey: StaticString = "window-main-title",
        id windowIdentifier: String = "main",
        systemImage: String = "macwindow.and.pointer.arrow.rtl",
        content: @escaping () -> Content
    ) {
        self.titleKey = titleKey
        self.windowIdentifier = windowIdentifier
        self.systemImage = systemImage
        self.content = content
    }
}
