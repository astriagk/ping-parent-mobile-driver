# Auto Refresh Pattern — Reusable Guide for Flutter Apps

## Problem
Screens show stale/old data when revisited because:
- `initState()` only runs once — not on tab switch or back navigation
- Providers cache data with `_isInitialized` guards that block re-fetching
- Bottom tab widgets are stored as static instances, never re-created

## Solution: Two Centralized Mechanisms

---

### 1. `AutoRefreshMixin` — For Pushed Route Screens

Create `lib/widgets/auto_refresh_mixin.dart`:

```dart
import '../config.dart'; // must export routeObserver

mixin AutoRefreshMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modal = ModalRoute.of(context);
    if (modal != null) {
      routeObserver.subscribe(this, modal as ModalRoute<void>);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Override this to fetch fresh data from the API.
  void refreshData();

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) refreshData();
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) refreshData();
    });
  }

  @override
  void didPop() {}

  @override
  void didPushNext() {}
}
```

**Prerequisites:**
- A global `routeObserver` must exist (e.g., in `config.dart`):
  ```dart
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  ```
- Register it in `MaterialApp`:
  ```dart
  MaterialApp(
    navigatorObservers: [routeObserver],
    ...
  )
  ```

**Usage — just 2 additions to any screen:**

```dart
class _MyScreenState extends State<MyScreen> with AutoRefreshMixin {
  @override
  void refreshData() {
    context.read<MyProvider>().fetchData();
  }

  // ... rest of screen unchanged
}
```

- `refreshData()` is called when the screen is first pushed AND when user navigates back to it
- No need for `initState` fetch — the mixin handles it via `didPush()`
- Keep other `initState` setup (listeners, controllers) as-is

---

### 2. Central Tab Refresh — For Bottom Navigation Tabs

Add tab-change detection in the **DashBoard widget** (one place handles all tabs):

```dart
class _DashBoardState extends State<DashBoard> {
  int? _lastTabIndex;

  void _onTabChanged(BuildContext context, int newTab) {
    if (_lastTabIndex == newTab) return;
    final isFirstVisit = _lastTabIndex == null;
    _lastTabIndex = newTab;
    if (isFirstVisit) return; // first load handled by initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (newTab) {
        case 0:
          context.read<HomeProvider>().fetchData();
          break;
        case 1:
          // static data — no refresh needed
          break;
        case 2:
          context.read<SubscriptionProvider>().fetchData(isRefresh: true);
          break;
        case 3:
          context.read<UserProvider>().fetchProfile();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context, bottomCtrl, child) {
      _onTabChanged(context, bottomCtrl.currentTab); // <-- add this line
      // ... rest of build unchanged
    });
  }
}
```

**Benefits:**
- Individual tab screens do NOT need tab-watch code
- Adding a new tab refresh = adding one `case` statement
- App lifecycle refresh (background → foreground) stays in individual screens via `WidgetsBindingObserver`

---

## Provider Tip

If your providers have `_isInitialized` guards in `onInit()`:
```dart
Future<void> onInit() async {
  if (_isInitialized) return; // blocks re-fetch!
  _isInitialized = true;
  await fetchData();
}
```

**Don't remove the guard** — instead, have screens call `fetchData()` directly (bypasses the guard). The `onInit()` guard remains useful as a fallback for first-load scenarios.

---

## When to Apply

| Screen Type | Pattern | Refresh Trigger |
|-------------|---------|-----------------|
| Bottom tab screen | Central `_onTabChanged` in DashBoard | Tab switch |
| Pushed route screen | `AutoRefreshMixin` | `didPush` + `didPopNext` |
| App lifecycle (any) | `WidgetsBindingObserver` | App resume from background |
