# OpenFreeMap Code Reference Guide

Complete code reference for the free maps implementation using OpenStreetMap, flutter_map, and OSRM.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Configuration](#configuration)
3. [Widgets Reference](#widgets-reference)
4. [Screens Reference](#screens-reference)
5. [Services Reference](#services-reference)
6. [Usage Examples](#usage-examples)

---

## Architecture Overview

```
lib/
├── common/
│   └── map_config.dart              # Global map configuration
├── widgets/
│   └── maps/
│       ├── index.dart               # Barrel export file
│       ├── custom_map_widget.dart   # Reusable map component
│       ├── map_markers.dart         # Custom marker builders
│       ├── route_polylines.dart     # Route line styles
│       ├── map_overlays.dart        # UI overlay components
│       ├── map_utils.dart           # Utility functions
│       ├── osrm_service.dart        # Routing service
│       └── layout/
│           └── osm_tile_layer.dart  # Tile layer widget
└── screens/
    └── maps/
        ├── maps_examples_menu.dart      # Examples navigation
        ├── basic_map_screen.dart        # Simple map example
        ├── location_picker_screen.dart  # Location selection
        ├── multi_marker_map_screen.dart # Multiple markers
        ├── realtime_tracking_screen.dart # GPS tracking
        └── route_planning_screen.dart   # Route calculation
```

---

## Configuration

### MapConfig (`lib/common/map_config.dart`)

Central configuration for map tile providers and settings.

```dart
class MapConfig {
  // Selected tile index (0-6)
  static const int selectedTileIndex = 1;

  // Available tile providers
  static const List<Map<String, String>> osmTileOptions = [
    {
      'name': 'OSM Standard',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    },
    {
      'name': 'CartoDB Positron (Light)',
      'url': 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    },
    {
      'name': 'CartoDB Dark Matter',
      'url': 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    },
    {
      'name': 'Stamen Toner',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/toner/{z}/{x}/{y}.png',
    },
    {
      'name': 'Stamen Watercolor',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg',
    },
    {
      'name': 'Stamen Terrain',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg',
    },
    {
      'name': 'OpenTopoMap',
      'url': 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
    },
  ];

  static String get selectedTileUrl =>
      osmTileOptions[selectedTileIndex]['url']!;

  static const String userAgentPackageName = 'com.yourapp.package';
}
```

#### Tile Providers Comparison

| Index | Provider           | Style       | Best For                |
| ----- | ------------------ | ----------- | ----------------------- |
| 0     | OSM Standard       | Classic     | General use             |
| 1     | CartoDB Positron   | Light/Clean | Modern apps, light mode |
| 2     | CartoDB Dark       | Dark        | Dark mode apps          |
| 3     | Stamen Toner       | High contrast | Printing, accessibility |
| 4     | Stamen Watercolor  | Artistic    | Decorative purposes     |
| 5     | Stamen Terrain     | Topographic | Outdoor/hiking apps     |
| 6     | OpenTopoMap        | Topographic | Detailed terrain        |

---

## Widgets Reference

### 1. OSMTileLayer (`lib/widgets/maps/layout/osm_tile_layer.dart`)

Reusable tile layer with retina support.

```dart
class OSMTileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;
  final double? opacity;

  const OSMTileLayer({
    this.urlTemplate,
    this.tileKey,
    this.opacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = urlTemplate ?? MapConfig.selectedTileUrl;
    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: MapConfig.userAgentPackageName,
      retinaMode: RetinaMode.isHighDensity(context),
    );
  }
}
```

**Usage:**

```dart
// Default tile layer (uses MapConfig.selectedTileUrl)
OSMTileLayer()

// Custom tile URL
OSMTileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png')

// Dynamic switching
OSMTileLayer(urlTemplate: MapConfig.osmTileOptions[selectedIndex]['url']!)
```

---

### 2. CustomMapWidget (`lib/widgets/maps/custom_map_widget.dart`)

Fully customizable map widget with all common features.

```dart
class CustomMapWidget extends StatelessWidget {
  final MapController? controller;
  final LatLng initialCenter;
  final double initialZoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final Function(TapPosition, LatLng)? onTap;
  final void Function(MapCamera, bool)? onPositionChanged;
  final bool showUserLocation;
  final Widget? overlayWidget;

  const CustomMapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = 15.0,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
    this.onPositionChanged,
    this.showUserLocation = false,
    this.overlayWidget,
  });
}
```

**Usage:**

```dart
CustomMapWidget(
  controller: _mapController,
  initialCenter: LatLng(37.7749, -122.4194),
  initialZoom: 15.0,
  markers: [
    MapMarkers.pickupMarker(LatLng(37.7749, -122.4194), context),
  ],
  polylines: [
    RoutePolylines.activeRoute(routePoints, context),
  ],
  onTap: (tapPosition, latLng) {
    // Handle tap
  },
)
```

---

### 3. MapMarkers (`lib/widgets/maps/map_markers.dart`)

Pre-built marker styles for different location types.

```dart
class MapMarkers {
  /// Pickup location marker (green)
  static Marker pickupMarker(LatLng point, BuildContext context, {VoidCallback? onTap});

  /// Drop location marker (red)
  static Marker dropMarker(LatLng point, BuildContext context, {VoidCallback? onTap});

  /// Current location marker
  static Marker currentLocationMarker(LatLng point, BuildContext context);

  /// Driver location marker
  static Marker driverMarker(LatLng point, BuildContext context, {VoidCallback? onTap});

  /// Custom marker with specified icon and color
  static Marker customMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  });
}
```

**Usage:**

```dart
// Pickup marker
MapMarkers.pickupMarker(
  LatLng(37.7749, -122.4194),
  context,
  onTap: () => print('Pickup tapped'),
)

// Drop marker
MapMarkers.dropMarker(LatLng(37.7849, -122.4094), context)

// Current location
MapMarkers.currentLocationMarker(currentPosition, context)

// Driver marker
MapMarkers.driverMarker(driverPosition, context)

// Custom marker
MapMarkers.customMarker(
  point: LatLng(37.7749, -122.4194),
  icon: Icons.school,
  color: Colors.purple,
  onTap: () => print('School tapped'),
)
```

---

### 4. RoutePolylines (`lib/widgets/maps/route_polylines.dart`)

Pre-defined polyline styles for routes.

```dart
class RoutePolylines {
  /// Active route (solid blue line)
  static Polyline activeRoute(List<LatLng> points, BuildContext context);

  /// Planned route (dotted line)
  static Polyline plannedRoute(List<LatLng> points, BuildContext context);

  /// Completed route (green)
  static Polyline completedRoute(List<LatLng> points, BuildContext context);

  /// Alternative route (dashed orange)
  static Polyline alternativeRoute(List<LatLng> points, BuildContext context);

  /// Alert/danger route (red)
  static Polyline alertRoute(List<LatLng> points, BuildContext context);

  /// Custom route with specified color and width
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 3.0,
  });

  /// Multi-segment route with gradient colors
  static List<Polyline> gradientRoute(
    List<LatLng> points,
    BuildContext context, {
    Color? startColor,
    Color? endColor,
    int segments = 5,
  });
}
```

**Usage:**

```dart
// Active route
RoutePolylines.activeRoute(routePoints, context)

// Completed route
RoutePolylines.completedRoute(completedPoints, context)

// Custom route
RoutePolylines.customRoute(
  points: routePoints,
  color: Colors.purple,
  strokeWidth: 5.0,
)

// Gradient route (shows progress)
RoutePolylines.gradientRoute(
  routePoints,
  context,
  startColor: Colors.green,
  endColor: Colors.red,
  segments: 10,
)
```

---

### 5. MapOverlays (`lib/widgets/maps/map_overlays.dart`)

UI overlay components for maps.

#### MapControls

```dart
class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final VoidCallback? onLayers;
  final bool showLayersButton;
}
```

**Usage:**

```dart
Stack(
  children: [
    FlutterMap(...),
    MapControls(
      onZoomIn: () => _mapController.move(center, zoom + 1),
      onZoomOut: () => _mapController.move(center, zoom - 1),
      onMyLocation: () => _mapController.move(currentLocation, 15),
      showLayersButton: true,
      onLayers: () => _showLayerSelector(),
    ),
  ],
)
```

#### LocationInfoCard

```dart
class LocationInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? distance;
  final String? duration;
  final VoidCallback? onClose;
  final VoidCallback? onNavigate;
}
```

**Usage:**

```dart
LocationInfoCard(
  title: 'San Francisco Airport',
  subtitle: 'International Terminal',
  distance: '12.5 km',
  duration: '25 min',
  onClose: () => setState(() => _showCard = false),
  onNavigate: () => _launchNavigation(),
)
```

#### MapLoadingOverlay

```dart
class MapLoadingOverlay extends StatelessWidget {
  final String? message;
}
```

**Usage:**

```dart
if (isLoading)
  MapLoadingOverlay(message: 'Calculating route...')
```

---

### 6. MapUtils (`lib/widgets/maps/map_utils.dart`)

Utility functions for map operations.

```dart
class MapUtils {
  /// Calculate bounds from a list of points
  static LatLngBounds calculateBounds(List<LatLng> points);

  /// Fit map to show all markers with padding
  static void fitBounds(
    MapController controller,
    List<LatLng> points, {
    EdgeInsets padding = const EdgeInsets.all(50),
  });

  /// Calculate center point of multiple locations
  static LatLng calculateCenter(List<LatLng> points);

  /// Calculate distance between two points in meters
  static double calculateDistance(LatLng point1, LatLng point2);

  /// Calculate total route distance
  static double calculateRouteDistance(List<LatLng> points);

  /// Format distance for display
  static String formatDistance(double meters);

  /// Format duration for display
  static String formatDuration(double seconds);

  /// Check if point is within bounds
  static bool isPointInBounds(LatLng point, LatLngBounds bounds);

  /// Get zoom level to fit distance
  static double getZoomForDistance(double distanceInMeters);
}
```

**Usage:**

```dart
// Calculate and fit bounds
MapUtils.fitBounds(_mapController, allMarkerPoints);

// Calculate distance
double distance = MapUtils.calculateDistance(pickup, dropoff);
String formatted = MapUtils.formatDistance(distance); // "12.50 km"

// Get center of multiple points
LatLng center = MapUtils.calculateCenter(points);

// Format duration
String duration = MapUtils.formatDuration(1500); // "25 min"
```

---

## Services Reference

### OSRMService (`lib/widgets/maps/osrm_service.dart`)

Free routing service using OSRM (Open Source Routing Machine).

```dart
class OSRMService {
  /// Get route between multiple waypoints
  static Future<RouteResult?> getRoute(List<LatLng> waypoints);

  /// Get optimized route for multiple stops (TSP)
  static Future<RouteResult?> getOptimizedTrip(
    List<LatLng> waypoints, {
    LatLng? startPoint,
    LatLng? endPoint,
  });

  /// Calculate matrix of distances and durations
  static Future<DistanceMatrix?> getDistanceMatrix(
    List<LatLng> sources,
    List<LatLng> destinations,
  );
}

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  String get formattedDistance; // "12.50 km"
  String get formattedDuration; // "1 hr 25 min"
}

class DistanceMatrix {
  final List<List<double>> distances; // in meters
  final List<List<double>> durations; // in seconds
}
```

**Usage:**

```dart
// Simple route between two points
final route = await OSRMService.getRoute([
  LatLng(37.7749, -122.4194), // Start
  LatLng(37.7849, -122.4094), // End
]);

if (route != null) {
  setState(() {
    _routePoints = route.points;
    _info = 'Distance: ${route.formattedDistance}, Duration: ${route.formattedDuration}';
  });
}

// Multi-stop optimized route
final optimizedRoute = await OSRMService.getOptimizedTrip([
  LatLng(37.7749, -122.4194), // Pickup 1
  LatLng(37.7849, -122.4094), // Pickup 2
  LatLng(37.7649, -122.4294), // Pickup 3
  LatLng(37.7949, -122.3994), // Drop-off
]);

// Distance matrix
final matrix = await OSRMService.getDistanceMatrix(
  [pickup1, pickup2],     // Sources
  [dropoff1, dropoff2],   // Destinations
);
```

---

## Screens Reference

### 1. BasicMapScreen (`lib/screens/maps/basic_map_screen.dart`)

Simple map display with current location and tile style switching.

**Features:**
- Current location detection
- Multiple tile style options
- My location button
- Retina tile support

**Key Code:**

```dart
class _BasicMapScreenState extends State<BasicMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  int _selectedTileIndex = 0;

  Future<void> _getCurrentLocation() async {
    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move map
    _mapController.move(_currentLocation!, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(0, 0),
        initialZoom: 15.0,
      ),
      children: [
        OSMTileLayer(urlTemplate: MapConfig.osmTileOptions[_selectedTileIndex]['url']!),
        if (_currentLocation != null)
          MarkerLayer(
            markers: [MapMarkers.currentLocationMarker(_currentLocation!, context)],
          ),
      ],
    );
  }
}
```

---

### 2. LocationPickerScreen (`lib/screens/maps/location_picker_screen.dart`)

Interactive location selection with address lookup.

**Features:**
- Tap to select location
- Reverse geocoding (coordinates to address)
- Returns lat/lng and address

**Key Code:**

```dart
void _onMapTap(TapPosition tapPosition, LatLng location) {
  setState(() {
    _selectedLocation = location;
  });
  _getAddressFromLatLng(location);
}

Future<void> _getAddressFromLatLng(LatLng location) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    location.latitude,
    location.longitude,
  );

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks.first;
    setState(() {
      _address = '${place.street}, ${place.locality}, ${place.country}';
    });
  }
}

void _confirmLocation() {
  Navigator.pop(context, {
    'latitude': _selectedLocation.latitude,
    'longitude': _selectedLocation.longitude,
    'address': _address,
  });
}
```

**Usage in parent screen:**

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
);

if (result != null) {
  print('Lat: ${result['latitude']}');
  print('Lng: ${result['longitude']}');
  print('Address: ${result['address']}');
}
```

---

### 3. MultiMarkerMapScreen (`lib/screens/maps/multi_marker_map_screen.dart`)

Display multiple pickup/drop locations with polylines.

**Features:**
- Multiple pickup markers (green)
- Drop marker (red)
- Polyline connecting locations
- Fit bounds to show all markers
- Bottom sheet for marker info

**Key Code:**

```dart
// Define locations
final List<MapLocation> _pickupLocations = [
  MapLocation(
    latLng: const LatLng(37.7749, -122.4194),
    title: 'Pickup 1',
    subtitle: 'San Francisco',
    type: LocationType.pickup,
  ),
  // ... more pickups
];

final MapLocation _dropLocation = MapLocation(
  latLng: const LatLng(37.7949, -122.3994),
  title: 'Drop Point',
  subtitle: 'Destination',
  type: LocationType.drop,
);

// Build markers
MarkerLayer(
  markers: [
    ..._pickupLocations.map((loc) =>
      MapMarkers.pickupMarker(loc.latLng, context, onTap: () => _onMarkerTap(loc))
    ),
    MapMarkers.dropMarker(_dropLocation.latLng, context),
  ],
)

// Build polyline
PolylineLayer(
  polylines: [
    Polyline(
      points: [..._pickupLocations.map((loc) => loc.latLng), _dropLocation.latLng],
      color: theme.activeColor,
      strokeWidth: 3.0,
    ),
  ],
)

// Fit all markers in view
void _fitBounds() {
  final allPoints = [
    ..._pickupLocations.map((loc) => loc.latLng),
    _dropLocation.latLng,
  ];
  MapUtils.fitBounds(_mapController, allPoints);
}
```

---

### 4. RealtimeTrackingScreen (`lib/screens/maps/realtime_tracking_screen.dart`)

Live GPS tracking with route path and statistics.

**Features:**
- Real-time GPS streaming
- Route path drawing
- Speed, distance, points stats
- Start/stop tracking
- Auto-center on location

**Key Code:**

```dart
void _startTracking() {
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  );

  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    final newLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      if (_currentLocation != null) {
        // Calculate distance from last point
        final distance = Geolocator.distanceBetween(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          newLocation.latitude,
          newLocation.longitude,
        );
        _totalDistance += distance;
      }

      _currentLocation = newLocation;
      _routePath.add(newLocation);
      _currentSpeed = '${(position.speed * 3.6).toStringAsFixed(1)} km/h';
    });

    // Auto-center map
    _mapController.move(_currentLocation!, 16.0);
  });
}

