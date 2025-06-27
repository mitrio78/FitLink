# AGENTS.md — FitLink iOS Project Guide for Agents

## 💡 Project Overview
FitLink is an iOS fitness coaching app written in **SwiftUI** and organised with the **MVVM** architecture.  The project already includes screens for:

- TrainerDashboard
- ExerciseLibrary
- Schedule
- WorkoutSession
- Workouts
- Profile
- Main (tab bar container)

The repository structure is as follows:

```
FitLink/
├── App/                   # App entry point
├── CommonServices/        # Date formatter, in-memory stores, etc.
├── Helpers/               # Extensions
├── Localization/          # *.lproj folders with Localizable.strings
├── Models/                # Codable model definitions
├── Resources/             # Asset catalogs
├── Stubs/                 # Mock data generators
├── Theme/                 # Colors, Typography, Spacing constants
├── UIAtoms/               # Reusable UI components
└── Views/                 # Feature screens with View + ViewModel pairs
```

Each feature inside `Views/` has its own folder containing the SwiftUI `View` and its associated `ViewModel` (e.g. `Views/WorkoutSession/WorkoutSessionView.swift` and `WorkoutSessionViewModel.swift`).

---

## 📐 Architectural Guidelines (MVVM)

- Every `View` must have a corresponding `ViewModel` located **in the same folder** and named `<Screen>ViewModel`.
- `ViewModel` classes **must**:
  - Be annotated with `@MainActor`.
  - Inherit from `ObservableObject`.
  - Expose state via `@Published` properties.
  - Keep all business logic (loading data, processing user actions, etc.).
- Views should remain declarative. Delegate logic from gestures or `.onAppear` to the ViewModel.
- Navigation state should be stored in the ViewModel as `@Published` optionals.
- Prefer `@StateObject` in Views to instantiate the ViewModel.
- Use Swift Concurrency (`async/await`) when performing asynchronous work. **TODO:** current code has no async calls – update ViewModels to use async/await when networking or long operations are added.

---

## 🧱 UI Guidelines

- **Theme**: Use `Theme.color`, `Theme.font`, `Theme.spacing`, `Theme.radius` and `Theme.shadow` for all styling. Avoid hard‑coded colors or font sizes.
- Views should stay small. Extract subviews when a block grows beyond ~40 lines.
- Closing comments for UI containers should follow the style:

```swift
VStack {
    ...
} //: VStack
```

  **TODO:** existing code rarely uses these comments. New code should adopt them for consistency.

- Keep layout minimalistic and readable. Use built‑in modifiers rather than custom ones when possible.
- **Bottom Sheets**: Keep vertical spacing minimal and match native system sheets. Avoid stacking multiple padding modifiers and prefer safe‑area‑aware layout.

## View Structure Conventions

- Always use `List` for any vertically scrolling list of items where:
  - Each item is rendered with identical or similar structure (rows)
  - Swipe actions, selection, or reorder support is desired
  - You want performance optimizations like cell reuse

- Use `.listStyle(.plain)` by default to maintain visual control

- Use `ScrollView + LazyHGrid` or `LazyVGrid` for:
  - Horizontally scrollable rows (e.g. sets, metrics)
  - Complex nested layout
  - Non-uniform sizing or alignment

---

## 💬 Localization

- All visible strings must come from `Localizable.strings`. Use `NSLocalizedString` or helper accessors.
- Example: `Text(NSLocalizedString("ExerciseLibrary.Header", comment: "Exercises"))`

---

## 📁 Data & Services

- Models under `Models/` conform to `Codable` when persisted (e.g. `WorkoutSession`).
- `CommonServices/` contains small services like `DateFormatterService` and `WorkoutStore` (in‑memory store used in previews and feature screens).
- `Stubs/` holds factories such as `MockData` and `clientsMock` for previews and local testing.

### Temporary In-Memory AppDataStore

- Provides a centralized source of truth for all app data during development.
- All features must read and write data solely through `AppDataStore`.
- Only SwiftUI Previews may use mock data directly.
- This is a transitional mechanism to be replaced by a real data source like SwiftData or an API.

---

## 🔌 UIAtoms and Previews

- Reusable UI building blocks live in `UIAtoms/` (e.g. `ClientRow`, `SearchBarWithFilter`, components of the workout screen). Keep them simple and styling-consistent.
- Every view and atom should have SwiftUI `#Preview` definitions next to the implementation to aid design‑time testing.
---


## ✅ Summary Checklist for New Code

1. Create a `View` and `ViewModel` pair in the same folder.
2. Annotate the `ViewModel` with `@MainActor` and expose state via `@Published`.
3. Keep business logic and navigation state in the ViewModel.
4. Use `Theme.*` constants for styling.
5. Localize all UI strings.
6. Extract subviews for large UI blocks.
7. Place `//: VStack` (etc.) closing comments after UI containers. *(TODO: enforce consistently)*
8. Provide a `#Preview` section for every View/Atom.

Following this guide will keep the FitLink codebase consistent and easy to maintain.

❗ Do not place formatting or business logic inside SwiftUI Views. Keep views declarative. Use extensions or ViewModels.
