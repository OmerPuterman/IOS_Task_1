# Location Card Game - Version 2.0

A location-aware, automated card game built natively for iOS. Version 2.0 (Task 2) introduces major architectural and UX improvements, transforming the basic game into a fully polished, store-ready application.

## 📱 About the Project

The Location Card Game asks the user for their name and pulls their device's real-world GPS coordinates upon launch. Based on their longitude, the game assigns the player to either the "East Side" or the "West Side" of the board. The game runs a fully automated 10-round loop, drawing from a standard 52-card deck.

## 🚀 What's New in Version 2.0 (Task 2)

This update focuses on advanced iOS system integrations, memory management, and user experience enhancements:

* **App Lifecycle Management (`ScenePhase`):** The app now strictly monitors its lifecycle state. If the user minimizes the app or receives a phone call, the background music and the active game timer automatically **pause**, and seamlessly **resume** exactly where they left off when the app returns to the foreground.
* **Audio Integration (`AVFoundation`):** Added a custom `SoundManager` singleton to handle background music and sound effects (card flipping, winning). The audio session is explicitly configured (`.playback`) to function correctly even if the device's physical ringer switch is set to silent.
* **Dark Mode & Dynamic UI:** Full support for system-wide Dark Mode. The UI utilizes dynamic system colors (e.g., `.primary`) and conditional styling to ensure perfect contrast and visibility across both Light and Dark themes.
* **Landscape Support:** Integrated `ScrollView` structures and flexible layouts to ensure the game remains fully playable and visually appealing in both Portrait and Landscape orientations.
* **Clean State Management:** Screen transitions are now handled safely via a unified `AppState` enum (Menu, Playing, Result) to prevent memory leaks and improper view stacking (Navigation Stack management).
* **Refactored Timer Logic:** Replaced basic delays with an invalidatable `Timer` instance to ensure accurate round pacing and safe backgrounding.

## ✨ Core Features (Retained from V1)

* **CoreLocation Integration:** Requests location permissions to determine the player's geographic hemisphere relative to a defined midpoint.
* **Vector Graphics:** The UI is built entirely using Apple's native SF Symbols, keeping the app lightweight while providing crisp, dynamically colored icons for a full 52-card standard deck.
* **Data Persistence:** Leverages `@AppStorage` to save the player's name across app sessions.
* **MVVM Architecture:** Strictly separates the visual interface (SwiftUI) from the game state and logic.

## 🛠 Tech Stack

* **Language:** Swift
* **Framework:** SwiftUI
* **Hardware APIs:** CoreLocation
* **Media APIs:** AVFoundation
* **Architecture:** MVVM (Model-View-ViewModel)

## 👨‍💻 Author

**Omer Puterman**

link to drive Task 1 - https://drive.google.com/file/d/1WtksifZzU5rVB9eiDgMO34VrMdrDR7AI/view?usp=sharing
link to drive Task 2 - https://drive.google.com/file/d/1IYXFtVRK-fD10TuLbcoUFVlzkJWzJiL8/view?usp=sharing

