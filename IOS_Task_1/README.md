# Location Card Game

A location-aware, automated card game built natively for iOS. This project demonstrates the integration of hardware GPS capabilities with a modern, responsive user interface.

## 📱 About the Project

The Location Card Game asks the user for their name and pulls their device's real-world GPS coordinates upon launch. Based on their longitude, the game assigns the player to either the "East Side" or the "West Side" of the board. 

Once initialized, the game runs a fully automated 10-round loop, drawing from a standard 52-card deck. Cards are revealed for 3 seconds before flipping face-down, with points automatically awarded to the highest card. In the event of a tie after 10 rounds, the "House" (PC) takes the win.

## ✨ Key Features

* **CoreLocation Integration:** Requests one-time location permissions to determine the player's geographic hemisphere relative to a defined midpoint.
* **Automated Game Loop:** Utilizes asynchronous dispatch queues to manage a seamless, timer-based gameplay cycle without requiring user intervention.
* **Vector Graphics:** The UI is built entirely using Apple's native SF Symbols, keeping the app lightweight while providing crisp, dynamically colored icons for a full 52-card standard deck.
* **Data Persistence:** Leverages `@AppStorage` to save the player's name across app sessions.
* **MVVM Architecture:** Strictly separates the visual interface (SwiftUI) from the game state and logic.

## 🛠 Tech Stack

* **Language:** Swift
* **Framework:** SwiftUI
* **Hardware APIs:** CoreLocation
* **Architecture:** MVVM (Model-View-ViewModel)




link to drive - https://drive.google.com/file/d/1WtksifZzU5rVB9eiDgMO34VrMdrDR7AI/view?usp=sharing