void _stopTracking() {
  _positionStreamSubscription?.cancel();
  setState(() => _isTracking = false);
}
```

---

### 5. RoutePlanningScreen (`lib/screens/maps/route_planning_screen.dart`)

Route calculation with OSRM.

**Features:**
- Multiple waypoints support
- Tap to add waypoints
- Automatic route calculation
- Distance and duration display
- Route optimization

**Key Code:**

```dart
Future<void> _calculateRoute() async {
  if (_waypoints.length < 2) return;

  setState(() => _isLoading = true);

  // Use OSRMService
  final route = await OSRMService.getRoute(_waypoints);

  if (route != null) {
    setState(() {
      _routePoints = route.points;
      _routeInfo = 'Distance: ${route.formattedDistance}\n'
          'Duration: ${route.formattedDuration}';
    });
  }

  setState(() => _isLoading = false);
}

void _addWaypoint(LatLng point) {
  setState(() {
    _waypoints.add(point);
  });
  _calculateRoute();
}

// In MapOptions
onTap: (tapPosition, point) => _addWaypoint(point),
```

---

## Usage Examples

### Example 1: Simple Map with Current Location

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class SimpleMapExample extends StatefulWidget {
  @override
  State<SimpleMapExample> createState() => _SimpleMapExampleState();
}

class _SimpleMapExampleState extends State<SimpleMapExample> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation!,
                initialZoom: 15,
              ),
              children: [
                OSMTileLayer(),
                MarkerLayer(
                  markers: [
                    MapMarkers.currentLocationMarker(_currentLocation!, context),
                  ],
                ),
              ],
            ),
    );
  }
}
```

