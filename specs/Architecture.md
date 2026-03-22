# Flutter App Architecture

## Overview

Two separate Flutter apps for the school commute tracking platform:

- **Parent App** — receives live bus location, ETA, boarding status, and alerts
- **Driver App** — emits GPS location, SOS alerts, and connects/emits via WebSocket

Both apps will expand in future to include school events, attendance, sports, and more.

---

## Key Decisions

| Decision | Choice |
|---|---|
| State Management | Riverpod (flutter_riverpod — manual providers, no code-gen) |
| Routing | GoRouter with ShellRoute |
| Authentication | JWT — access + refresh tokens |
| Platforms | Android + iOS |
| Background | Foreground Service (Android) + Background Location Mode (iOS) |
| Push Notifications | FCM (Firebase Cloud Messaging) |
| Offline Support | None — online only |
| Codebase | Two separate Flutter projects |

---

## Folder Structure

Clean Architecture + Feature-First. Same structure applies to both apps; feature folders differ per app.

```
lib/
├── core/
│   ├── assets/             # Asset path constants (images, svgs, gifs)
│   ├── constants/          # API URLs, WS endpoints, app constants
│   ├── errors/             # Failure classes, exception types
│   ├── extensions/         # DateTime, String, Context extensions
│   ├── languages/          # Localization strings and delegates (en only)
│   ├── responsive/         # ScreenUtil — adaptive sizing, responsive width/height/font helpers
│   ├── theme/              # AppTheme, colors, typography
│   └── utils/              # Logger, validators, formatters
│
├── config/
│   ├── router/             # GoRouter config, route names, auth guard
│   └── env/                # Environment config (dev / staging / prod)
│
├── data/
│   ├── datasources/
│   │   ├── remote/         # Dio HTTP client, WebSocket client, per-feature datasources
│   │   └── local/          # SecureStorage (JWT tokens)
│   ├── models/             # JSON-serializable DTOs
│   └── repositories/       # Concrete implementations of domain interfaces
│
├── domain/
│   ├── entities/           # Pure Dart business objects — no JSON logic
│   ├── repositories/       # Abstract repository interfaces
│   └── usecases/           # One class per business operation
│
├── presentation/
│   ├── features/           # One folder per feature
│   │   ├── auth/
│   │   │   ├── pages/
│   │   │   ├── widgets/            # Widgets used only in auth feature
│   │   │   │   └── index.dart      # Barrel — exports all auth widgets
│   │   │   └── providers/
│   │   ├── tracking/       # (Parent) Live map, bus pin, ETA
│   │   │   ├── pages/
│   │   │   ├── widgets/    # Map-specific widgets used only here
│   │   │   └── providers/
│   │   ├── boarding/       # (Parent) Student boarding status
│   │   │   ├── pages/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   ├── notifications/  # Alert list, notification settings
│   │   │   ├── pages/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   └── location_emit/  # (Driver only) GPS emit + SOS
│   │       ├── pages/
│   │       ├── widgets/    # SOS button, emit status bar
│   │       └── providers/
│   │
│   ├── shell/              # App-level persistent UI chrome
│   │   ├── app_shell       # ShellRoute scaffold — holds BottomNav + AppBar
│   │   ├── app_bottom_nav  # NavigationBar with tab routing
│   │   └── app_top_bar     # Custom AppBar / Toolbar
│   │
│   └── shared/
│       ├── widgets/            # Reusable widgets — Atomic Design structure
│       │   ├── index.dart      # Barrel — re-exports atoms/ + molecules/ + organisms/ + templates/
│       │   ├── atoms/
│       │   │   └── index.dart  # Barrel — exports all atoms
│       │   ├── molecules/
│       │   │   └── index.dart  # Barrel — exports all molecules
│       │   ├── organisms/
│       │   │   └── index.dart  # Barrel — exports all organisms
│       │   └── templates/
│       │       └── index.dart  # Barrel — exports all templates
│       └── providers/          # App-wide shared Riverpod providers
│
└── services/
    ├── websocket/          # WS connection lifecycle + message dispatcher
    ├── background/         # Foreground service wrapper
    ├── notification/       # FCM setup + local notification service
    └── location/           # GPS stream + permissions (Driver app only)
```

