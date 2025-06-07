# Workout Screen – Visual Reference (Stitch-based)

This document summarizes the intended structure and style of the Workout screen, based on a Stitch-generated prototype and localized user flow requirements.

---

## ✅ Layout Overview

The screen is composed of **three main sections**:

- **Разминка** (Warm-up)
- **Основная часть** (Main Set)
- **Заминка** (Cool-down)

Each section contains a list of exercise blocks. There is **no inline expansion or edit mode** in this list.

---

## 🧱 Exercise Block Structure

Each exercise block (card) contains:

- **(Optional) Type label:** "Суперсет", "Дропсет", "Циркул"  
  - Style: small gray text above the title (`caption`, `textSecondary`)
- **Title:** Name of the exercise (or list of exercises if grouped)  
  - Truncated to 2 lines max  
  - Example: `"Pull-ups + Push-ups"`
- **Subtitle:** Summary of the set  
  - Example: `"3 подхода · 10 повторений · 50 кг"`

No images or icons are shown. Text only.

---

## ➕ Action Area

There is **only one button** on the entire screen:

**"Добавить упражнение"** ("Add Exercise")

- Located at the bottom of the screen
- Full-width button
- Uses primary accent color (`#FFAD17`)
- Text is white, button is padded and rounded (8pt corner radius)
- Positioned with large spacing above it and bottom safe-area inset

---

## ❌ What’s intentionally removed from this version:

- No per-section “Add” buttons
- No buttons like "Add Block", "Clone", "Grouped Exercise"
- No expandable/collapsible exercise blocks
- No swipe actions or quick edit

---

## 🎨 Styling Summary

- **Fonts:** Use Theme.font (SF Pro):  
  `titleSmall`, `body`, `caption`, `metadata`
- **Spacing:** 8 / 16 / 24 px from `Theme.spacing`
- **Corner radius:** 8 px from `Theme.radius.card`
- **Colors:** Use `Theme.color`:
  - Background: black or dark gray
  - Text: white/gray
  - Accent: #FFAD17

---

## 📝 Notes

- This layout is optimized for mobile trainer workflows.
- Editing, reordering, and advanced logic is handled in detail sheets or separate flows.


