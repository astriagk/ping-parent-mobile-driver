# Project Folder Structure Guide

Complete directory structure for Ping Parent Mobile User Flutter project with explanations and file organization patterns.

---

## 📁 Complete Folder Structure

```
ping-parent-mobile-user/
├── android/                              # Android native code
│   ├── app/
│   │   └── src/                         # Android app source
│   ├── gradle/                          # Gradle configuration
│   ├── build.gradle                     # Android build config
│   ├── settings.gradle
│   ├── gradlew                          # Gradle wrapper
│   └── gradlew.bat
│
├── ios/                                 # iOS native code
│   ├── Runner/                          # iOS app source
│   ├── Runner.xcodeproj/                # Xcode project
│   ├── Runner.xcworkspace/              # Xcode workspace
│   ├── Podfile                          # iOS dependencies
│   └── Flutter/                         # Flutter iOS settings
│
├── lib/                                 # ⭐ MAIN APP CODE
│   ├── api/                             # API Integration Layer
│   │   ├── api_client.dart              # HTTP client (singleton)
│   │   ├── endpoints.dart               # All API URLs
│   │   ├── enums/                       # Enumerations
│   │   │   └── user_status.dart         # User status enum
│   │   ├── interceptors/                # HTTP interceptors
│   │   │   └── auth_interceptor.dart    # Auth header injection
│   │   ├── interfaces/                  # Service contracts
│   │   │   ├── auth_service_interface.dart
│   │   │   ├── user_service_interface.dart
│   │   │   ├── student_service_interface.dart
│   │   │   ├── driver_service_interface.dart
│   │   │   └── subscriptions_service_interface.dart
│   │   ├── models/                      # Data models
│   │   │   ├── send_otp_response.dart          # API responses
│   │   │   ├── verify_otp_response.dart
│   │   │   ├── profile_response.dart
│   │   │   ├── verify_token_response.dart
│   │   │   ├── student_response.dart
│   │   │   ├── driver_response.dart
│   │   │   ├── school_response.dart
│   │   │   ├── parent_address_response.dart
│   │   │   ├── subscription_plans_response.dart
│   │   │   ├── user_model.dart                 # Domain models
│   │   │   ├── add_student_request.dart        # Request payloads
│   │   │   └── update_profile_request.dart
│   │   └── services/                    # API communication
│   │       ├── auth_service.dart        # Authentication APIs
│   │       ├── user_service.dart        # User/Profile APIs
│   │       ├── student_service.dart     # Student APIs
│   │       ├── driver_service.dart      # Driver APIs
│   │       ├── address_service.dart     # Address APIs
│   │       ├── subscriptions_service.dart
│   │       └── storage_service.dart     # ⭐ Persistent storage (singleton)
│   │
│   ├── provider/                        # State Management Layer
│   │   ├── index.dart                   # Export all providers
│   │   ├── auth_providers/              # Authentication state
│   │   │   ├── splash_provider.dart     # Initial routing logic
│   │   │   ├── sign_in_provider.dart    # Phone input state
│   │   │   ├── otp_provider.dart        # OTP input state
│   │   │   ├── add_location_provider.dart
│   │   │   └── new_location_provider.dart
│   │   ├── app_pages_providers/         # Feature state
│   │   │   ├── add_student_provider.dart      # Student management
│   │   │   ├── user_provider.dart             # User profile
│   │   │   ├── home_screen_provider.dart      # Home/Dashboard
│   │   │   ├── driver_provider.dart           # Driver assignment
│   │   │   ├── my_wallet_provider.dart        # Wallet
│   │   │   ├── subscriptions_provider.dart    # Subscriptions
│   │   │   ├── notification_provider.dart     # Notifications
│   │   │   ├── setting_provider.dart          # Settings
│   │   │   ├── profile_screen_provider.dart
│   │   │   ├── category_provider.dart
│   │   │   ├── promo_provider.dart
│   │   │   └── ... (other feature providers)
│   │   ├── bottom_provider/             # Bottom navigation state
│   │   │   └── bottom_nav_provider.dart
│   │   └── common_providers/            # Shared state
│   │       ├── theme_service.dart       # Theme state
│   │       ├── language_provider.dart   # Language state
│   │       └── currency_provider.dart   # Currency state
│   │
│   ├── screens/                         # UI Layer
│   │   ├── auth_screen/                 # Authentication flows
│   │   │   ├── auth_common_widgets.dart # Shared auth widgets
│   │   │   ├── splash_screen/
│   │   │   │   └── splash_screen.dart
│   │   │   ├── sign_in_screen/          # Phone input
│   │   │   │   ├── sign_in_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── sign_up_screen/          # Registration
│   │   │   │   ├── sign_up_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── otp_screen/              # OTP verification
│   │   │   │   ├── otp_screen.dart
│   │   │   │   └── layout/
│   │   │   └── location_layout/         # Location selection
│   │   │       ├── location_screen.dart
│   │   │       └── layout/
│   │   │
│   │   ├── app_pages/                   # Feature screens
│   │   │   ├── student_screen/          # Student management
│   │   │   │   ├── student_list_screen.dart
│   │   │   │   ├── add_student_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── driver_screen/           # Driver assignment
│   │   │   │   ├── driver_list_screen.dart
│   │   │   │   ├── assign_driver_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── profile_screen/          # User profile
│   │   │   │   ├── profile_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── home/                    # Home/Dashboard
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── notification/            # Notifications
│   │   │   │   ├── notification_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── my_wallet_screen/        # Wallet
│   │   │   │   ├── my_wallet_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── subscription_management/ # Subscriptions
│   │   │   │   ├── subscription_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── app_setting/             # App settings
│   │   │   │   ├── setting_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── chat_screen/             # Chat/Messaging
│   │   │   │   ├── chat_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── maps/                    # Map integration
│   │   │   │   ├── map_screen.dart
│   │   │   │   └── layout/
│   │   │   ├── ... (other screens)
│   │   │   └── screens_extensions.dart  # Screen extensions
│   │   │
│   │   ├── bottom_screen/               # Bottom navigation screens
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── wallet_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── no_internet_screen/          # Error screens
│   │       └── no_internet_screen.dart
│   │
│   ├── routes/                          # Navigation & Routing
│   │   ├── route_name.dart              # Route name constants
│   │   └── route_config.dart            # Route mappings
│   │
│   ├── widgets/                         # Reusable UI Components
│   │   ├── common_app_bar_layout1.dart  # Custom app bars
│   │   ├── common_empty_state.dart      # Empty state widget
│   │   ├── common_error_state.dart      # Error state widget
│   │   ├── status_badge.dart            # Status display
│   │   ├── skeletons/                   # Loading skeletons
│   │   │   ├── student_card_skeleton.dart
│   │   │   ├── home_skeleton.dart
│   │   │   ├── driver_skeleton.dart
│   │   │   └── ... (other skeletons)
│   │   ├── ride_card/                   # Ride display widgets
│   │   │   ├── ride_card.dart
│   │   │   └── layout/
│   │   ├── location/                    # Location widgets
│   │   │   ├── route_location_display.dart
│   │   │   ├── route_distance_display.dart
│   │   │   └── location_picker.dart
│   │   └── ... (other reusable widgets)
│   │
│   ├── helper/                          # Utility Functions
│   │   ├── distance_helper.dart         # Distance calculations
│   │   ├── date_formatter_helper.dart   # Date formatting
│   │   ├── status_helper.dart           # Status utilities
│   │   ├── validation_helper.dart       # Form validation
│   │   ├── logger_helper.dart           # Logging
│   │   └── app_extensions.dart          # Extension methods
│   │
│   ├── common/                          # Shared Constants & Config
│   │   ├── app_array.dart               # Common arrays/lists
│   │   ├── app_fonts.dart               # Font strings
│   │   ├── session.dart                 # Session management
│   │   ├── assets/                      # Asset constants
│   │   ├── extension/                   # Extension classes
│   │   ├── languages/                   # Localization strings
│   │   │   └── en.json
│   │   ├── map_config.dart              # Map configuration
│   │   ├── openfreemap_config.dart
│   │   ├── tomtom_config.dart
│   │   ├── screen_util/                 # Screen utility
│   │   └── theme/                       # Theme configuration
│   │       └── app_theme.dart
│   │
│   ├── models/                          # Domain Models
│   │   ├── user.dart
│   │   ├── student.dart
│   │   ├── driver.dart
│   │   └── ... (other domain models)
│   │
│   ├── config.dart                      # ⭐ Main imports/exports
│   │                                    # (imports all commonly used classes)
│   │
│   └── main.dart                        # ⭐ App Entry Point
│       │                                # MultiProvider setup
│       │                                # Route configuration
│       │                                # Theme & Localization
│       └── All providers initialized
│
├── assets/                              # Static Assets
│   ├── flags/                           # Country flags
│   ├── gif/                             # Animated GIFs
│   ├── image/                           # PNG/JPG images
│   │   ├── auth/
│   │   ├── category/
│   │   ├── home/
│   │   ├── my_ride/
│   │   ├── setting/
│   │   └── splash/
│   └── svg/                             # SVG vector graphics
│       ├── auth/
│       ├── category/
│       ├── emergency/
│       ├── home/
│       ├── myRide/
│       └── setting/
│
├── docs/                                # Documentation
│   ├── README.md                        # Overview
│   ├── INDEX.md                         # Navigation guide
│   ├── QUICK_REFERENCE.md               # Quick lookups
│   ├── API_INTEGRATION_ARCHITECTURE.md  # Architecture guide
│   ├── LOGIN_TO_DASHBOARD_FLOW.md       # Flow explanation
│   ├── IMPLEMENTATION_CHECKLIST.md      # Step-by-step guide
│   ├── AUTH_FLOW_COMPLETE.md            # Complete auth code
│   ├── VISUAL_DIAGRAMS.md               # Diagrams & flowcharts
│   ├── api_prompt.md                    # API definition template
│   ├── api_usage_prompt.md              # Screen usage template
│   ├── screen_loading_pattern.md        # State pattern guide
│   └── maps/                            # Map documentation
│
├── test/                                # Unit & Widget Tests
│   ├── widget_test.dart
│   ├── unit_tests/
│   │   ├── service_test.dart
│   │   └── provider_test.dart
│   └── integration_tests/
│
├── build/                               # Build output (generated)
│   ├── app/
│   ├── connectivity_plus/
│   ├── device_info_plus/
│   ├── ... (plugin builds)
│   └── native_assets/
│
├── analysis_options.yaml                # Lint rules
├── devtools_options.yaml                # DevTools configuration
├── pubspec.yaml                         # ⭐ Dependencies
├── pubspec.lock                         # Locked dependency versions
├── README.md                            # Project README
└── .gitignore                           # Git ignore rules

```

