# ABC — iOS Assignment (SwiftUI + UIKit)

This repository contains a small iOS app built as a **technical test**.  
The same requirements are implemented **twice**:

- **SwiftUI implementation** (separate branch)
- **UIKit implementation** (separate branch)

Both versions share the same data models and networking approach, but render UI with their respective frameworks.

---

## Assignment Requirements

The app consists of a single “Home” screen with:

### 1) Images Carousel
- Swiping left/right changes the currently selected page.
- When the selected page changes, **the list content must update accordingly**.
- Carousel supports **any number of images**.

### 2) List
- The list supports **any number of items**.
- When the user scrolls the list, the **entire page scrolls** (carousel + search + list behave as one scrollable page).

### 3) Search
- Search bar should **pin to the top** when it reaches the screen top.
- Entering text should filter list items **by label/title**.

### 4) Floating Action Button + Bottom Sheet (Statistics)
Tapping the floating action button opens a bottom sheet that shows:
- **Count of items per page**
- **Top 3 most frequent characters** in the list items for the currently selected page  
  Example: `["apple", "banana", "orange", "blueberry"]`

> Characters are counted across all titles in the current page’s list (case-insensitive; letters only).

## Tech Stack

- **iOS:** 17+ for SwiftUI, 15+ for UIKit
- **Swift:** 5.9
- **UI:** SwiftUI + UIKit (two implementations)
- **Data binding:** Combine
- **Networking:** async/await
- **State updates / threading:** GCD (state updates dispatched appropriately)

---

## Architecture

The project uses **MVI + State** with a **unidirectional data-flow**

- `View` sends `Action` events to `ViewModel` via `dispatch(_:)`
- `ViewModel` processes actions and updates an immutable `State`
- `State` changes trigger UI updates (Combine for UIKit binding, `@Published` for SwiftUI)

This approach makes debugging easier and keeps UI updates predictable.

---

## Project Structure

The project is organized into several core modules:

### Design System
Includes common UI elements as well as the grid and size system used for consistent spacing and layout.

### Extensions
Common extensions and small utilities used throughout the project.

### Network
Networking layer built with **async/await**, including request/response models.

The project supports both **SwiftUI and UIKit implementations**.  
Different UI frameworks are developed in **separate branches**.
---

## How to Run

1. Open the project in Xcode.
2. Select one of the targets:
   - **TestABC-SwiftUI** (SwiftUI version)
   - **TestABC-UIKit** (UIKit version)
3. Build & Run (`Cmd + R`).

---

## Data Source

The assignment allows content to be local or loaded from the internet.  
This project supports loading content via the built-in network layer.

---

## Notes / Trade-offs

- No third-party libraries are used (as required).
- The architecture favors predictable state management and easier debugging over maximum simplicity.
- Focus was on fulfilling functional requirements within the given time constraint.

---
## Possible Improvements

### UI / UX Improvements
- Add image caching (memory/disk) for smoother scrolling.
- Add loading states for image fetching in UIKit (placeholder / shimmer).
- Add pagination for large lists.
- Add a loading indicator while statistics are being calculated.

### Technical Improvements
- Upgrade the project to **Swift 6**.
- Migrate UIKit collections to **Diffable Data Source**.
- Increase unit test coverage for view models, reducers/state transitions, and business logic.
