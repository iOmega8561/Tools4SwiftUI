# Tools4SwiftUI

<div align="center">
  <a href="https://developer.apple.com/xcode/swiftui/">
    <img src="https://upload.wikimedia.org/wikipedia/en/5/55/SwiftUI_logo.png" width="150" height="150">
  </a>

  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/download/)
  <p>A collection of reusable components and utilities to enhance SwiftUI development,<br>with a focus on flexibility, customization, and modern UI design.</p>
  
</div>

---

## Features

Tools4SwiftUI provides a powerful suite of components and utilities designed to simplify SwiftUI development. With a focus on reusability and flexibility, these tools are perfect for building modern, feature-rich applications.

### **Just a Taste**
Here are some of the highlights:

- **Run asynchronous tasks:** Simplify task management with components like `BootstrapTask` and `AsyncButton`.
- **Create modern UI elements:** Use components like `BubbleContainer`, `ComplexPicker`, and `ComplexStepper` for visually appealing and interactive designs.
- **Enhance macOS apps:** Add powerful features like `SceneCommands` and `WindowFullScreenPresentationOptions` for macOS-specific customization.
- **Localization:** Most components in Tools4SwiftUI are compatible with SwiftUI's localization system. `LocalizedStringKey` will get you covered.

> [!TIP]
> If you're a **macOS developer** targeting older OS versions, Tools4SwiftUI might be the perfect fit! The package **backports** newer SwiftUI features to macOS 14.xx Sonoma by wrapping AppKit functionality in **View** or **ViewModifier** structs. For instance, `WindowFullScreenPresentationOptions` mimics the behavior of `WindowToolbarFullScreenVisibility` introduced in macOS 15.xx.

---

## Example Snippet

Here's an example showcasing advanced functionality using `AsyncFileButton` to integrate macOS file selection with asynchronous processing:

```swift
import Tools4SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    var body: some View {

        AsyncFileButton("Select a File", allowedContentType: .plainText) { fileURL in

            print("Processing file: \(fileURL.path)")

            // Perform your async task with the selected file
            try await processFile(fileURL)
        }
        .padding()
    }

    func processFile(_ url: URL) async throws {
        // Simulate async processing
        await Task.sleep(1_000_000_000)
        print("File processed successfully: \(url.lastPathComponent)")
    }
}
```

---

## Explore the Source Code

Each component in Tools4SwiftUI is thoroughly documented in the source code. Check out the inline documentation to:

- Learn about each component's purpose and functionality.
- Explore detailed examples and usage guidelines.
- Discover customization options for your projects.

You can browse the source code directly to discover what this awesome package reserves for you!

---

## Installation

### Swift Package Manager (SPM)
Add the package to your Xcode project:

1. In Xcode, go to **File > Add Packages**.
2. Enter the URL for this repository:  
   ```plaintext
   https://github.com/iOmega8561/Tools4SwiftUI.git
   ```
3. Choose the appropriate version rules and add the package.

---

## Why Tools4SwiftUI?

Whether you're looking for convenience, customization, or just a quicker way to build modern SwiftUI apps, Tools4SwiftUI has you covered. With detailed documentation and easy integration, you can get started right away.
