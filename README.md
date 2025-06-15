# FitLink

FitLink is an early stage iOS application for personal trainers. The code base is written in **SwiftUI** and organised by features with a small design system.

## Getting started

1. Open **`FitLink.xcodeproj`** in Xcode 15 or later.
2. Select the `FitLink` scheme and run on a simulator or device.

Mock data located in the `Stubs` folder is loaded at launch. There are currently no automated tests or CI scripts.

## Project structure

```
FitLink/
├── App/              – Application entry point
├── Models/           – Data models for workouts, exercises and clients
├── Views/            – Feature screens (Dashboard, Schedule, WorkoutSession…)
├── UIAtoms/          – Reusable SwiftUI components
├── CommonServices/   – Shared utilities (e.g. DateFormatterService)
├── Helpers/          – Extensions and small helpers
├── Theme/            – Colors, fonts, spacing and shadows
├── Localization/     – Localisable strings (English and Russian)
└── Stubs/            – Mock data seeds
```

Follow `Theme` constants for styling, for example `Theme.color.accent` or `Theme.font.body`. Views and view models live side by side. When adding localisation keys, update both `en.lproj` and `ru.lproj` files.

## Features

- **Dashboard** with a list of clients and quick statistics.
- **Exercise library** searchable by name and muscle group.
- **Schedule** with calendar and list modes to browse sessions.
- **Workout sessions** display exercises in warm‑up, main and cool‑down sections. Design guidance for this screen is documented in [Design/WorkoutScreenReference.md](Design/WorkoutScreenReference.md).
- **Workouts** and **Profile** placeholders for future development.

## Localization

Strings are located in `Localization/en.lproj/Localizable_en.strings` and `Localization/ru.lproj/Localizable.strings`. Use `NSLocalizedString` with existing keys or add new ones to both files.

## License

This project is provided as-is for demonstration purposes.
