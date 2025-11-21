# Team Pantry
"What's on my Shelf?"

A Fall 2025 Senior Project
MSU Denver

## Getting Started

What's on my Shelf is designed to be a food restocking inventory system. The goals of our algorithm are as follows:

1.	The algorithm will collect data on the user's current inventory, items they are using more often, and the pricing of items from different brands.
2.	The algorithm will keep track of how quickly each item purchased is being used.
3.	The algorithm will be configurable with restocking thresholds to keep track of how much of an item you have left.
4.	The algorithm will have item prioritization that will also be configurable.
5.	The algorithm will be able to keep track of how much of an item needs to be purchased if the user is using more of an ingredient.
6.	The algorithm will format all of this information into a grocery list that the user can edit and manage.
7.	The algorithm will remove items from the user's inventory when recipes are being made.
8.	Over time, the algorithm will become refined with more data and communication from the user.

The goal of this project is to create an application for home cooks who look to save money, reduce waste, and prevent over stock.
What’s on my Shelf is a automated restocking engine that makes all of  your food inventory easy to maintain, refresh, and manage. 

# What's on my Shelf Application

A Flutter-based application to manage your kitchen pantry, track expiration dates, store recipes, and manage shopping lists.

## Features
- **Inventory Tracking:** Track quantity and expiration dates of food items.
- **Barcode Scanning:** Quickly add items by scanning barcodes.
- **Recipe Management:** Store recipes and automatically check/deduct ingredients from inventory.
- **Smart Shopping Lists:** Manage lists for multiple stores and easily restock items.
- **Local Database:** All data is saved persistently on your device using SQLite.
- **Customizable Settings:** Set custom expiration warning thresholds.

---

## Testing Strategy

This project utilizes a three-tier testing strategy to ensure stability and reliability.

### 1. Unit Tests (`test/models_test.dart`)
We use unit tests to verify the logic of our data models.
- **Scope:** Tests `InventoryItem` and `Recipe` models.
- **Purpose:** Ensures data converts correctly to/from the database (JSON/Map conversion) and that logic is sound.
- **Run Command:**
  ```bash
  flutter test test/models_test.dart"

### 2. Widget Tests (test/inventory_list_item_test.dart)
We use widget tests to verify that individual UI components render correctly.

- **Scope:** Tests the InventoryListItem widget.

- **Purpose:** Verifies that the widget displays the correct name, quantity, and expiration date when provided with data.

- **Run Command:**
   ```bash
   flutter test test/inventory_list_item_test.dart
 
### 3. Integration Tests (integration_test/app_test.dart)
We use integration tests to simulate a real user interacting with the app on a device.

- **Scope:** Tests the full app flow.

- **Purpose:** Launches the app, taps the "Add" button, and verifies that the "Scan Barcode" and "Enter Manually" options appear.

- **Run Command:**

    ```bash
    flutter test integration_test/app_test.dart

## Installation & Running ##
Prerequisites
Flutter SDK installed and configured.
Android: Android Studio installed, and an Android Emulator or physical device connected.
iOS: Xcode installed (macOS only), and an iOS Simulator or physical device connected.

### 🤖 Android Installation ###
Option A: Run Debug Version
Connect your Android device via USB (ensure USB Debugging is enabled in Developer Options) or launch an Android Emulator.

Run the following command in the project terminal:

  bash
  flutter run

Option B: Install Release APK
To generate a standalone file that you can install on any Android device:

Build the APK:

  bash
  flutter build apk --release

The file will be created at: build/app/outputs/flutter-apk/app-release.apk.

Transfer this file to your phone (via USB, Drive, etc.) and tap it to install.

### 🍎 iOS Installation (macOS Only) ###
Option A: Run Debug Version
Open the iOS Simulator OR connect your iPhone via USB.

Run the following command:
  
  bash
  flutter run

Note: If using a physical iPhone, you must open ios/Runner.xcworkspace in Xcode and sign the app with your Apple ID.

Option B: Install via TestFlight
Open ios/Runner.xcworkspace in Xcode.

Select Product > Archive from the top menu.

Once the archive is complete, use the Distribute App button to upload the build to App Store Connect.

Install the app on your device using the TestFlight app.

## Troubleshooting ##
"CMake Error" on Windows: If you see a CMake error regarding generated_config.cmake, run:

  bash
  
  flutter clean
  flutter pub get
  flutter run -d windows
"Symlink support" Error on Windows: Enable Developer Mode in Windows Settings:

Go to Settings > Update & Security > For developers.
Turn on Developer Mode.
Restart your terminal.
Camera Permissions: If the scanner does not open, ensure you have approved the permission popup on the device.
Android: Checked in AndroidManifest.xml.
iOS: Checked in Info.plist.

## License Information ##

App Code: Licensed under the MIT License.
You may use, modify, and share the code freely with attribution.

App Content: Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).
You are free to use and adapt the content for any purpose, including commercial use,
as long as you give proper credit.
Learn more: https://creativecommons.org/licenses/by/4.0/
