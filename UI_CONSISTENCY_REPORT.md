# UI Consistency Report for BeeBetter App

## Overview
This document identifies UI inconsistencies found throughout the app and provides recommendations for standardization.

---

## 1. Border Radius Inconsistencies

### Current Usage:
- **12px** (most common): Cards, containers, buttons
- **16px**: Some cards (InsightsTab mood chart, BrowseTab calendar)
- **8px**: Small containers, profile list items
- **20px**: Recording card time displays
- **30px**: Navigation bar top corners
- **2px**: Progress bar in GuidedMode

### Recommendation:
- **Primary cards/containers**: `12px` (standardize all main cards)
- **Large feature cards** (charts, calendars): `16px`
- **Small elements** (badges, chips): `8px`
- **Navigation bar**: `30px` (keep as is - unique design element)
- **Progress indicators**: `10px` (standardize)

**Files to update:**
- `lib/pages/GuidedMode/GuidedModeUI.dart`: Progress bar uses `10px` (inconsistent with `2px` comment)
- `lib/widgets/Cards/RecordingCard/RecordingCard.dart`: Time displays use `20px` (should be `12px`)

---

## 2. Spacing Inconsistencies

### Current Usage:
- **4px**: Very tight spacing between related elements
- **8px**: Small spacing
- **12px**: Medium spacing
- **16px**: Standard spacing (most common)
- **20px**: Larger spacing
- **24px**: Section spacing
- **32px**: Large section spacing
- **40px**: Bottom padding

### Recommendation:
- **Tight spacing** (related elements): `4px`
- **Small spacing**: `8px`
- **Medium spacing**: `12px`
- **Standard spacing**: `16px` (use consistently)
- **Section spacing**: `16px` (standardize from 20px/24px)
- **Large spacing**: `24px` (for major sections)
- **Bottom padding**: `40px` (keep for scrollable content)

**Files to update:**
- `lib/pages/Dashboard/InsightsTab.dart`: Some sections use `4px` after cards (should be `16px`)
- `lib/pages/Onboarding/OnboardingPage.dart`: Uses `32px` padding (should be `16px` for consistency)

---

## 3. Card Padding Inconsistencies

### Current Usage:
- **8px**: Small cards, compact layouts
- **16px**: Standard cards (most common)
- **24px**: Large cards, input fields
- **32px**: Chart containers

### Recommendation:
- **Standard cards**: `16px` (use consistently)
- **Large feature cards** (charts): `24px` or `32px` (acceptable for emphasis)
- **Compact elements**: `12px` (instead of 8px for better touch targets)

**Files to update:**
- `lib/pages/GuidedMode/GuidedModeUI.dart`: Uses `8px` padding in some places (should be `16px`)
- `lib/widgets/Cards/PromptCard/PromptInput.dart`: Uses `8px` for title field (should be `12px`)

---

## 4. Icon Size Inconsistencies

### Current Usage:
- **14px**: Chart axis icons
- **20px**: Small icons, list items
- **24px**: Medium icons
- **28px**: Button icons
- **30px**: Navigation bar icons
- **32px**: Section header icons
- **36px**: Large icons
- **44px**: Very large icons
- **48px**: Feature icons
- **64px**: Hero icons

### Recommendation:
- **Tiny icons** (charts): `14px`
- **Small icons** (lists, buttons): `20px`
- **Standard icons** (section headers): `24px` (standardize from 32px)
- **Medium icons**: `28px`
- **Large icons** (navigation): `30px`
- **Hero icons** (onboarding): `48px` or `64px`

**Files to update:**
- `lib/pages/Dashboard/InsightsTab.dart`: Section headers use `32px` icons (should be `24px`)
- `lib/pages/Dashboard/BrowseTab.dart`: Section headers use `32px` icons (should be `24px`)

---

## 5. Color Usage Inconsistencies

### Current Usage:
- **Primary colors**: Mostly consistent
- **Alpha values**: Inconsistent usage (128, 160, 200, 240)
- **Surface colors**: Mix of `surfaceBright`, `surfaceContainerHigh`, `surfaceContainerLow`

### Recommendation:
- **Primary text**: `colorScheme.primary` (full opacity)
- **Secondary text**: `colorScheme.primary.withAlpha(160)` (standardize)
- **Tertiary text**: `colorScheme.primary.withAlpha(128)`
- **Icons (active)**: `colorScheme.primary.withAlpha(240)`
- **Icons (inactive)**: `colorScheme.primary.withAlpha(128)`
- **Surface containers**: Use `surfaceContainerHigh` consistently (already fixed)

