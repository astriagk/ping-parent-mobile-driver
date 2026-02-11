# Trip Resume Implementation Guide

## Problem Statement

When a driver minimizes/closes and reopens the app during an active trip:

- **Current behavior**: Trip restarts from the beginning (waypoint 0)
- **Expected behavior**: Trip resumes from the current waypoint

### Example Scenario

- **PICKUP Trip**: Driver has 10 waypoints, already picked up 5 students
- Driver closes app → Reopens → Goes to Active Rides → Clicks trip
- **Current**: Navigates to map, shows "Start Trip" button, calls API, starts from waypoint 0
- **Expected**: Navigates to map, shows waypoint 6 directly, continues trip

---

## Solution: Hybrid Backend + Frontend Approach

| Component    | Responsibility                                               |
| ------------ | ------------------------------------------------------------ |
| **Backend**  | Source of truth for trip progress (which students processed) |
| **Frontend** | Local cache for instant resume + sync with backend           |

### Why Hybrid?

- **Backend as source of truth**: Survives app reinstall, works across devices, prevents stale state
- **Frontend cache**: Instant resume (no API wait), works briefly offline

---

## Backend Implementation

### 1. New Endpoint: Get Trip Progress

**Endpoint**: `GET /trips/{tripId}/progress`

**Purpose**: Returns the current state of an in-progress trip so the driver app can resume.

#### Request

```http
GET /trips/TRP-123456/progress
Authorization: Bearer <token>
```

#### Response (Success - 200)

```json
{
  "success": true,
  "message": "Trip progress retrieved successfully",
  "data": {
    "tripId": "TRP-123456",
    "tripType": "pickup",
    "tripStatus": "in_progress",
    "currentWaypointIndex": 5,
    "totalWaypoints": 10,
    "processedStudentIds": [
      "student_id_1",
      "student_id_2",
      "student_id_3",
      "student_id_4",
      "student_id_5"
    ],
    "absentStudentIds": ["student_id_6"],
    "optimizedRouteId": "route_mongodb_id",
    "startedAt": "2026-02-11T08:30:00.000Z",
    "lastPositionUpdate": "2026-02-11T09:15:00.000Z"
  }
}
```

#### Response (Trip Not Found - 404)

```json
{
  "success": false,
  "message": "Trip not found",
  "data": null
}
```

#### Response (Trip Not Active - 400)

```json
{
  "success": false,
  "message": "Trip is not active. Status: completed",
  "data": null
}
```

### 2. Backend Logic for `currentWaypointIndex`

The backend calculates the current waypoint index based on processed students:

```javascript
// Pseudocode for calculating currentWaypointIndex

async function calculateCurrentWaypointIndex(tripId) {
  // 1. Get the optimized route with waypoints
  const route = await OptimizedRoute.findOne({ tripId });
  const waypoints = route.routeGeometry.waypoints;

  // 2. Get all processed trip-students for this trip
  const processedStudents = await TripStudent.find({
    tripId,
    status: { $in: ["picked_up", "dropped_off", "absent"] },
  });

  const processedStudentIds = new Set(
    processedStudents.map((s) => s.studentId.toString()),
  );

  // 3. Find first waypoint with unprocessed students
  for (let i = 0; i < waypoints.length; i++) {
    const waypoint = waypoints[i];

    // Skip school waypoint for pickup trips (it's the destination)
    if (waypoint.studentParentId === "school") {
      continue;
    }

    // Check if ALL students at this waypoint are processed
    const allProcessed = waypoint.studentIds.every((studentId) =>
      processedStudentIds.has(studentId),
    );

    if (!allProcessed) {
      return i; // This is the current waypoint
    }
  }

  // All student waypoints processed, return school waypoint index
  return waypoints.findIndex((w) => w.studentParentId === "school");
}
```

### 3. Database Schema Updates (Optional Enhancement)

Add fields to Trip collection for faster queries:

```javascript
// trips collection
{
  _id: ObjectId,
  tripId: "TRP-123456",
  tripStatus: "in_progress",
  tripType: "pickup",

  // NEW FIELDS
  currentWaypointIndex: 5,        // Updated after each pickup/dropoff
  lastProcessedAt: ISODate,       // Timestamp of last student processing

  // ... existing fields
}
```

