# Overlayer

A powerful SwiftUI library that solves one of the most frustrating limitations in SwiftUI: displaying overlays above modal presentations like sheets and full screen covers.

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-blue?style=flat-square)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square)](https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)

<table>
  <tr>
    <th>❌ Problem</th>
    <th>✅ Solution</th>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/354cc1ae-6445-490d-ada2-b50f2bf9dfc2" alt="Standard SwiftUI Problem"></td>
    <td><img src="https://github.com/user-attachments/assets/3e1bc3a3-8c6e-48a7-b084-8558661c0c5d" alt="Overlayer Solution"></td>
  </tr>
</table>

## The Problem

Standard SwiftUI doesn't provide a clean way to display UI elements above sheets and full screen covers.

When you present a modal view:

- Any overlays in the parent view become invisible
- ZStack with high z-index values doesn't help
- There's no built-in way to show global overlays above all view hierarchies

This limitation makes it impossible to create:
- Global toasts that stay visible during modal presentations
- Picture-in-picture videos that remain on screen regardless of navigation
- System-wide alerts that appear above all content
- Custom loading indicators that don't disappear during sheet transitions

## The Solution

Overlayer solves this problem by creating a separate UIWindow that exists above the entire app's view hierarchy.

This enables:

- Toast notifications that remain visible above sheets and full screen covers
- Draggable PiP video players that persist across view transitions
- Custom alerts that always appear on top
- Any overlay UI that needs to exist above all other content

## Usage

### Step 1: Wrap your root content with OverlayerRootView

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            OverlayerRootView {
                ContentView()
            }
        }
    }
}
```

### Step 2: Add overlays using the view modifier

Overlayer provides two main API styles:

#### Boolean Binding API

```swift
struct ContentView: View {
    @State private var showToast = false

    var body: some View {
        VStack {
            Button("Show Toast") {
                showToast = true

                // Auto-dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
        .overlayer(isPresented: $showToast) {
            ToastView(message: "This is a toast!")
        }
    }
}
```

#### Optional Binding API

```swift
struct ContentView: View {
    @State private var selectedProduct: Product? = nil

    var body: some View {
        List(products) { product in
            Button(product.name) {
                selectedProduct = product
            }
        }
        .overlayer(item: $selectedProduct) { product in
            ProductDetailView(product: product, isPresented: $selectedProduct)
        }
    }
}
```

### Animations

All overlays support standard SwiftUI transitions and animations:

```swift
.overlayer(isPresented: $showToast, animation: .spring) {
    ToastView()
        .transition(.move(edge: .top).combined(with: .opacity))
}
```

## Requirements

- iOS 17.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/tornikegomareli/Overlayer.git", from: "0.0.1")
]
```

Or add it directly through Xcode:
1. Go to File > Swift Packages > Add Package Dependency
2. Enter the repository URL: `https://github.com/tornikegomareli/Overlayer.git`
3. Specify the version constraints
4. Click Next and then Finish

## Demo Examples

You can check `OverlayerDemoPreview` for advanced and different type of examples including PiP and full screen cover.
Check `OverlayerSolutionDemo` for basic solution demo.
Check `StandardSwiftUILimitationDemo` for the core problem.

## How It Works

Overlayer uses a separate UIWindow instance to render overlays above the entire application:

1. `OverlayerRootView` creates a manager and adds it to the SwiftUI environment
2. The manager creates a new UIWindow with a higher window level
3. View modifiers communicate with the manager through the environment
4. Overlays are rendered in the separate window, above all other content

This approach bypasses SwiftUI's view hierarchy limitations, allowing overlays to appear above everything.

## License

Overlayer is available under the MIT license. See the LICENSE file for more info.

## Author

Created by [Tornike](https://github.com/tornikegomareli)

## Contribution

Any kind of contributions, finding bugs, improving API or feature ideas are kindly welcome 🤗
