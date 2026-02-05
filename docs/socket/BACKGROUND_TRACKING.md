# Background Location Tracking

Real-time driver location tracking with offline support.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Main App (UI)                          │
│                           │                                 │
│              ForegroundTrackingService                      │
│                           │                                 │
└───────────────────────────┼─────────────────────────────────┘
                            │ invoke()
┌───────────────────────────┼─────────────────────────────────┐
│              Background Isolate                             │
│                           │                                 │
│              BackgroundLocationHandler                      │
│                    │              │                         │
│              Socket.IO        REST API                      │
│             (every 10s)     (every 100m)                    │
│                    │              │                         │
│                    └──────┬───────┘                         │
│                           │                                 │
│                   PositionQueueService                      │
│                      (SQLite)                               │
└─────────────────────────────────────────────────────────────┘
```

## Files

| File                                           | Purpose                               |
| ---------------------------------------------- | ------------------------------------- |
| `lib/helper/foreground_tracking_service.dart`  | UI communication, service lifecycle   |
| `lib/helper/background_location_handler.dart`  | Location tracking, socket/API updates |
| `lib/api/services/position_queue_service.dart` | SQLite offline queue                  |

## Update Mechanisms

### Socket (Real-time)

- **Frequency**: Every 10 seconds
- **Event**: `driver:update_position`
- **Purpose**: Real-time parent tracking

### REST API (Persistent)

- **Trigger**: Every 100 meters movement
- **Endpoint**: `PATCH /tracking/{tripId}/position`
- **Purpose**: Server-side trip history

## Offline Queue

Failed updates are stored in SQLite and retried every 30 seconds.

```
position_queue.db
├── trip_id
├── latitude, longitude
├── speed, heading, accuracy
├── timestamp
├── type (socket/api)
├── synced (0/1)
└── created_at
```

## Usage

### Start Tracking

```dart
final service = ForegroundTrackingService();
await service.initialize();
await service.startTracking(tripId);
```

### Stop Tracking

```dart
service.stopTracking();
```

### Listen to Updates

```dart
service.positionStream.listen((position) {
  // Update UI map
});

service.statusStream.listen((status) {
  // 'starting', 'started', 'stopping', 'stopped'
});
```

## Storage Keys

Keys stored in `FlutterSecureStorage` (must use same options across all services):

| Key          | Purpose                 |
| ------------ | ----------------------- |
| `auth_token` | JWT for API/socket auth |
| `user_id`    | Driver identification   |
| `base_url`   | API base URL            |

## Configuration

Defined in `lib/config/app_constants.dart`:

| Constant                  | Value      | Purpose                 |
| ------------------------- | ---------- | ----------------------- |
| `socketEmitInterval`      | 10 seconds | Socket update frequency |
| `apiUpdateDistanceFilter` | 100 meters | API update distance     |

## Flow

```
1. User starts trip
   └── startTracking(tripId)

2. Background service starts
   └── Foreground notification shown
   └── Socket connects
   └── Location stream starts

3. Position updates received
   ├── Send to UI (map update)
   ├── Every 10s → Socket emit
   └── Every 100m → API call

4. If socket/API fails
   └── Queue to SQLite

5. Every 30 seconds
   └── Retry queued positions

6. User ends trip
   └── stopTracking()
   └── Service stops
```

## Permissions Required

### Android

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
```

### iOS

```
NSLocationWhenInUseUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
UIBackgroundModes: location
```