**Alternative**: Calculate on-the-fly from `trip_students` status (no schema change needed).

### 4. Update Existing Endpoints

#### `POST /trip-students/trip/{tripId}/pickup-point`

After successfully processing a pickup, optionally update trip's `currentWaypointIndex`:

```javascript
// After successful pickup processing
await Trip.findOneAndUpdate(
  { tripId },
  {
    $set: {
      currentWaypointIndex: calculateNextWaypointIndex(),
      lastProcessedAt: new Date(),
    },
  },
);
```

#### `POST /trip-students/trip/{tripId}/school-point`

Same pattern for school dropoff.

---

## Frontend Implementation

### 1. Create Active Trip Cache Service

**File**: `lib/api/services/active_trip_cache_service.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveTripCacheService {
  static const String _activeTripKey = 'active_trip_cache';

  /// Save active trip state to local storage
  static Future<void> saveActiveTrip({
    required String tripId,
    required String routeId,
    required String tripType,
    required int currentWaypointIndex,
    required List<String> processedStudentIds,
    String? optimizedRouteJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'tripId': tripId,
      'routeId': routeId,
      'tripType': tripType,
      'currentWaypointIndex': currentWaypointIndex,
      'processedStudentIds': processedStudentIds,
      'optimizedRouteJson': optimizedRouteJson,
      'savedAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_activeTripKey, jsonEncode(data));
  }

  /// Get cached active trip state
  static Future<ActiveTripCache?> getActiveTrip() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_activeTripKey);
    if (jsonString == null) return null;

    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return ActiveTripCache.fromJson(data);
    } catch (e) {
      // Corrupted cache, clear it
      await clearActiveTrip();
      return null;
    }
  }

  /// Update only the waypoint index (fast update)
  static Future<void> updateWaypointIndex(int newIndex) async {
    final cache = await getActiveTrip();
    if (cache != null) {
      await saveActiveTrip(
        tripId: cache.tripId,
        routeId: cache.routeId,
        tripType: cache.tripType,
        currentWaypointIndex: newIndex,
        processedStudentIds: cache.processedStudentIds,
        optimizedRouteJson: cache.optimizedRouteJson,
      );
    }
  }

  /// Add processed student IDs
  static Future<void> addProcessedStudents(List<String> studentIds) async {
    final cache = await getActiveTrip();
    if (cache != null) {
      final updatedIds = [...cache.processedStudentIds, ...studentIds];
      await saveActiveTrip(
        tripId: cache.tripId,
        routeId: cache.routeId,
        tripType: cache.tripType,
        currentWaypointIndex: cache.currentWaypointIndex,
        processedStudentIds: updatedIds.toSet().toList(),
        optimizedRouteJson: cache.optimizedRouteJson,
      );
    }
  }

  /// Clear active trip cache (call on trip completion)
  static Future<void> clearActiveTrip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeTripKey);
  }

  /// Check if there's an active cached trip
  static Future<bool> hasActiveTrip() async {
    final cache = await getActiveTrip();
    return cache != null;
  }
}

/// Model for cached trip data
class ActiveTripCache {
  final String tripId;
  final String routeId;
  final String tripType;
  final int currentWaypointIndex;
  final List<String> processedStudentIds;
  final String? optimizedRouteJson;
  final DateTime savedAt;

  ActiveTripCache({
    required this.tripId,
    required this.routeId,
    required this.tripType,
    required this.currentWaypointIndex,
    required this.processedStudentIds,
    this.optimizedRouteJson,
    required this.savedAt,
  });

  factory ActiveTripCache.fromJson(Map<String, dynamic> json) {
    return ActiveTripCache(
      tripId: json['tripId'] as String,
      routeId: json['routeId'] as String,
      tripType: json['tripType'] as String,
      currentWaypointIndex: json['currentWaypointIndex'] as int,
      processedStudentIds: List<String>.from(json['processedStudentIds'] ?? []),
      optimizedRouteJson: json['optimizedRouteJson'] as String?,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
```

### 2. Create Trip Progress Model