---

## Architecture Layers

### Layer 1 — Presentation (Atomic Design)

All widgets follow Atomic Design, progressing from smallest to most complex:

| Level | Examples | Rules |
|---|---|---|
| **Atoms** | Button, TextField, Avatar, StatusBadge, LoadingIndicator | No business logic. No Riverpod access. Driven purely by props. |
| **Molecules** | StudentStatusRow, BusEtaChip, NotificationItem, InfoTile | Composed of atoms. Still fully prop-driven. |
| **Organisms** | BusTrackingCard, StudentList, AlertBanner, AppBottomNav | May access Riverpod providers. Can hold internal UI state. |
| **Templates** | MapTemplate, ListTemplate | Page layout scaffolds only. Accept slot widgets. No real data. |
| **Pages** | TrackingPage, LoginPage, DriveScreen | Registered in GoRouter. Wire providers into organisms. |

**Widget placement rule:**
- Used in **2+ features** → belongs in `shared/widgets/` at the appropriate atomic level
- Used in **1 feature only** → stays in `features/<name>/widgets/` regardless of complexity
- Data flows **down** through props. Events flow **up** through callbacks.
- Only Organisms and Pages access Riverpod providers directly.

**Barrel export rule:**
Every widget folder must have an `index.dart` that re-exports all widgets in that folder. Feature-level widget folders (`features/<name>/widgets/index.dart`) export all widgets for that feature. The shared top-level barrel (`shared/widgets/index.dart`) re-exports all atomic levels. Consumers import only the barrel:

```dart
// shared widgets — one import covers all atoms, molecules, organisms, templates
import 'package:skolo_driver/presentation/shared/widgets/index.dart';

// feature widgets — one import covers all widgets in that feature
import 'package:skolo_driver/presentation/features/auth/widgets/index.dart';
```

**Shell (Bottom Tabs + AppBar):**
The shell (`presentation/shell/`) wraps all tabbed screens via GoRouter's `ShellRoute`:
- `AppBottomNav` — NavigationBar for tab switching, navigates via GoRouter
- `AppTopBar` — custom AppBar/Toolbar whose title and actions change per active route
- Login and full-screen modal screens sit **outside** the ShellRoute — no shell chrome

### Layer 2 — Domain

- **Entities** — pure Dart business objects: `BusLocation`, `Student`, `ETAUpdate`, `Assignment`
- **Repository interfaces** — abstract contracts, no implementation detail
- **Use cases** — single business operations: `AssignStudentUseCase`, `EmitLocationUseCase`

### Layer 3 — Data

- **Models** — JSON-serializable DTOs mapping to API responses
- **Remote datasources** — HTTP via Dio, WebSocket via web_socket_channel
- **Repository implementations** — satisfy domain interfaces by delegating to datasources

### Layer 4 — Services (Cross-Cutting)

Run independently of the UI layer, shared across features:

- **WebSocket service** — manages persistent WS connection lifecycle
- **Background service** — wraps foreground task to keep app alive during active trips
- **FCM service** — receives push messages and dispatches Riverpod invalidations
- **Location service** — streams GPS coordinates from device (Driver app only)

---

## Authentication Flow

**App startup:**
On launch, the app checks SecureStorage for a valid JWT. If found and not expired, GoRouter redirects to the home screen. If missing or expired, it redirects to login.

**API requests:**
A Dio interceptor attaches the access token to every outgoing request. On a 401 response, it silently calls the refresh endpoint, stores the new token, and retries the original request. If refresh fails, it clears tokens and redirects to login.

**WebSocket connection:**
The JWT is passed as a query parameter in the WebSocket handshake URL. The backend validates it before accepting the connection.

---

## Routing & Navigation

**Route structure:**
- `/login` — standalone screen, no shell
- All tabbed screens inside a `ShellRoute` → `AppShell` renders BottomNav + AppBar persistently
- Full-screen modals defined outside `ShellRoute`

**Parent App tabs:** Tracking, Boarding, Notifications

**Driver App tabs:** Drive (active route), Notifications

**Auth guard:** GoRouter global redirect checks auth state before every navigation — unauthenticated users always redirect to `/login`.