---

### Example 2: Ride Booking with Pickup and Drop

```dart
class RideBookingMap extends StatefulWidget {
  @override
  State<RideBookingMap> createState() => _RideBookingMapState();
}

class _RideBookingMapState extends State<RideBookingMap> {
  final MapController _mapController = MapController();
  LatLng? _pickup;
  LatLng? _dropoff;
  List<LatLng> _routePoints = [];
  RouteResult? _routeInfo;

  Future<void> _calculateRoute() async {
    if (_pickup == null || _dropoff == null) return;

    final route = await OSRMService.getRoute([_pickup!, _dropoff!]);
    if (route != null) {
      setState(() {
        _routePoints = route.points;
        _routeInfo = route;
      });
      MapUtils.fitBounds(_mapController, [_pickup!, _dropoff!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(37.7749, -122.4194),
            initialZoom: 13,
            onTap: (_, latLng) {
              setState(() {
                if (_pickup == null) {
                  _pickup = latLng;
                } else if (_dropoff == null) {
                  _dropoff = latLng;
                  _calculateRoute();
                }
              });
            },
          ),
          children: [
            OSMTileLayer(),
            if (_routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [RoutePolylines.activeRoute(_routePoints, context)],
              ),
            MarkerLayer(
              markers: [
                if (_pickup != null) MapMarkers.pickupMarker(_pickup!, context),
                if (_dropoff != null) MapMarkers.dropMarker(_dropoff!, context),
              ],
            ),
          ],
        ),
        if (_routeInfo != null)
          LocationInfoCard(
            title: 'Route Details',
            distance: _routeInfo!.formattedDistance,
            duration: _routeInfo!.formattedDuration,
            onNavigate: () => _startNavigation(),
          ),
      ],
    );
  }
}
```