**File**: `lib/api/models/trip_progress_model.dart`

```dart
class TripProgressResponse {
  final bool success;
  final String message;
  final TripProgress? data;

  TripProgressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TripProgressResponse.fromJson(Map<String, dynamic> json) {
    return TripProgressResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? TripProgress.fromJson(json['data'])
          : null,
    );
  }
}

class TripProgress {
  final String tripId;
  final String tripType;
  final String tripStatus;
  final int currentWaypointIndex;
  final int totalWaypoints;
  final List<String> processedStudentIds;
  final List<String> absentStudentIds;
  final String optimizedRouteId;
  final DateTime? startedAt;
  final DateTime? lastPositionUpdate;

  TripProgress({
    required this.tripId,
    required this.tripType,
    required this.tripStatus,
    required this.currentWaypointIndex,
    required this.totalWaypoints,
    required this.processedStudentIds,
    required this.absentStudentIds,
    required this.optimizedRouteId,
    this.startedAt,
    this.lastPositionUpdate,
  });

  factory TripProgress.fromJson(Map<String, dynamic> json) {
    return TripProgress(
      tripId: json['tripId'] as String,
      tripType: json['tripType'] as String,
      tripStatus: json['tripStatus'] as String,
      currentWaypointIndex: json['currentWaypointIndex'] as int,
      totalWaypoints: json['totalWaypoints'] as int,
      processedStudentIds: List<String>.from(json['processedStudentIds'] ?? []),
      absentStudentIds: List<String>.from(json['absentStudentIds'] ?? []),
      optimizedRouteId: json['optimizedRouteId'] as String,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      lastPositionUpdate: json['lastPositionUpdate'] != null
          ? DateTime.parse(json['lastPositionUpdate'])
          : null,
    );
  }
}
```

### 3. Add Endpoint to endpoints.dart

**File**: `lib/api/endpoints.dart`

```dart
// Add this endpoint
static String tripProgress(String tripId) => '/trips/$tripId/progress';
```

### 4. Update PickUpCustomerProvider

**File**: `lib/provider/bottom_bar_provider/pick_up_customer_provider.dart`

Add these methods:

```dart
// Add state variable
int _currentWaypointIndex = 0;
int get currentWaypointIndex => _currentWaypointIndex;

List<String> _processedStudentIds = [];
List<String> get processedStudentIds => _processedStudentIds;

/// Fetch trip progress from backend (for resume)
Future<TripProgress?> fetchTripProgress(String tripId) async {
  try {
    _isLoading = true;
    notifyListeners();

    final response = await _apiClient.get(
      Endpoints.tripProgress(tripId),
    );

    if (response.statusCode == 200) {
      final progressResponse = TripProgressResponse.fromJson(response.data);
      if (progressResponse.success && progressResponse.data != null) {
        _currentWaypointIndex = progressResponse.data!.currentWaypointIndex;
        _processedStudentIds = progressResponse.data!.processedStudentIds;

        // Update local cache
        await ActiveTripCacheService.saveActiveTrip(
          tripId: tripId,
          routeId: progressResponse.data!.optimizedRouteId,
          tripType: progressResponse.data!.tripType,
          currentWaypointIndex: _currentWaypointIndex,
          processedStudentIds: _processedStudentIds,
        );

        return progressResponse.data;
      }
    }
    return null;
  } catch (e) {
    _errorMessage = 'Failed to fetch trip progress: $e';
    return null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

/// Set waypoint index (from cache or API)
void setCurrentWaypointIndex(int index) {
  _currentWaypointIndex = index;
  notifyListeners();
}

/// Add processed students and update cache
Future<void> addProcessedStudents(List<String> studentIds) async {
  for (final id in studentIds) {
    if (!_processedStudentIds.contains(id)) {
      _processedStudentIds.add(id);
    }
  }
  await ActiveTripCacheService.addProcessedStudents(studentIds);
  notifyListeners();
}

/// Move to next waypoint and update cache
Future<void> moveToNextWaypoint() async {
  _currentWaypointIndex++;
  await ActiveTripCacheService.updateWaypointIndex(_currentWaypointIndex);
  notifyListeners();
}

/// Clear trip state on completion
Future<void> clearTripState() async {
  _currentWaypointIndex = 0;
  _processedStudentIds.clear();
  await ActiveTripCacheService.clearActiveTrip();
  notifyListeners();
}
```