---

## 📂 Folder Organization by Responsibility

### 🔴 Layer 1: API Integration (`lib/api/`)

**Purpose**: Handle all backend communication

```
api/
├── api_client.dart          ← HTTP requests + auto-auth
├── endpoints.dart           ← All API URLs
├── enums/                   ← Enumerations (UserStatus, etc)
├── interceptors/            ← HTTP interceptors
├── interfaces/              ← Service contracts (interfaces)
├── models/                  ← Request/Response models
│   ├── *_response.dart      ← Parse API responses
│   ├── *_request.dart       ← Build API requests
│   └── *_model.dart         ← Domain models
└── services/                ← API calls + business logic
    ├── *_service.dart       ← Service implementations
    └── storage_service.dart ← Token persistence (singleton)
```

**When to add files here:**

- New API endpoint needed? → Create response model + request model
- New business logic? → Create service
- New API integration? → Add to endpoints.dart + create service

---

### 🟠 Layer 2: State Management (`lib/provider/`)

**Purpose**: Manage application state

```
provider/
├── auth_providers/          ← Authentication state
│   ├── splash_provider.dart       ← Initial routing
│   ├── sign_in_provider.dart      ← Phone input
│   ├── otp_provider.dart          ← OTP input
│   └── add_location_provider.dart
├── app_pages_providers/     ← Feature-specific state
│   ├── add_student_provider.dart  ← Student feature
│   ├── user_provider.dart         ← Profile feature
│   ├── home_screen_provider.dart  ← Home feature
│   └── ... (other features)
├── bottom_provider/         ← Bottom navigation state
└── common_providers/        ← Shared state (theme, language)
```

