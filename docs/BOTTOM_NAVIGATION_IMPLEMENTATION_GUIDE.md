# Bottom Navigation Bar - End-to-End Implementation Guide

## Overview
This guide explains how the bottom navigation bar is implemented in the Ping Parent application. It uses a Provider-based state management pattern with a tab-switching mechanism.

---

## Architecture Layers

### 1. **Data Layer** - Navigation Configuration
**Location:** [lib/common/app_array.dart](../lib/common/app_array.dart)

Defines the navigation bar items with their properties:
```dart
var bottomNavigationBarList = [
  {
    "title": appFonts.home,
    "icon": svgAssets.homeLight,
    "iconDark": svgAssets.homeDark
  },
  {
    "title": appFonts.category,
    "icon": svgAssets.categoryLight,
    "iconDark": svgAssets.categoryDark
  },
  {
    "title": appFonts.mySubscriptions,
    "icon": svgAssets.carLight,
    "iconDark": svgAssets.carDark
  },
  {
    "title": appFonts.settings,
    "icon": svgAssets.settingLight,
    "iconDark": svgAssets.settingDark
  }
];
```

**Key Data Structure:**
- `title`: Display name of the tab
- `icon`: SVG icon when tab is inactive
- `iconDark`: SVG icon when tab is active

---

### 2. **State Management Layer** - DashBoardProvider
**Location:** [lib/provider/bottom_provider/dash_board_provider.dart](../lib/provider/bottom_provider/dash_board_provider.dart)

Manages the state and logic for bottom navigation:

```dart
class DashBoardProvider extends ChangeNotifier {
  int currentTab = 0;                    // Current selected tab index
  bool isImage = true;                   // For scroll-based image visibility
  List bottomNavigationBarList = [];     // List of nav items
  ScrollController? scrollViewController; // Scroll listener for home screen

  // All screens available for navigation
  final List<Widget> screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const SubscriptionManagementScreen(),
    const SettingsScreen(),
  ];

  // Initialize on first load
  onInit() {
    bottomNavigationBarList = appArray.bottomNavigationBarList;
    scrollViewController = ScrollController(initialScrollOffset: 0.0);
    scrollViewController!.addListener(changeColor);
    notifyListeners();
  }

  // Handle scroll events (changes image visibility in home)
  void changeColor() {
    if ((scrollViewController!.offset == 0)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 80)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 100)) {
      isImage = false;
    }
    notifyListeners();
  }

  // Main tab switching logic
  tabChange(int index) {
    currentTab = index;
    notifyListeners();
  }
}
```

**Responsibilities:**
- Track current active tab (`currentTab`)
- Manage list of navigation items
- Handle tab change events
- Manage scroll controller for home screen animations
- Notify listeners on state changes

---

### 3. **UI Layer - Layout**

#### 3.1 Main Scaffold Layout
**Location:** [lib/screens/bottom_screen/dash_board_layout/dash_board.dart](../lib/screens/bottom_screen/dash_board_layout/dash_board.dart)

Orchestrates the overall layout:

```dart
class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    // Initialize provider on first load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      if (!userProvider.hasUserData && !userProvider.isLoading) {
        await userProvider.fetchUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context1, bottomCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => bottomCtrl.onInit()),
          child: DirectionalityRtl(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: appColor(context).appTheme.screenBg,
                  extendBody: true,  // Extends body behind bottom nav
                  bottomNavigationBar: const DashBoardLayout(), // Bottom nav
                  appBar: bottomCtrl.currentTab != 0
                      ? DashAppBar(index: bottomCtrl.currentTab)
                      : null,
                  body: bottomCtrl.currentTab == 0
                      ? DashAppBar(index: bottomCtrl.currentTab)
                      : bottomCtrl.screens[bottomCtrl.currentTab])));
    });
  }
}
```

**Key Points:**
- Uses `Consumer<DashBoardProvider>` for reactive updates
- `extendBody: true` allows content to extend behind the bottom nav
- Dynamically shows different screens based on `currentTab`
- AppBar is conditional based on the current tab

#### 3.2 Bottom Navigation Bar Layout
**Location:** [lib/screens/bottom_screen/dash_board_layout/layout/dash_board_layout.dart](../lib/screens/bottom_screen/dash_board_layout/layout/dash_board_layout.dart)