**Deep links:** FCM notification taps carry a route path. GoRouter navigates directly to the target screen on app open or foreground.

---

## WebSocket Architecture (Live Location Only)

The WebSocket connection is used exclusively for high-frequency real-time data:
- Driver GPS coordinates — emitted every 5 seconds
- Server-calculated ETA updates
- SOS alerts

**Connection lifecycle:**
The WS service handles connect, disconnect, and automatic reconnect with exponential backoff. A heartbeat ping runs every 30 seconds to detect dead connections.

**Message dispatcher:**
An incoming message handler routes each WS message type to the appropriate Riverpod provider — updating live location state directly without a REST API call.

**Driver emission:**
The location service streams GPS from the device. The active drive screen subscribes to this stream and forwards each position update through the WS service to the backend.

---

## Background Service Architecture — Driver GPS Emission

This is the most critical part of the system. Parents only see the bus if the Driver app continuously emits GPS.

### The Core Solution: Background Location Mode

The key mechanism is **background location permission** — the same technology used by Google Maps, Waze, and Uber Driver to keep GPS running when minimized.

- **Android:** Foreground Service with `FOREGROUND_SERVICE_TYPE_LOCATION`
- **iOS:** Background Location Mode (`UIBackgroundModes: location` in Info.plist)

With these active, GPS continues running regardless of whether the app is in the foreground or background, and the WebSocket connection lives alongside it.

### Behavior by App State

| App State | Android | iOS |
|---|---|---|
| **App open** | GPS + WS running normally | GPS + WS running normally |
| **App minimized** | Foreground Service → GPS + WS continue indefinitely | Background Location Mode → iOS does NOT suspend the app while active location updates run. GPS + WS continue indefinitely |
| **OS kills app** (memory) | Service restarts automatically (`START_STICKY`) → GPS + WS resume in seconds | iOS can wake app via significant-change monitoring |
| **User force-kills app** | Service killed, cannot auto-restart — OS hard limit | App fully killed — iOS hard limit |
| **Device rebooted** | Foreground Service restarts via boot broadcast receiver | Background location resumes on next app open |

### Android — Foreground Service with Location Type

- Package: `flutter_foreground_task` with `FOREGROUND_SERVICE_TYPE_LOCATION` in AndroidManifest
- When driver starts a trip, the Foreground Service starts — this is what keeps everything alive in background
- A persistent notification is shown in the notification tray — Android mandates this for foreground services (e.g. "Trip Active — Bus Tracker Running")
- Inside the background Isolate: GPS stream + WS connection + location emission every 5 seconds
- Configured as `START_STICKY` — OS auto-restarts if killed for memory reasons; WS reconnects automatically
- Tapping the notification deep-links the driver back to the active trip screen

**User force-close:** Service is killed and cannot restart. UX guidance: warn the driver "Closing the app stops tracking. Parents will lose bus visibility." Driver should minimise, not close — same expectation as Google Maps during navigation.

### iOS — Background Location Mode

- App declares `location` in `UIBackgroundModes` — this enables continuous background GPS
- When a trip starts, location updates activate with background updates enabled and auto-pause disabled
- iOS does NOT suspend the app while active location updates are running — the WS stays alive too
- iOS shows a blue indicator bar when background location is active — normal OS behaviour

**User force-close on iOS:** App process is killed. GPS stops. No technical workaround exists. Strategy:
- UX warning before closing, same as Android
- Server-side detection: if no GPS received for 60 seconds → backend sends visible FCM push to driver: "Tracking stopped — please reopen the app"

### Trip Lifecycle (Both Platforms)

1. Driver taps **Start Trip** → Foreground Service / Background Location activates
2. GPS stream begins → WS connects → location emits every 5 seconds
3. Driver minimizes app → GPS + WS continue unchanged
4. Driver taps **End Trip** → GPS stream stops → WS disconnects → service stops
5. Parents' map pin stops updating

---

## Real-Time Data Refresh Strategy

Two separate mechanisms handle different data types:

### WebSocket — Live Streaming Data

For data that changes continuously and must update the UI immediately:
- Bus GPS coordinates → map pin moves in real-time
- ETA countdown → pushed as WS event from server
- SOS alert → immediately shown on all subscribed parent devices

