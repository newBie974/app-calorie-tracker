# Flutter

A modern Flutter-based mobile application utilizing the latest mobile development technologies and tools for building responsive cross-platform applications.

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:

To run the app with environment variables defined in an env.json file, follow the steps mentioned below:
1. Through CLI
    ```bash
    flutter run --dart-define-from-file=env.json
    ```
2. For VSCode
    - Open .vscode/launch.json (create it if it doesn't exist).
    - Add or modify your launch configuration to include --dart-define-from-file:
    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Launch",
                "request": "launch",
                "type": "dart",
                "program": "lib/main.dart",
                "args": [
                    "--dart-define-from-file",
                    "env.json"
                ]
            }
        ]
    }
    ```
3. For IntelliJ / Android Studio
    - Go to Run > Edit Configurations.
    - Select your Flutter configuration or create a new one.
    - Add the following to the "Additional arguments" field:
    ```bash
    --dart-define-from-file=env.json
    ```

## 📁 Project Structure

```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```

## 🧩 Adding Routes

To add new routes to the application, update the `lib/routes/app_routes.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```

## 🎨 Theming

This project includes a comprehensive theming system with both light and dark themes:

```dart
// Access the current theme
ThemeData theme = Theme.of(context);

// Use theme colors
Color primaryColor = theme.colorScheme.primary;
```

The theme configuration includes:
- Color schemes for light and dark modes
- Typography styles
- Button themes
- Input decoration themes
- Card and dialog themes

## 📱 Responsive Design

The app is built with responsive design using the Sizer package:

```dart
// Example of responsive sizing
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)
```
## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🔧 iOS Deployment Troubleshooting

If you encounter issues when deploying to an iOS device, follow these steps:

### Device Preparation

1. **Ensure your iPhone is properly connected and unlocked**
   - Connect your iPhone to your Mac using a USB cable
   - Make sure the iPhone is unlocked
   - If prompted on the iPhone, tap "Trust This Computer"

2. **Set up your Apple Developer account in Xcode**
   - Open Xcode
   - Go to Xcode > Preferences > Accounts
   - Add your Apple ID if not already added
   - Select your Apple ID and click "Manage Certificates"
   - Click the "+" button to create a new Apple Development Certificate if needed

3. **Enable Developer Mode on your iPhone**
   - On your iPhone, go to Settings > Privacy & Security
   - Scroll down and tap on "Developer Mode"
   - Toggle Developer Mode on
   - Your iPhone will restart

4. **Configure your app for development**
   - Open your Flutter project in Xcode (open ios/Runner.xcworkspace)
   - Select the "Runner" project in the project navigator
   - In the "Signing & Capabilities" tab, ensure:
     - Your Team is selected
     - Signing Certificate is set to "Development"

5. **Common error solutions**
   - If you see "iPhone needs to be prepared for development":
     - Ensure the device is unlocked
     - Trust the computer on the iPhone if prompted
     - Enable Developer Mode as described above
   - If you see "Could not find Developer Disk Image":
     - Update Xcode to the latest version
     - Ensure your iOS version is supported by your Xcode version
   - If you see "Problem signing your application prior to installation on the device":
     - Verify that the Bundle Identifier matches your signing identity in Xcode
     - Open Xcode with `open ios/Runner.xcworkspace`
     - Select the Runner project in the project navigator
     - Go to the "Signing & Capabilities" tab
     - Ensure "Automatically manage signing" is checked
     - Select your development team
     - Try selecting 'Product > Build' to rebuild the project
     - If issues persist, try cleaning the build folder with 'Product > Clean Build Folder'

## 🙏 Acknowledgments
- Built with [Rocket.new](https://rocket.new)
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design

Built with ❤️ on Rocket.new