### 5. Update PickUpCustomerScreen

**File**: `lib/screens/bottom_navigation_bar/layouts/pick_up_customer_screen/pick_up_customer_screen.dart`

#### 5.1 Add Resume Detection

```dart
class _PickUpCustomerScreenState extends State<PickUpCustomerScreen> {
  // ... existing state ...

  bool _isResuming = false;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
    WidgetsBinding.instance.addObserver(this);

    // Check if resuming existing trip
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForResume();
    });
  }

  Future<void> _checkForResume() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;

    // Check if explicitly resuming
    if (args?['isResuming'] == true) {
      _isResuming = true;
      await _resumeTrip(args?['tripId']);
      return;
    }

    // Check local cache for interrupted trip
    final cache = await ActiveTripCacheService.getActiveTrip();
    if (cache != null) {
      // Validate cache matches current trip
      final currentTripId = args?['tripId'];
      if (cache.tripId == currentTripId) {
        _isResuming = true;
        await _resumeFromCache(cache);
        return;
      }
    }

    // No resume needed, show start trip UI
    _resetTripState();
  }

  Future<void> _resumeTrip(String? tripId) async {
    if (tripId == null) return;

    // 1. Quick restore from cache
    final cache = await ActiveTripCacheService.getActiveTrip();
    if (cache != null && cache.tripId == tripId) {
      setState(() {
        currentWaypointIndex = cache.currentWaypointIndex;
        _pickedUpStudentIds.addAll(cache.processedStudentIds);
        isPickedUpCustomerClick = true; // Skip start button
      });
    }

    // 2. Sync with backend (authoritative)
    final progress = await _pickUpProvider.fetchTripProgress(tripId);
    if (progress != null) {
      setState(() {
        currentWaypointIndex = progress.currentWaypointIndex;
        _pickedUpStudentIds.clear();
        _pickedUpStudentIds.addAll(progress.processedStudentIds);
        isPickedUpCustomerClick = true;
        _currentTripId = tripId;
      });

      // Resume location tracking
      await _pickUpProvider.startLocationTracking(tripId);
    }

    // 3. Fetch route if not cached
    if (_pickUpProvider.optimizedRoute == null) {
      await _fetchOptimizedRoute(tripId);
    }
  }

  Future<void> _resumeFromCache(ActiveTripCache cache) async {
    setState(() {
      currentWaypointIndex = cache.currentWaypointIndex;
      _pickedUpStudentIds.addAll(cache.processedStudentIds);
      isPickedUpCustomerClick = true;
      _currentTripId = cache.tripId;
      _isDropTrip = cache.tripType == 'drop';
    });

    // Sync with backend
    await _resumeTrip(cache.tripId);
  }
}
```

#### 5.2 Update Waypoint Completion to Save Cache

```dart
Future<void> _handleWaypointCompletion() async {
  // ... existing logic ...

  // After successful completion, update cache
  await ActiveTripCacheService.updateWaypointIndex(currentWaypointIndex + 1);
}

Future<void> _addPickedUpStudents(List<String> studentIds) async {
  // ... existing logic ...

  // Update cache with new students
  await ActiveTripCacheService.addProcessedStudents(studentIds);
}
```

#### 5.3 Clear Cache on Trip Completion

```dart
Future<void> _completeDropTrip() async {
  // ... existing logic ...

  // Clear cache on completion
  await ActiveTripCacheService.clearActiveTrip();
}

Future<void> _processSchoolDropoff() async {
  // ... existing logic ...

  // Clear cache on completion
  await ActiveTripCacheService.clearActiveTrip();
}
```

### 6. Update ActiveRideScreen

**File**: `lib/screens/bottom_navigation_bar/layouts/active_ride_screen/active_ride_screen.dart`

Update navigation to pass `isResuming` flag:

