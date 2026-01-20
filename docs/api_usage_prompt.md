# Screen Usage Prompt Guide

Use this document to define how to use an API/Provider in a screen. An AI agent will use this information to generate or update screen code following the project's existing patterns.

---

## Usage Definition Template

```yaml
PROVIDER_NAME:
SCREEN_FILE: existing:<path> | new:<path>
SCREEN_TYPE: list | detail | form

DATA_TO_DISPLAY:

ACTIONS:

UI_COMPONENTS:

NOTES:
```

---

## Files to Generate/Update

When processing a usage definition, the AI should:

1. **Screen** (`lib/screens/app_pages/<name>/<name>_screen.dart`)
   - Create or update screen with Consumer pattern
   - Handle loading, error, empty, and data states

2. **Route** (`lib/routes/route_name.dart`)
   - Add route name constant

3. **Route Config** (`lib/routes/route_config.dart`)
   - Add route mapping

4. **Skeleton** (`lib/widgets/skeletons/<name>_skeleton.dart`) - if needed
   - Create loading skeleton widget

---

## Your Usage Definitions Below

```yaml
PROVIDER_NAME:
SCREEN_FILE:
SCREEN_TYPE:

DATA_TO_DISPLAY:

ACTIONS:

UI_COMPONENTS:

NOTES:
```