**When to add files here:**

- New screen with state? → Create provider
- Feature needs state management? → Create feature provider
- New loading state? → Add to existing provider

---

### 🟡 Layer 3: UI (`lib/screens/` + `lib/widgets/`)

**Purpose**: User interface

```
screens/
├── auth_screen/             ← Login, sign up, OTP
│   ├── splash_screen/
│   ├── sign_in_screen/
│   ├── sign_up_screen/
│   ├── otp_screen/
│   └── location_layout/
├── app_pages/               ← Feature screens
│   ├── student_screen/      ← Student management
│   ├── driver_screen/       ← Driver assignment
│   ├── profile_screen/      ← User profile
│   ├── home/                ← Dashboard
│   ├── notification/        ← Notifications
│   ├── my_wallet_screen/    ← Wallet
│   └── ... (other features)
├── bottom_screen/           ← Bottom nav screens
└── no_internet_screen/      ← Error screens

widgets/
├── common_*.dart            ← Reusable widgets
├── skeletons/               ← Loading placeholders
├── ride_card/               ← Card components
├── location/                ← Location widgets
└── ... (other components)
```

**When to add files here:**

- New screen? → Create in appropriate subfolder
- Reusable widget? → Add to widgets/ folder
- Loading state? → Create skeleton

---

### 🟢 Layer 4: Navigation (`lib/routes/`)