```dart
Future<void> _onCreateTripTap(TripType tripType, ActiveRideProvider activeRidePvr) async {
  if (_tripExists(tripType, activeRidePvr)) {
    final trip = activeRidePvr.myTrips.firstWhere((t) => t.tripType == tripType);
    final status = TripStatus.fromString(trip.tripStatus);

    // Determine if this is a resume (trip already started)
    final isResuming = status == TripStatus.started ||
                       status == TripStatus.inProgress;

    if (tripType == TripType.drop) {
      context.read<DropStudentSelectionProvider>().setCurrentTripId(trip.tripId);

      if (isResuming) {
        // Skip student selection, go directly to map
        await route.pushNamed(
          context,
          routeName.pickupCustomerScreen,
          arg: {
            'tripId': trip.tripId,
            'isResuming': true,
            'isDropTrip': true,
          },
        );
      } else {
        await route.pushNamed(context, routeName.dropStudentSelectionScreen);
      }
    } else {
      await route.pushNamed(
        context,
        routeName.pickupCustomerScreen,
        arg: {
          'tripId': trip.tripId,
          'isResuming': isResuming,
        },
      );
    }

    // ... rest of existing logic
  }
}
```

---

## Testing Checklist

### Backend Tests

| Test Case                                         | Expected Result                           |
| ------------------------------------------------- | ----------------------------------------- |
| `GET /trips/{tripId}/progress` for scheduled trip | Returns 400, "Trip is not active"         |
| `GET /trips/{tripId}/progress` for started trip   | Returns 200 with currentWaypointIndex = 0 |
| `GET /trips/{tripId}/progress` after 3 pickups    | Returns 200 with currentWaypointIndex = 3 |
| `GET /trips/{tripId}/progress` for completed trip | Returns 400, "Trip is not active"         |
| `GET /trips/{tripId}/progress` for invalid tripId | Returns 404, "Trip not found"             |

### Frontend Tests

| Test Case                         | Steps                                                                        | Expected Result                                 |
| --------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------- |
| Fresh trip start                  | Start new trip                                                               | Shows "Start Trip" button, begins at waypoint 0 |
| Resume mid-trip                   | Start trip → Complete 3 waypoints → Kill app → Reopen → Tap trip             | Skips start button, shows waypoint 4            |
| Resume after school pickup (DROP) | Start DROP trip → Select students → Kill app → Reopen                        | Goes directly to map, shows correct waypoint    |
| Cache vs Backend sync             | Start trip → Complete 2 waypoints → Another device marks 1 more → Reopen app | Shows waypoint 4 (synced from backend)          |
| Trip completed elsewhere          | Start trip → Complete on another device → Reopen app                         | Shows trip completed, clears cache              |
| Corrupted cache                   | Manually corrupt SharedPreferences                                           | Falls back to backend API                       |

---

## Migration Notes

### Backward Compatibility

- **No breaking changes** to existing APIs
- New `GET /trips/{tripId}/progress` endpoint is additive
- Frontend changes are isolated to resume flow
- Existing "Start Trip" flow remains unchanged for new trips

### Rollout Strategy

1. **Phase 1**: Deploy backend endpoint
2. **Phase 2**: Deploy frontend with cache + resume logic
3. **Phase 3**: Monitor for edge cases
4. **Phase 4**: Add optional route caching for offline support

---

## Open Questions

1. **Should we cache the full optimized route JSON?**
   - Pro: Faster resume, works offline
   - Con: Storage overhead, potential stale waypoint data
   - Recommendation: Start without route caching, add if needed

2. **How to handle multi-device scenarios?**
   - If driver logs into a new device mid-trip, backend is source of truth
   - Local cache is cleared if tripId doesn't match

3. **What if backend and cache disagree?**
   - Backend wins (source of truth)
   - Cache is updated to match backend after sync

---

## Summary

| Layer        | Changes Required                                                |
| ------------ | --------------------------------------------------------------- |
| **Backend**  | 1 new endpoint: `GET /trips/{tripId}/progress`                  |
| **Frontend** | 1 new service + 1 new model + provider updates + screen updates |

**Estimated Effort**:

- Backend: ~4-6 hours
- Frontend: ~6-8 hours
- Testing: ~4 hours