Renders the actual bottom navigation bar:

```dart
class DashBoardLayout extends StatelessWidget {
  const DashBoardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context1, bottomCtrl, child) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          SystemNavigator.pop();
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.03),
                      blurRadius: 20,
                      spreadRadius: 7)
                ],
                borderRadius: BorderRadius.circular(Sizes.s20),
                border: Border(
                    top: BorderSide(
                        color: appColor(context).appTheme.borderColor,
                        width: 1))),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.s20),
                    topRight: Radius.circular(Sizes.s20)),
                child: BottomAppBar(
                    shadowColor: appColor(context).appTheme.primary,
                    color: appColor(context).appTheme.white,
                    height: Sizes.s70,
                    elevation: Sizes.s50,
                    child: NavigationBarWidgets().buildNavItem(context)))),
      );
    });
  }
}
```

**Styling:**
- Rounded top corners (20px radius)
- Top border with app theme color
- Box shadow for depth
- Height: 70px
- Uses `BottomAppBar` from Flutter

#### 3.3 Navigation Items Builder
**Location:** [lib/screens/bottom_screen/dash_board_layout/layout/navigation_widgets.dart](../lib/screens/bottom_screen/dash_board_layout/layout/navigation_widgets.dart)

Builds individual navigation items:

```dart
class NavigationBarWidgets {
  Widget buildNavItem(BuildContext context) {
    Color defaultTextColor = appColor(context).appTheme.lightText;
    Color selectedTextColor = appColor(context).appTheme.primary;

    return Consumer2<DashBoardProvider, LanguageProvider>(
        builder: (context1, bottomCtrl, languageCtrl, child) {
      return StatefulBuilder(builder: (context1, setState) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomCtrl.bottomNavigationBarList
                .asMap()
                .entries
                .map((entries) {
              var e = entries.value;
              var index = entries.key;
              
              return Row(children: [
                InkWell(
                    radius: Sizes.s10,
                    focusColor: appColor(context).appTheme.trans,
                    highlightColor: appColor(context).appTheme.trans,
                    onTap: () => bottomCtrl.tabChange(index),  // Switch tab
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon changes based on selection
                        bottomCtrl.currentTab == index
                            ? SvgPicture.asset(e['iconDark'])   // Active icon
                            : SvgPicture.asset(e['icon']),      // Inactive icon
                        VSpace(Sizes.s2),
                        // Text color changes based on selection
                        TextWidgetCommon(
                            text: e['title'],
                            style: AppCss.lexendRegular14.textColor(
                                bottomCtrl.currentTab == index
                                    ? selectedTextColor
                                    : defaultTextColor),
                            overflow: TextOverflow.ellipsis).center()
                      ])),
              ]);
            }).toList());
      });
    });
  }
}
```

**Features:**
- Maps through `bottomNavigationBarList`
- Each item is an `InkWell` for tap detection
- Shows different icon based on active/inactive state
- Text color changes based on selection
- Calls `bottomCtrl.tabChange(index)` on tap
- Responsive to language changes via `LanguageProvider`

#### 3.4 App Bar (Conditional Header)
**Location:** [lib/screens/bottom_screen/dash_board_layout/layout/dash_app_bar.dart](../lib/screens/bottom_screen/dash_board_layout/layout/dash_app_bar.dart)

Different app bars for different tabs:
- **Tab 0 (Home):** Collapsible search bar with logo and action buttons
- **Other Tabs:** Simple header with title and actions

---

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    DashBoard (Main Widget)                       │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Scaffold                                                │  │
│  │  - bottomNavigationBar: DashBoardLayout                  │  │
│  │  - body: screens[currentTab]                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                            ↓
            ┌───────────────────────────────┐
            │  DashBoardLayout              │
            │  (Bottom Navigation Bar)      │
            └───────────────────────────────┘
                            ↓
            ┌───────────────────────────────┐
            │  NavigationBarWidgets         │
            │  (Builds nav items)           │
            └───────────────────────────────┘
                            ↓
            ┌───────────────────────────────┐
            │  InkWell (Each nav item)      │
            │  onTap: tabChange(index)      │
            └───────────────────────────────┘
                            ↓
            ┌───────────────────────────────┐
            │  DashBoardProvider            │
            │  - currentTab = index         │
            │  - notifyListeners()          │
            └───────────────────────────────┘
                            ↓
            ┌───────────────────────────────┐
            │  Scaffold body re-renders     │
            │  Shows screens[currentTab]    │
            └───────────────────────────────┘
