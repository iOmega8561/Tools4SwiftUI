# Tools4SwiftUI

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/en/5/55/SwiftUI_logo.png" width="150" height="150">

  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/download/)
  <p>A collection of reusable components and utilities to enhance SwiftUI development,<br>with a focus on flexibility, customization, and modern UI design.</p>
  
</div>

## Features

Tools4SwiftUI includes the following components:

### **Components**
- **`BootstrapTask`**: A view modifier to run an asynchronous task only once per view lifecycle.
- **`AsyncButton`**: A button that executes asynchronous tasks while handling its disabled state and showing a progress indicator.
- **`BubbleContainer`**: A stylish container with rounded corners and a customizable label for grouping related content.
- **`ComplexPicker`**: A flexible picker for selecting heterogeneous items with dynamic filtering and customizable labels.
- **`ComplexStepper`**: A stepper with dynamic step sizes based on customizable ranges.
- **`DictionaryList`**: A scrollable list of dictionary keys with customizable sorting and styling.
- **`InfoWarningPopover`**: A button with a popover for displaying informational or warning messages.
- **`SceneCommands`**: Custom macOS menu commands for window management and help menu integration.

### **Utilities**
- Support for asynchronous operations in UI components.
- Localization-ready components using `LocalizedStringKey`.
- Flexible customization with closures for rendering content and handling actions.

---

## Installation

### Swift Package Manager (SPM)
Add the package to your Xcode project:

1. In Xcode, go to **File > Add Packages**.
2. Enter the URL for this repository:  
   ```plaintext
   https://github.com/your-username/Tools4SwiftUI.git
   ```
3. Choose the appropriate version rules and add the package.

---

## Usage

### **BootstrapTask**
Run an asynchronous task once per view lifecycle:
```swift
MyView()
    .modifier(BootstrapTask {
        // Your async task here
    })
```

### **AsyncButton**
Create a button that executes an asynchronous task:
```swift
AsyncButton(action: { await performTask() }) {
    Text("Submit")
}
```

### **BubbleContainer**
Group related content with a labeled container:
```swift
BubbleContainer("Example Label") {
    Text("This is inside the bubble.")
}
```

### **ComplexPicker**
Select items from a heterogeneous collection:
```swift
ComplexPicker(
    array: myArray,
    value: $selectedItem,
    label: { Text($0.name) }
)
```

### **ComplexStepper**
Define a stepper with dynamic step sizes:
```swift
ComplexStepper(
    value: currentValue,
    steps: [
        (0..<10, 1),
        (10..<100, 10)
    ],
    action: { step in adjustValue(by: step) }
) {
    Text("Adjust Value")
}
```

### **DictionaryList**
Render and select dictionary keys in a scrollable list:
```swift
DictionaryList(
    myDictionary,
    selection: $selectedKey,
    content: { Text($0) },
    sortedBy: { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
)
```

### **InfoWarningPopover**
Show a popover for information or warnings:
```swift
InfoWarningPopover(
    textWhenNormal: "This is informational text.",
    textWhenWarning: "This is a warning.",
    warningIsShown: $isWarning
)
```

### **SceneCommands**
Customize macOS menu commands:
```swift
SceneCommands(websiteURL: URL(string: "https://example.com")!)
```

---

## Localization

Most components in Tools4SwiftUI are compatible with SwiftUI's localization system. Use `LocalizedStringKey` for text to ensure easy translation.

---
