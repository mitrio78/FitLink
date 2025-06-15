# AGENT GUIDANCE

This repository contains **FitLink**, an iOS application built with SwiftUI. The project structure is oriented around features with reusable UI atoms and a small design system. The codebase is early in development and relies heavily on mocked data for now.

## Project layout

- `FitLink/` – application source code
  - `App/` – application entry point (`FitLinkApp.swift`)
  - `Models/` – data models such as workouts, exercises and clients
  - `Views/` – feature screens (Dashboard, Schedule, WorkoutSession etc.)
  - `UIAtoms/` – reusable SwiftUI components used across views
  - `CommonServices/` – shared utilities (e.g. `DateFormatterService`)
  - `Helpers/` – small extensions
  - `Theme/` – colors, fonts, spacing and shadows that compose the design system
  - `Localization/` – `*.strings` files for English and Russian
  - `Stubs/` – mock data used during development
- `Design/WorkoutScreenReference.md` – design notes for the Workout screen
- `FitLink.xcodeproj/` – Xcode project

## Key conventions

- **Use Theme constants** for colors, typography and spacing. Example: `Theme.color.accent`, `Theme.font.body`.
- **Views and view models** are placed alongside each other. View models conform to `ObservableObject` and expose `@Published` properties for view state.
- **Localization** is performed through `NSLocalizedString`. Add new keys in both `en.lproj` and `ru.lproj`.
- **Mocked content** lives in the `Stubs` folder. Update or extend seeds to demo new features.

## Building & testing

Open `FitLink.xcodeproj` in Xcode to run or build the app. There are currently no automated tests or CI scripts.

## Design reference

`Design/WorkoutScreenReference.md` describes the layout and styling of the Workout screen. Follow these notes for consistent UI behavior and styling.