```

---

## Complete Integration Flow

### Step 1: Provider Registration (main.dart)
```dart
ChangeNotifierProvider(create: (_) => DashBoardProvider())
```

### Step 2: Initialization
- When DashBoard widget is created, it calls `bottomCtrl.onInit()`
- This populates `bottomNavigationBarList` from `appArray`
- Initializes `scrollViewController` for home screen

### Step 3: Rendering
- DashBoardLayout builds the BottomAppBar
- NavigationBarWidgets creates the navigation items
- Each item shows icon and title, styled based on active/inactive state

### Step 4: User Interaction
1. User taps a navigation item
2. `onTap: () => bottomCtrl.tabChange(index)` is triggered
3. DashBoardProvider sets `currentTab = index`
4. `notifyListeners()` triggers rebuild of all Consumers
5. Scaffold body re-renders with `screens[currentTab]`
6. AppBar updates based on tab index

### Step 5: Optional Features
- **Scroll Detection:** Home screen monitors scroll position via `scrollViewController`
- **Dynamic AppBar:** Different headers for different tabs via conditional logic
- **RTL Support:** Uses DirectionalityRtl wrapper
- **Theme Support:** Colors adapt to light/dark theme

---

## Implementation Checklist for Other Pages

To implement similar navigation in other places:

- [ ] Create a Provider class extending `ChangeNotifier`
- [ ] Define list of items with at least: `title`, `icon`, `iconDark`
- [ ] Add `currentTab` variable to track selection
- [ ] Implement `tabChange(index)` method
- [ ] Create NavigationWidget class with `buildNavItem(context)` method
- [ ] Create Layout widget with BottomAppBar styling
- [ ] Create screens list to hold all screen widgets
- [ ] Wire Provider in main.dart via MultiProvider
- [ ] Use Consumer to listen to Provider changes
- [ ] Call `onTap: () => provider.tabChange(index)` on tap
- [ ] Conditionally render screens based on `currentTab`

---

## Key Classes Used

| Class | Purpose | Location |
|-------|---------|----------|
| `DashBoardProvider` | State management | `lib/provider/bottom_provider/` |
| `DashBoard` | Main scaffold container | `lib/screens/bottom_screen/dash_board_layout/` |
| `DashBoardLayout` | Bottom app bar styling | `lib/screens/bottom_screen/dash_board_layout/layout/` |
| `NavigationBarWidgets` | Navigation items builder | `lib/screens/bottom_screen/dash_board_layout/layout/` |
| `DashAppBar` | Conditional header | `lib/screens/bottom_screen/dash_board_layout/layout/` |

---

## Best Practices Applied

1. **Separation of Concerns:** State logic separated from UI
2. **Reactive Updates:** Using Consumer and notifyListeners()
3. **Reusability:** NavigationBarWidgets is reusable component
4. **Conditional Rendering:** Different UIs for different tabs
5. **Styling Consistency:** Uses theme colors from appColor()
6. **Internationalization:** Supports RTL and multiple languages
7. **Accessibility:** Proper ripple effects and icon switching

---

## Common Customizations

### Change Number of Tabs
Modify `bottomNavigationBarList` in [lib/common/app_array.dart](../lib/common/app_array.dart) and add corresponding screen to `screens` list in Provider.

### Change Tab Icons
Update `icon` and `iconDark` values in `bottomNavigationBarList`

### Change Tab Colors
Modify `defaultTextColor` and `selectedTextColor` in NavigationBarWidgets

### Add Animations
Wrap icon/text changes with AnimatedSwitcher or AnimatedOpacity

### Change Bottom Bar Height
Update `height: Sizes.s70` in DashBoardLayout

### Add Badge (Notification Count)
Add `Stack` with `Positioned` badge over the icon in NavigationBarWidgets