### FCM Silent Push — Business Event Triggers

For cross-app state changes (student assigned, driver approves request, admin changes). The backend sends a **silent FCM data message** (no visible notification) to the target device. The app receives it in any state — foreground, background, or killed — and triggers a Riverpod provider invalidation, which re-fetches the REST API and rebuilds the screen automatically.

**Flow — Parent assigns student to driver:**
1. Parent submits the assignment via REST API
2. Backend sends silent FCM to Driver's device: `{ "type": "student_assigned" }`
3. Driver's FCM handler invalidates the assignments provider
4. Riverpod re-fetches REST API → driver's screen updates with the new student without any navigation

**Flow — Driver approves assignment:**
1. Driver calls REST API to approve
2. Backend sends silent FCM to Parent's device: `{ "type": "assignment_approved" }`
3. Parent FCM handler invalidates the student status provider
4. Parent's screen rebuilds showing "Approved" status automatically

**FCM handles all three app states:**
- **Foreground** → `onMessage` listener fires → invalidate provider
- **Background** → background message handler fires → invalidate provider
- **Killed** → app launches from notification tap → GoRouter deep-links + provider fetches fresh

### Refresh Patterns Summary

| Data Type | Mechanism | How UI Updates |
|---|---|---|
| Live GPS / bus location | WebSocket | StreamProvider updates map widget directly |
| SOS alert / ETA | WebSocket | StateNotifier updated directly from WS payload |
| Student assignment / approval | FCM Silent Push | Provider invalidated → REST API re-fetched |
| Any business state change | FCM Silent Push | Provider invalidated → REST API re-fetched |

### Screen Data Lifecycle

1. **Screen opens** — Riverpod provider fetches data from REST API (initial load)
2. **User stays on screen** — FCM silent pushes trigger re-fetches; WS stream updates live widgets
3. **App backgrounded or killed** — FCM handled in background isolate; state refreshed when app returns

---

## Notification Flow

**Foreground (app open):**
WS message or FCM data message → message dispatcher → local notification service → heads-up overlay shown

**Background (app minimized):**
FCM arrives → background isolate handles it → `flutter_local_notifications` shows banner

**Killed (app closed):**
FCM arrives → OS delivers notification → user taps → app launches → GoRouter processes deep-link path from FCM payload → navigates to correct screen

---

## Key Packages

| Purpose | Package |
|---|---|
| State management | flutter_riverpod |
| Routing | go_router |
| HTTP client | dio, retrofit, retrofit_generator |
| WebSocket | web_socket_channel |
| Model code generation | freezed, json_serializable, build_runner |
| Background / foreground service | flutter_foreground_task |
| Push notifications | firebase_messaging, flutter_local_notifications |
| Secure storage | flutter_secure_storage |
| GPS (Driver app) | geolocator, permission_handler |
| Environment config | flutter_dotenv |
| Logging | talker_flutter (with Dio + Riverpod adapters) |

---

## Critical Files Per App

### Parent App

| File | Responsibility |
|---|---|
| `lib/services/websocket/ws_service` | WS connection lifecycle — connect, disconnect, reconnect, heartbeat |
| `lib/services/background/background_service` | Foreground task wrapper — keeps WS alive when minimized |
| `lib/services/notification/fcm_service` | Silent push handler — invalidates Riverpod providers on FCM events |
| `lib/presentation/shell/app_shell` | BottomNav + AppBar shell via GoRouter ShellRoute |
| `lib/presentation/features/tracking/` | Live map page + location stream providers |
| `lib/presentation/features/boarding/` | Student boarding status page + providers |
| `lib/config/router/app_router` | GoRouter configuration + auth guard |

### Driver App

| File | Responsibility |
|---|---|
| `lib/services/location/location_service` | GPS stream + permission management |
| `lib/services/websocket/ws_service` | Emit GPS coordinates + receive WS events |
| `lib/services/background/background_service` | Foreground Service + GPS emission inside background Isolate |
| `lib/services/notification/fcm_service` | Silent push handler — invalidates providers on FCM events |
| `lib/presentation/features/location_emit/` | Active drive screen + trip lifecycle management |
| `lib/config/router/app_router` | GoRouter configuration + auth guard |
