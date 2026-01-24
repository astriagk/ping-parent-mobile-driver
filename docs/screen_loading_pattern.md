# Screen Loading Pattern Guide

This document describes the pattern to follow when creating screens that load data from an API to prevent the "empty state flash" issue.

---

## The Problem

When a screen loads, if `isLoading` starts as `false` and the data list is empty, the empty state will briefly flash before the skeleton/loading state appears.

---

## The Solution

### Provider Setup

In the provider, **always start `isLoading` as `true`** to prevent the empty state from flashing before the API call starts.

### Screen Setup

Use the ternary operator pattern directly in the Scaffold body (not a separate `_buildBody` method).

---

## State Order (Priority)

1. **Loading** - Show skeleton when `isLoading` is true
2. **Error** - Show error state when `errorMessage` is not null
3. **Empty** - Show empty state when data list is empty
4. **Data** - Show the list/content when data exists

---

## Reference Files

- **Provider Example**: `lib/provider/app_pages_providers/add_student_provider.dart`
- **Screen Example**: `lib/screens/app_pages/student_screen/student_list_screen.dart`

---

## Key Points

1. Provider: `isLoading` must start as `true` (not `false`)
2. Screen: Use simple ternary operators in Scaffold body
3. Button Text: Use `appFonts.refresh` for retry buttons
4. Reset method: Sets `isLoading` back to `false`