**Purpose**: Screen routing and navigation

```
routes/
├── route_name.dart          ← Route name constants
└── route_config.dart        ← Route mappings
```

**When to add files here:**

- New screen? → Add route name + mapping

---

### 🔵 Layer 5: Utilities & Config (`lib/common/`, `lib/helper/`, `lib/models/`)

**Purpose**: Shared utilities and configuration

```
common/
├── app_array.dart           ← Common arrays
├── app_fonts.dart           ← Font/text strings
├── assets/                  ← Asset constants
├── extension/               ← Extension classes
├── languages/               ← Localization
├── theme/                   ← Theme config
└── ...

helper/
├── distance_helper.dart     ← Calculations
├── date_formatter_helper.dart
├── status_helper.dart
├── validation_helper.dart
└── ...

models/
├── user.dart                ← Domain models
├── student.dart
└── ...
```

---

### 🟣 Assets & Documentation

```
assets/
├── image/                   ← PNG/JPG images
├── svg/                     ← Vector graphics
├── gif/                     ← Animations
└── flags/                   ← Country flags

docs/
├── API_INTEGRATION_ARCHITECTURE.md
├── LOGIN_TO_DASHBOARD_FLOW.md
├── AUTH_FLOW_COMPLETE.md    ← ⭐ Use this for new projects
└── ... (other guides)
```

---

## 🏗️ Creating New Features

### Example: Add "Messages" Feature

#### Step 1: API Integration (`lib/api/`)

```
Create:
├── models/message_response.dart         (response model)
├── models/send_message_request.dart     (request model)
├── interfaces/message_service_interface.dart
└── services/message_service.dart        (API calls)

Update:
└── endpoints.dart                       (add endpoint URL)
```

#### Step 2: State Management (`lib/provider/`)

```
Create:
└── app_pages_providers/message_provider.dart (state management)
```

#### Step 3: UI (`lib/screens/` + `lib/widgets/`)

```
Create:
├── app_pages/message_screen/
│   ├── message_screen.dart              (main screen)
│   └── layout/                          (sub-layouts)
├── widgets/message_card.dart            (reusable component)
└── widgets/skeletons/message_skeleton.dart (loading state)
```

#### Step 4: Navigation (`lib/routes/`)

```
Update:
├── route_name.dart                      (add: messageScreen = '/MessageScreen')
└── route_config.dart                    (add route mapping)
```

#### Step 5: Configuration

```
Update:
└── lib/main.dart                        (register provider)
```

---

## 📋 File Naming Conventions

### Models (API)

```
<feature>_response.dart          # API response
<feature>_request.dart           # API request payload
<feature>_model.dart             # Domain model
```

### Services

```
<feature>_service_interface.dart  # Contract
<feature>_service.dart            # Implementation
```

### Providers

```
<feature>_provider.dart           # State management
```

### Screens

```
<feature>_screen.dart             # Main screen
<feature>_list_screen.dart        # List variant
<feature>_detail_screen.dart      # Detail variant
<feature>_form_screen.dart        # Form variant
```

### Widgets

```
<feature>_card.dart               # Card component
<feature>_skeleton.dart           # Loading skeleton
<feature>_button.dart             # Button component
```

---

## 🗂️ Important Files

### Entry Point

```
lib/main.dart
├─ MultiProvider setup
├─ All providers registered
├─ Routes configured
└─ Theme & Localization setup
```

### Main Imports/Exports

```
lib/config.dart
├─ Imports all commonly used classes
├─ Makes imports cleaner in screens
└─ Example: import 'package:app/config.dart'
```

### Persistent Storage

```
lib/api/services/storage_service.dart
├─ Singleton pattern
├─ Saves auth token
├─ Persists user data
└─ Used by ApiClient for auto-auth
```

### API Client

```
lib/api/api_client.dart
├─ HTTP requests
├─ Auto-injects auth token
└─ Called by all services
```

---

## 📊 Folder Structure by Feature

### Authentication Feature

```
lib/
├── api/
│   ├── models/
│   │   ├── send_otp_response.dart
│   │   ├── verify_otp_response.dart
│   │   └── profile_response.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   └── user_service.dart
│   └── endpoints.dart
├── provider/
│   └── auth_providers/
│       ├── splash_provider.dart
│       ├── sign_in_provider.dart
│       └── otp_provider.dart
└── screens/
    └── auth_screen/
        ├── splash_screen/
        ├── sign_in_screen/
        └── otp_screen/
```

