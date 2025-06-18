# AGENTS.md — FitLink iOS Project Guide for Agents

## 💡 Project Overview

This is an iOS fitness coaching app built with **SwiftUI** using the **MVVM** architecture. The app includes screens for managing workouts, clients, sessions, exercises, and nutrition tracking.

---

## 📐 Architectural Guidelines (MVVM)

- Each `View` must have a corresponding `ViewModel` located **in the same folder**.
- `ViewModel` classes should:
  - Be marked with `@MainActor`
  - Inherit from `ObservableObject`
  - Expose state via `@Published` properties
  - Contain all business logic (e.g. loading data, adding/removing items, processing user actions)

---

## 🧱 UI Guidelines

- Use `Theme.font`, `Theme.color`, and `Theme.spacing` for all styles (do not hardcode font sizes or colors).
- Wrap logical UI blocks in separate `View` components when they grow beyond ~40 lines.
- Use the following comment style after closing UI containers:

```swift
VStack {
    ...
} //: VStack

HStack {
    ...
} //: HStack

ZStack {
    ...
} //: ZStack

Group {
    ...
} //: Group

🧼 Code Style Rules

Always place ViewModel in the same file group as its View.
Use meaningful names: WorkoutSessionViewModel, ExerciseLibraryViewModel, etc.
Avoid putting logic inside .onTapGesture, .onAppear, etc. directly in View — instead, delegate to ViewModel.
Avoid using @State for anything other than lightweight UI flags (like isExpanded). Prefer @ObservedObject/@StateObject for state-driven views.

🔌 Async / Data Handling

Use async/await for all async work in ViewModel
Make sure all state changes (self.someProperty =) happen on the main thread
Use Task { await viewModel.load() } in Views if needed

💬 Localization

All strings in UI should use NSLocalizedString or accessors like Strings.Dashboard.Title.
Avoid hardcoded strings in Text(...), Label(...), Alert(...), etc.

🚨 Error Handling

Avoid using fatalError, assertionFailure in production paths.
Handle errors gracefully and expose error messages in ViewModel state when needed.

🧭 Navigation

Navigation should be handled via @Published var selectedItem: Item? style in ViewModel.
Use NavigationStack and NavigationLink with bindings.

📁 Folder Structure

When generating code in Views:

Always place //: VStack (etc.) after closing braces
Create a ViewModel in same folder
Mark ViewModel as @MainActor
Use Theme for fonts/colors
Bind @StateObject to ViewModel at the top level
Make Views purely declarative

🙏 Final Note

This project values clean code, clear separation of concerns, and readability. Help us maintain these standards and make the codebase scalable and friendly to navigate!