---

### Example 3: Multi-Stop Route (School Pickup)

```dart
class SchoolPickupRoute extends StatefulWidget {
  @override
  State<SchoolPickupRoute> createState() => _SchoolPickupRouteState();
}

class _SchoolPickupRouteState extends State<SchoolPickupRoute> {
  final MapController _mapController = MapController();
  List<LatLng> _pickupPoints = []; // Children pickup locations
  LatLng? _schoolLocation;
  List<LatLng> _optimizedRoute = [];

  Future<void> _calculateOptimizedRoute() async {
    if (_pickupPoints.isEmpty || _schoolLocation == null) return;

    // Use OSRM trip optimization (TSP)
    final route = await OSRMService.getOptimizedTrip([
      ..._pickupPoints,
      _schoolLocation!,
    ]);

    if (route != null) {
      setState(() {
        _optimizedRoute = route.points;
      });
      MapUtils.fitBounds(_mapController, [..._pickupPoints, _schoolLocation!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _schoolLocation ?? LatLng(0, 0),
        initialZoom: 12,
      ),
      children: [
        OSMTileLayer(),
        if (_optimizedRoute.isNotEmpty)
          PolylineLayer(
            polylines: [
              RoutePolylines.activeRoute(_optimizedRoute, context),
            ],
          ),
        MarkerLayer(
          markers: [
            ..._pickupPoints.asMap().entries.map((e) => Marker(
              point: e.value,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${e.key + 1}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
            if (_schoolLocation != null)
              MapMarkers.customMarker(
                point: _schoolLocation!,
                icon: Icons.school,
                color: Colors.blue,
              ),
          ],
        ),
      ],
    );
  }
}
```