### Student Management Feature

```
lib/
├── api/
│   ├── models/
│   │   ├── student_response.dart
│   │   ├── add_student_request.dart
│   │   └── school_response.dart
│   ├── services/
│   │   └── student_service.dart
│   └── endpoints.dart
├── provider/
│   └── app_pages_providers/
│       └── add_student_provider.dart
├── screens/
│   └── app_pages/
│       └── student_screen/
│           ├── student_list_screen.dart
│           └── add_student_screen.dart
└── widgets/
    ├── student_card.dart
    └── skeletons/student_card_skeleton.dart
```

### Driver Assignment Feature

```
lib/
├── api/
│   ├── models/
│   │   ├── driver_response.dart
│   │   └── assignment_request.dart
│   ├── services/
│   │   └── driver_service.dart
│   └── endpoints.dart
├── provider/
│   └── app_pages_providers/
│       └── driver_provider.dart
├── screens/
│   └── app_pages/
│       └── driver_screen/
│           ├── driver_list_screen.dart
│           └── assign_driver_screen.dart
└── widgets/
    ├── driver_card.dart
    └── skeletons/driver_skeleton.dart
```

---

## ✅ Checklist for New Feature

When adding a new feature, follow this structure:

- [ ] Create response model → `lib/api/models/<feature>_response.dart`
- [ ] Create request model (if needed) → `lib/api/models/<feature>_request.dart`
- [ ] Create service interface → `lib/api/interfaces/<feature>_service_interface.dart`
- [ ] Create service → `lib/api/services/<feature>_service.dart`
- [ ] Add endpoint → Update `lib/api/endpoints.dart`
- [ ] Create provider → `lib/provider/app_pages_providers/<feature>_provider.dart`
- [ ] Create screen → `lib/screens/app_pages/<feature>_screen/<feature>_screen.dart`
- [ ] Create skeleton → `lib/widgets/skeletons/<feature>_skeleton.dart`
- [ ] Register provider → Update `lib/main.dart`
- [ ] Add routes → Update `lib/routes/route_name.dart` and `route_config.dart`

---

## 🎯 Organization Principles

### 1. **Layer-Based Organization**

```
API Layer → Service Layer → State Layer → UI Layer
```

### 2. **Feature-Based Organization Within Layers**

```
Each feature has models, services, providers, screens in separate folders
```

### 3. **One Responsibility Per File**

```
One service per file
One provider per file
One screen per file
One model per file
```

### 4. **Reusable Components in Common Folders**

```
Shared widgets → lib/widgets/
Shared utilities → lib/helper/
Shared constants → lib/common/
```

### 5. **Clear Naming Conventions**

```
What it is → What it does
Example: student_service.dart (not StudentService_V2.dart)
```

---

## 📦 Dependencies in pubspec.yaml

```yaml
# State Management
provider: # Providers go in lib/provider/

# HTTP
http: # Used by lib/api/api_client.dart

# Storage
flutter_secure_storage: # Used by lib/api/services/storage_service.dart
shared_preferences: # Used by lib/api/services/storage_service.dart

# UI
flutter_screenutil: # Screen utilities in lib/common/screen_util/
pin_code_fields: # Used in OTP screens

# Localization
intl: # Used in lib/common/languages/
flutter_localization: # Used in lib/common/

# Maps
google_maps_flutter: # Maps in lib/screens/app_pages/maps/

# Other
device_info_plus: # Device info
connectivity_plus: # Network checking
geolocator: # Location services
geocoding: # Address geocoding
```

---

## 🚀 Quick Setup for New Project

1. **Copy all files from `lib/`** to your new project
2. **Copy `docs/AUTH_FLOW_COMPLETE.md`** as reference
3. **Update `lib/api/endpoints.dart`** with your API URLs
4. **Update `lib/main.dart`** with your app name and theme
5. **Register new providers** as you add features
6. **Follow folder structure** for new features

---

## 📚 Related Documentation

- **API Integration**: [API_INTEGRATION_ARCHITECTURE.md](API_INTEGRATION_ARCHITECTURE.md)
- **Auth Flow**: [AUTH_FLOW_COMPLETE.md](AUTH_FLOW_COMPLETE.md)
- **Complete Guide**: [README.md](README.md)

---

This folder structure ensures:
✅ Scalability (easy to add new features)
✅ Maintainability (clear organization)
✅ Testability (separated concerns)
✅ Collaboration (team understands structure)
✅ Reusability (shared components)