**Files to update:**
- All files: Standardize alpha values to: 128, 160, 200, 240 (remove other values like 77, 100)

---

## 6. Typography Inconsistencies

### Current Usage:
- **headlineSmall**: Page titles
- **titleLarge**: Section titles
- **titleMedium**: Card titles, subsection headers
- **titleSmall**: Labels, small text
- **bodyLarge**: Main content
- **bodyMedium**: Secondary content
- **bodySmall**: Tertiary content

### Recommendation:
- **Page titles**: `headlineSmall` ✓
- **Section headers**: `titleMedium` (standardize from titleLarge)
- **Card titles**: `titleMedium` ✓
- **Labels**: `titleSmall` ✓
- **Main content**: `bodyLarge` ✓
- **Secondary content**: `bodyMedium` ✓
- **Tertiary content**: `bodySmall` ✓

**Files to update:**
- `lib/pages/Dashboard/InsightsTab.dart`: Some section headers use `titleLarge` (should be `titleMedium`)

---

## 7. Button Style Inconsistencies

### Current Usage:
- **ElevatedButton**: Navigation buttons (GuidedMode)
- **FilledButton**: Primary actions
- **IconButton**: Control buttons
- **TextButton**: Secondary actions
- **OutlinedButton**: Delete actions

### Recommendation:
- **Primary actions**: `FilledButton` with `colorScheme.primary`
- **Secondary actions**: `TextButton` or `OutlinedButton`
- **Icon-only buttons**: `IconButton` in containers with background
- **Navigation**: `ElevatedButton` with circular shape ✓

**Status**: Mostly consistent, but some buttons need better styling

---

## 8. Empty State Handling

### Current Status:
- **InsightsTab**: Has empty state for chart ✓
- **BrowseTab**: Has empty state for entries ✓
- **Most Common Emotions**: Has empty state ✓

### Recommendation:
- All data-driven sections should have empty states
- Use consistent empty state pattern:
  - Icon (48px, with alpha 128)
  - Title text (titleMedium)
  - Description text (bodySmall)
  - Centered in card

**Files to check:**
- All tabs and sections should have empty states

---

## 9. Section Header Pattern

### Current Usage:
- Icon (32px) + Text (titleMedium) with 8px spacing
- Some use different icon sizes

### Recommendation:
- **Standardize to**: Icon (24px) + Text (titleMedium) with 8px spacing
- Use `Row` with `Icon` and `Text` consistently
- Icon color: `colorScheme.primary.withAlpha(240)`

**Files to update:**
- `lib/pages/Dashboard/InsightsTab.dart`: Change icon size from 32px to 24px
- `lib/pages/Dashboard/BrowseTab.dart`: Change icon size from 32px to 24px

---

## 10. Card Shadow/Color Pattern

### Current Usage:
- Most cards use: `color: colorScheme.onPrimary, shadowColor: colorScheme.inversePrimary`
- Some use `elevation: 2` (TodayPage)

### Recommendation:
- **Standard cards**: `color: colorScheme.onPrimary, shadowColor: colorScheme.inversePrimary, elevation: 0`
- **Special cards** (featured): Can use `elevation: 2` for emphasis
- **Border radius**: `12px` for standard cards, `16px` for large feature cards

**Files to update:**
- `lib/pages/TodayPage/TodayPageUI.dart`: Uses `elevation: 2` (should be `0` for consistency)

---

## Summary of Priority Fixes

### High Priority:
1. ✅ Standardize border radius (12px for cards, 16px for large features)
2. ✅ Standardize icon sizes (24px for section headers)
3. ✅ Standardize spacing (16px between sections)
4. ✅ Replace `surfaceBright` with `surfaceContainerHigh` (already done)

### Medium Priority:
5. Standardize alpha values (128, 160, 200, 240)
6. Standardize section header pattern (24px icon + titleMedium)
7. Add empty states to all data-driven sections

### Low Priority:
8. Review button styles for consistency
9. Standardize card padding (16px standard, 24px for large)
10. Review typography hierarchy

---

## Notes
- The app generally has good consistency
- Most inconsistencies are minor (spacing, icon sizes)
- Dark mode implementation maintains consistency
- Color scheme is well-structured and modern