---

### Example 4: Driver Tracking (Parent View)

```dart
class DriverTrackingView extends StatefulWidget {
  final String driverId;
  final LatLng childPickupLocation;

  const DriverTrackingView({
    required this.driverId,
    required this.childPickupLocation,
  });

  @override
  State<DriverTrackingView> createState() => _DriverTrackingViewState();
}

class _DriverTrackingViewState extends State<DriverTrackingView> {
  final MapController _mapController = MapController();
  LatLng? _driverLocation;
  List<LatLng> _routeToPickup = [];
  RouteResult? _eta;
  StreamSubscription? _driverLocationStream;

  @override
  void initState() {
    super.initState();
    _listenToDriverLocation();
  }

  void _listenToDriverLocation() {
    // Connect to your backend (Firebase, Socket.io, etc.)
    _driverLocationStream = FirebaseFirestore.instance
        .collection('drivers')
        .doc(widget.driverId)
        .snapshots()
        .listen((snapshot) async {
      final data = snapshot.data();
      if (data != null) {
        final newLocation = LatLng(data['latitude'], data['longitude']);

        // Calculate route to pickup
        final route = await OSRMService.getRoute([
          newLocation,
          widget.childPickupLocation,
        ]);

        setState(() {
          _driverLocation = newLocation;
          if (route != null) {
            _routeToPickup = route.points;
            _eta = route;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _driverLocationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.childPickupLocation,
            initialZoom: 14,
          ),
          children: [
            OSMTileLayer(),
            if (_routeToPickup.isNotEmpty)
              PolylineLayer(
                polylines: [RoutePolylines.activeRoute(_routeToPickup, context)],
              ),
            MarkerLayer(
              markers: [
                MapMarkers.pickupMarker(widget.childPickupLocation, context),
                if (_driverLocation != null)
                  MapMarkers.driverMarker(_driverLocation!, context),
              ],
            ),
          ],
        ),
        if (_eta != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.directions_car, size: 32),
                        Text('Driver arriving in'),
                        Text(
                          _eta!.formattedDuration,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.straighten, size: 32),
                        Text('Distance'),
                        Text(
                          _eta!.formattedDistance,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
```

---

## Required Packages

```yaml
dependencies:
  # Map display
  flutter_map: ^6.1.0
  latlong2: ^0.9.1

  # Location services (existing)
  geolocator: ^13.0.2
  geocoding: ^3.0.0
  location: ^8.0.0

  # HTTP for OSRM
  http: ^1.2.0

  # Optional: Offline caching
  flutter_map_cache: ^1.5.1
```

---

## API Limits & Costs

| Service | Provider | Daily Limit | Cost |
| ------- | -------- | ----------- | ---- |
| Map Tiles | OpenStreetMap | Unlimited | FREE |
| Map Tiles | CartoDB | Unlimited | FREE |
| Routing | OSRM (Public) | ~2000 requests | FREE |
| Geocoding | Nominatim | ~1000 requests | FREE |
| GPS Location | Device | Unlimited | FREE |

**Total Monthly Cost: $0**

---

## Document Version

- **Version:** 1.0
- **Last Updated:** January 2026
- **Compatibility:** Flutter 3.x, flutter_map 6.x
