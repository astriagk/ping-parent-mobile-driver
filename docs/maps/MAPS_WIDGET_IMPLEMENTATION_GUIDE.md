# Maps Widget Implementation Guide

A complete end-to-end guide on how to implement the MapWidget in your Flutter app. This guide covers configuration, tile providers, components, and usage patterns.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture Overview](#architecture-overview)
3. [Required Dependencies](#required-dependencies)
4. [File Structure](#file-structure)
5. [Step-by-Step Implementation](#step-by-step-implementation)
   - [Step 1: Map Configuration](#step-1-map-configuration)
   - [Step 2: Location Service](#step-2-location-service)
   - [Step 3: Tile Layer Widget](#step-3-tile-layer-widget)
   - [Step 4: Map Markers](#step-4-map-markers)
   - [Step 5: Route Polylines](#step-5-route-polylines)
   - [Step 6: Map Controls](#step-6-map-controls)
   - [Step 7: Map Utilities](#step-7-map-utilities)
   - [Step 8: Main Map Widget](#step-8-main-map-widget)
   - [Step 9: Index Export File](#step-9-index-export-file)
6. [Usage Examples](#usage-examples)
7. [Tile Provider Options](#tile-provider-options)
8. [Best Practices](#best-practices)

---

## Quick Start

### Minimal Usage

```dart
import 'package:your_app/widgets/maps/index.dart';
import 'package:your_app/common/maps/map_config.dart';

// Basic map display
MapWidget(
  config: MapProvidersRegistry.getConfig(),
  tileLayerBuilder: (urlTemplate) => MapTileLayer(urlTemplate: urlTemplate),
)
```

### With Markers and Route

```dart
MapWidget(
  config: MapProvidersRegistry.getConfig(),
  tileLayerBuilder: (urlTemplate) => MapTileLayer(urlTemplate: urlTemplate),
  markers: () => [
    MapMarkers.pickupMarker(pickupLocation, context),
    MapMarkers.dropOffMarker(dropLocation, context),
  ],
  polylineBuilder: (context) => [
    RoutePolylines.activeRoute(routePoints, context),
  ],
  showControls: true,
)
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         YOUR FLUTTER APP                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────┐    ┌──────────────────┐    ┌───────────────────┐  │
│  │  MapConfig      │    │  LocationService │    │  flutter_map      │  │
│  │  (Tile URLs,    │    │  (GPS, Stream)   │    │  (Map Display)    │  │
│  │  API Keys)      │    └──────────────────┘    └───────────────────┘  │
│  └─────────────────┘                                                    │
│          │                       │                       │              │
│          ▼                       ▼                       ▼              │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                        MapWidget                                 │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────────────────┐  │   │
│  │  │ TileLayer   │  │ MarkerLayer  │  │ PolylineLayer          │  │   │
│  │  │ (Map Tiles) │  │ (Icons)      │  │ (Routes)               │  │   │
│  │  └─────────────┘  └──────────────┘  └────────────────────────┘  │   │
│  │                                                                  │   │
│  │  ┌─────────────────────────────────────────────────────────────┐│   │
│  │  │              MapControls (Zoom, Location, Layers)           ││   │
│  │  └─────────────────────────────────────────────────────────────┘│   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Required Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  # Map Display
  flutter_map: ^6.1.0 # Core map widget
  latlong2: ^0.9.1 # Coordinate handling

  # Location Services
  geolocator: ^13.0.2 # GPS location
  geocoding: ^3.0.0 # Address lookup (optional)

  # Optional
  flutter_svg: ^2.0.9 # SVG marker icons
```

Run:

```bash
flutter pub get
```

---

## File Structure

Create this folder structure in your app:

```
lib/
├── common/
│   └── maps/
│       └── map_config.dart           # Configuration & tile URLs
├── helper/
│   └── location_service.dart         # GPS location handling
└── widgets/
    └── maps/
        ├── index.dart                # Export all widgets
        ├── map_widget.dart           # Main map widget
        ├── map_markers.dart          # Marker builders
        ├── route_polylines.dart      # Polyline builders
        ├── map_controls.dart         # Zoom/location controls
        ├── map_utils.dart            # Utility functions
        └── layout/
            └── map_tile_layer.dart   # Tile layer widget
```

---

## Step-by-Step Implementation

### Step 1: Map Configuration

Create `lib/common/maps/map_config.dart`:

```dart
import 'package:your_app/widgets/maps/map_widget.dart';

/// Map Configuration with multiple tile providers
class MapConfig implements MapProviderConfig {
  // API Key (for paid providers like TomTom)
  // Leave empty for free providers like OpenStreetMap
  static const String apiKey = 'YOUR_API_KEY_HERE';

  // Selected tile provider index (0 = first option)
  static const int _selectedTileIndex = 0;

  // Available tile options with their associated APIs
  static const List<Map<String, dynamic>> _allTileOptions = [
    {
      'name': 'CartoDB Voyager',
      'url': 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      'description': 'Colorful, detailed map style',
      'routingBaseUrl': 'https://router.project-osrm.org/route/v1',
      'geocodingBaseUrl': 'https://nominatim.openstreetmap.org/search',
      'reverseGeocodingBaseUrl': 'https://nominatim.openstreetmap.org/reverse',
    },
    {
      'name': 'OpenStreetMap',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      'description': 'Standard OpenStreetMap tiles',
      'routingBaseUrl': 'https://router.project-osrm.org/route/v1',
      'geocodingBaseUrl': 'https://nominatim.openstreetmap.org/search',
      'reverseGeocodingBaseUrl': 'https://nominatim.openstreetmap.org/reverse',
    },
    {
      'name': 'CartoDB Dark',
      'url': 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
      'description': 'Dark theme map style',
      'routingBaseUrl': 'https://router.project-osrm.org/route/v1',
      'geocodingBaseUrl': 'https://nominatim.openstreetmap.org/search',
      'reverseGeocodingBaseUrl': 'https://nominatim.openstreetmap.org/reverse',
    },
    // Add TomTom if you have API key:
    // {
    //   'name': 'TomTom Basic',
    //   'url': 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey',
    //   'description': 'Premium TomTom tiles',
    //   'routingBaseUrl': 'https://api.tomtom.com/routing/1',
    //   'geocodingBaseUrl': 'https://api.tomtom.com/search/2',
    //   'reverseGeocodingBaseUrl': 'https://api.tomtom.com/search/2/reverse',
    // },
  ];

  // Zoom constraints
  static const double _defaultZoom = 15.0;
  static const double _minZoom = 10.0;
  static const double _maxZoom = 18.0;

  // User agent for tile requests (use your app package name)
  static const String userAgentPackageName = 'com.yourcompany.yourapp';

  @override
  String get appBarTitle => 'Map';

  @override
  double get defaultZoom => _defaultZoom;

  @override
  int get selectedTileIndex => _selectedTileIndex;

  @override
  double get minZoom => _minZoom;

  @override
  double get maxZoom => _maxZoom;

  @override
  List<Map<String, String>> get allTileOptions => _allTileOptions
      .map((option) => {
            'name': option['name'] as String,
            'url': option['url'] as String,
            'description': option['description'] as String,
          })
      .toList();

  /// Get routing API base URL based on selected tile index
  String get routingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['routingBaseUrl'] as String;

  /// Get geocoding API base URL based on selected tile index
  String get geocodingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['geocodingBaseUrl'] as String;

  /// Get reverse geocoding API base URL based on selected tile index
  String get reverseGeocodingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['reverseGeocodingBaseUrl'] as String;
}

/// Registry for accessing map configuration
class MapProvidersRegistry {
  /// Get config instance
  static MapProviderConfig getConfig() {
    return MapConfig();
  }

  /// Get tile options for UI selection
  static List<Map<String, String>> getTileOptions() {
    return MapConfig().allTileOptions;
  }
}

/// Model for map provider information
class MapProvider {
  final String id;
  final String name;
  final String description;
  final int tileCount;

  const MapProvider({
    required this.id,
    required this.name,
    required this.description,
    required this.tileCount,
  });
}
```

---

### Step 2: Location Service

Create `lib/helper/location_service.dart`:

```dart
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service to handle user location operations
class LocationService {
  /// Cache last known location
  static LatLng? _lastKnownLocation;

  /// Get current user location
  /// Returns LatLng if successful, null if permission denied or error
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _lastKnownLocation;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _lastKnownLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _lastKnownLocation;
      }

      // Get current position with timeout
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () async {
          final pos = await Geolocator.getLastKnownPosition();
          if (pos != null) return pos;
          throw Exception('No location available');
        },
      );

      _lastKnownLocation = LatLng(position.latitude, position.longitude);
      return _lastKnownLocation;
    } catch (e) {
      return _lastKnownLocation;
    }
  }

  /// Get continuous location stream for real-time tracking
  static Stream<Position> getLocationStream({
    int distanceFilter = 15,
    Duration? timeLimit,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
        timeLimit: timeLimit,
      ),
    );
  }

  /// Request location permission
  static Future<bool> requestPermission({bool allowAlways = false}) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (allowAlways && permission == LocationPermission.whileInUse) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Open app settings
  static Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
```

---

### Step 3: Tile Layer Widget

Create `lib/widgets/maps/layout/map_tile_layer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:your_app/common/maps/map_config.dart';

/// Reusable Map TileLayer widget
class MapTileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;

  const MapTileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = MapConfig();
    final url = urlTemplate ??
        config.allTileOptions[config.selectedTileIndex]['url']!;

    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: MapConfig.userAgentPackageName,
      retinaMode: RetinaMode.isHighDensity(context),
      maxZoom: config.maxZoom,
    );
  }
}

/// Adaptive tile layer that switches based on theme (light/dark)
class MapAdaptiveTileLayer extends StatelessWidget {
  final String? lightTileUrl;
  final String? darkTileUrl;

  const MapAdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = MapConfig();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use dark tile (index 2) for dark theme, or selected tile for light theme
    final url = isDark
        ? (darkTileUrl ?? config.allTileOptions[2]['url']!) // Dark theme tile
        : (lightTileUrl ?? config.allTileOptions[config.selectedTileIndex]['url']!);

    return MapTileLayer(urlTemplate: url);
  }
}
```

---

### Step 4: Map Markers

Create `lib/widgets/maps/map_markers.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Reusable marker builder for all map types
class MapMarkers {
  /// Generic marker with icon and background
  static Marker _buildMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    double size = 56,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: size * 0.5),
        ),
      ),
    );
  }

  /// Current location marker (blue dot)
  static Marker currentLocationMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            // Inner dot
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pickup location marker (green)
  static Marker pickupMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      icon: Icons.location_on,
      color: Colors.green.shade600,
      onTap: onTap,
    );
  }

  /// Drop-off/destination marker (red)
  static Marker dropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      icon: Icons.flag,
      color: Colors.red.shade600,
      onTap: onTap,
    );
  }

  /// Waypoint/student marker (orange)
  static Marker waypointMarker(
    LatLng point,
    String label,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      icon: Icons.person_pin_circle,
      color: Colors.orange.shade600,
      onTap: onTap,
    );
  }

  /// Driver/Vehicle marker (primary color)
  static Marker driverMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      icon: Icons.directions_car,
      color: Theme.of(context).primaryColor,
      onTap: onTap,
    );
  }

  /// Custom marker with any icon
  static Marker customMarker({
    required LatLng point,
    required IconData icon,
    required Color color,
    double size = 56,
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      icon: icon,
      color: color,
      size: size,
      onTap: onTap,
    );
  }
}
```

---

### Step 5: Route Polylines

Create `lib/widgets/maps/route_polylines.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Reusable polyline builder for routes
class RoutePolylines {
  /// Active route polyline (primary color)
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: Theme.of(context).primaryColor,
      strokeWidth: 4.0,
      borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
      borderStrokeWidth: 1.0,
    );
  }

  /// Alternative route (gray, semi-transparent)
  static Polyline alternativeRoute(List<LatLng> points) {
    return Polyline(
      points: points,
      color: Colors.grey.shade400,
      strokeWidth: 3.0,
    );
  }

  /// Walking route (dotted blue line)
  static Polyline walkingRoute(List<LatLng> points) {
    return Polyline(
      points: points,
      color: Colors.blue.shade400,
      strokeWidth: 3.0,
      isDotted: true,
    );
  }

  /// Custom route with any color
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 4.0,
    bool isDotted = false,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
      isDotted: isDotted,
    );
  }
}
```

---

### Step 6: Map Controls

Create `lib/widgets/maps/map_controls.dart`:

```dart
import 'package:flutter/material.dart';

/// Map controls widget for zoom and layer controls
class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final List<Map<String, String>>? tileOptions;
  final Function(int)? onTileSelected;
  final bool showLayersButton;
  final Alignment alignment;

  const MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
    this.tileOptions,
    this.onTileSelected,
    this.showLayersButton = true,
    this.alignment = Alignment.bottomRight,
  });

  Widget _buildControlButton(
    BuildContext context,
    IconData icon,
    VoidCallback? onPressed, {
    Color? iconColor,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zoom In
            _buildControlButton(context, Icons.add, onZoomIn),
            const SizedBox(height: 8),

            // Zoom Out
            _buildControlButton(context, Icons.remove, onZoomOut),
            const SizedBox(height: 8),

            // My Location
            _buildControlButton(
              context,
              Icons.my_location,
              onMyLocation,
              iconColor: Colors.blue,
            ),

            // Layer Switcher
            if (showLayersButton && tileOptions != null) ...[
              const SizedBox(height: 8),
              PopupMenuButton<int>(
                onSelected: onTileSelected,
                child: _buildControlButton(context, Icons.layers, null),
                itemBuilder: (context) => List.generate(
                  tileOptions!.length,
                  (index) => PopupMenuItem<int>(
                    value: index,
                    child: Text(tileOptions![index]['name']!),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

### Step 7: Map Utilities

Create `lib/widgets/maps/map_utils.dart`:

```dart
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

/// Utility functions for map operations
class MapUtils {
  static const Distance _distance = Distance();

  /// Calculate distance between two points in kilometers
  static double calculateDistance(LatLng point1, LatLng point2) {
    return _distance.as(LengthUnit.Kilometer, point1, point2);
  }

  /// Format distance for display
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Format duration (minutes) for display
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins == 0 ? '$hours h' : '$hours h $mins min';
  }

  /// Get center point of multiple coordinates
  static LatLng getCenterPoint(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    if (points.length == 1) return points[0];

    double lat = 0, lon = 0;
    for (final point in points) {
      lat += point.latitude;
      lon += point.longitude;
    }
    return LatLng(lat / points.length, lon / points.length);
  }

  /// Get appropriate zoom level for distance
  static double getZoomForDistance(double distanceKm) {
    if (distanceKm > 300) return 5;
    if (distanceKm > 100) return 7;
    if (distanceKm > 50) return 9;
    if (distanceKm > 20) return 11;
    if (distanceKm > 10) return 12;
    if (distanceKm > 5) return 13;
    if (distanceKm > 2) return 14;
    return 15;
  }

  /// Validate coordinates are within valid range
  static bool isValidCoordinate(LatLng point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  /// Get bearing between two points (0-360 degrees)
  static double getBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * math.pi / 180;
    final lat2 = to.latitude * math.pi / 180;
    final dLon = (to.longitude - from.longitude) * math.pi / 180;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }
}
```

---

### Step 8: Main Map Widget

Create `lib/widgets/maps/map_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:your_app/helper/location_service.dart';
import 'map_markers.dart';
import 'map_controls.dart';

/// Configuration interface for map providers
abstract class MapProviderConfig {
  String get appBarTitle;
  double get defaultZoom;
  double get minZoom;
  double get maxZoom;
  int get selectedTileIndex;
  List<Map<String, String>> get allTileOptions;
}

/// Main Map Widget with full functionality
class MapWidget extends StatefulWidget {
  /// Map configuration (tile URLs, zoom levels)
  final MapProviderConfig config;

  /// Builder for tile layer - receives URL template
  final Widget Function(String urlTemplate) tileLayerBuilder;

  /// Function that returns list of markers
  final List<Marker> Function()? markers;

  /// Function that returns list of polylines
  final List<Polyline> Function()? polylines;

  /// Builder for polylines with context
  final List<Polyline> Function(BuildContext context)? polylineBuilder;

  /// Custom current location marker builder
  final Marker Function(LatLng point, BuildContext context)?
      currentLocationMarkerBuilder;

  /// Callback when map is tapped
  final Function(TapPosition, LatLng)? onTap;

  /// Callback when map position changes
  final PositionCallback? onPositionChanged;

  /// Show zoom/location controls
  final bool showControls;

  /// Show current location marker
  final bool showCurrentLocation;

  const MapWidget({
    super.key,
    required this.config,
    required this.tileLayerBuilder,
    this.markers,
    this.polylines,
    this.polylineBuilder,
    this.currentLocationMarkerBuilder,
    this.onTap,
    this.onPositionChanged,
    this.showControls = false,
    this.showCurrentLocation = true,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;
  List<Marker> _markers = [];
  late int _selectedTileIndex;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _selectedTileIndex = widget.config.selectedTileIndex;
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final location = await LocationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _currentLocation = location;
        _updateMarkers();
      });

      // Wait for map controller to be ready
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _mapController.move(location, widget.config.defaultZoom);
      }
    }
  }

  void _updateMarkers() {
    _markers = [
      // Current location marker
      if (widget.showCurrentLocation && _currentLocation != null)
        widget.currentLocationMarkerBuilder?.call(_currentLocation!, context) ??
            MapMarkers.currentLocationMarker(_currentLocation!, context),

      // Custom markers
      ...?widget.markers?.call(),
    ];
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markers != widget.markers ||
        oldWidget.currentLocationMarkerBuilder !=
            widget.currentLocationMarkerBuilder) {
      if (_currentLocation != null) {
        setState(_updateMarkers);
      }
    }
  }

  void _changeTileLayer(int index) {
    setState(() => _selectedTileIndex = index);
  }

  void _zoomIn() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom + 1,
    );
  }

  void _zoomOut() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while getting location
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation!,
            initialZoom: widget.config.defaultZoom,
            minZoom: widget.config.minZoom,
            maxZoom: widget.config.maxZoom,
            onTap: widget.onTap,
            onPositionChanged: widget.onPositionChanged,
          ),
          children: [
            // Tile Layer
            widget.tileLayerBuilder(
              widget.config.allTileOptions[_selectedTileIndex]['url']!,
            ),

            // Polylines
            if ((widget.polylineBuilder?.call(context).isNotEmpty ?? false) ||
                (widget.polylines?.call().isNotEmpty ?? false))
              PolylineLayer(
                polylines: widget.polylineBuilder?.call(context) ??
                    widget.polylines?.call() ??
                    [],
              ),

            // Markers
            if (_markers.isNotEmpty) MarkerLayer(markers: _markers),
          ],
        ),

        // Controls
        if (widget.showControls)
          MapControls(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onMyLocation: () {
              _mapController.move(
                _currentLocation!,
                widget.config.defaultZoom,
              );
            },
            tileOptions: widget.config.allTileOptions,
            onTileSelected: _changeTileLayer,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
```

---

### Step 9: Index Export File

Create `lib/widgets/maps/index.dart`:

```dart
// Core widgets
export 'map_widget.dart';
export 'layout/map_tile_layer.dart';

// Markers
export 'map_markers.dart';

// Polylines
export 'route_polylines.dart';

// Controls
export 'map_controls.dart';

// Utilities
export 'map_utils.dart';
```

---

## Usage Examples

### Example 1: Basic Map Screen

```dart
import 'package:flutter/material.dart';
import 'package:your_app/common/maps/map_config.dart';
import 'package:your_app/widgets/maps/index.dart';

class BasicMapScreen extends StatelessWidget {
  const BasicMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: MapWidget(
        config: MapProvidersRegistry.getConfig(),
        tileLayerBuilder: (urlTemplate) => MapTileLayer(
          urlTemplate: urlTemplate,
        ),
        showControls: true,
      ),
    );
  }
}
```

### Example 2: Map with Route and Markers

```dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:your_app/common/maps/map_config.dart';
import 'package:your_app/widgets/maps/index.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final LatLng pickupLocation = const LatLng(37.7749, -122.4194);
  final LatLng dropLocation = const LatLng(37.7849, -122.4094);

  // Route points (from routing API)
  List<LatLng> routePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route')),
      body: MapWidget(
        config: MapProvidersRegistry.getConfig(),
        tileLayerBuilder: (urlTemplate) => MapTileLayer(
          urlTemplate: urlTemplate,
        ),
        showCurrentLocation: true,
        showControls: true,
        markers: () => [
          MapMarkers.pickupMarker(pickupLocation, context),
          MapMarkers.dropOffMarker(dropLocation, context),
        ],
        polylineBuilder: (context) => [
          if (routePoints.isNotEmpty)
            RoutePolylines.activeRoute(routePoints, context),
        ],
        onTap: (tapPosition, latLng) {
          print('Tapped at: $latLng');
        },
      ),
    );
  }
}
```

### Example 3: Driver Tracking Screen

```dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:your_app/common/maps/map_config.dart';
import 'package:your_app/widgets/maps/index.dart';
import 'package:your_app/helper/location_service.dart';
import 'package:geolocator/geolocator.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  LatLng? driverLocation;
  final List<LatLng> waypoints = [
    const LatLng(37.7749, -122.4194),
    const LatLng(37.7799, -122.4144),
    const LatLng(37.7849, -122.4094),
  ];

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() {
    LocationService.getLocationStream(distanceFilter: 10).listen((position) {
      if (mounted) {
        setState(() {
          driverLocation = LatLng(position.latitude, position.longitude);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: MapWidget(
        config: MapProvidersRegistry.getConfig(),
        tileLayerBuilder: (urlTemplate) => MapTileLayer(
          urlTemplate: urlTemplate,
        ),
        showControls: true,
        // Use driver marker instead of default current location
        currentLocationMarkerBuilder: (point, ctx) =>
            MapMarkers.driverMarker(point, ctx),
        markers: () => [
          // Waypoint markers
          for (int i = 0; i < waypoints.length; i++)
            MapMarkers.waypointMarker(
              waypoints[i],
              'Stop ${i + 1}',
              context,
            ),
        ],
      ),
    );
  }
}
```

### Example 4: Location Picker

```dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:your_app/common/maps/map_config.dart';
import 'package:your_app/widgets/maps/index.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (selectedLocation != null)
            TextButton(
              onPressed: () => Navigator.pop(context, selectedLocation),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: MapWidget(
        config: MapProvidersRegistry.getConfig(),
        tileLayerBuilder: (urlTemplate) => MapTileLayer(
          urlTemplate: urlTemplate,
        ),
        showControls: true,
        showCurrentLocation: false,
        markers: () => [
          if (selectedLocation != null)
            MapMarkers.pickupMarker(selectedLocation!, context),
        ],
        onTap: (tapPosition, latLng) {
          setState(() => selectedLocation = latLng);
        },
      ),
    );
  }
}
```

---

## Tile Provider Options

### Free Providers (No API Key Required)

| Provider            | URL Template                                                          | Best For              |
| ------------------- | --------------------------------------------------------------------- | --------------------- |
| CartoDB Voyager     | `https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png` | General use, colorful |
| OpenStreetMap       | `https://tile.openstreetmap.org/{z}/{x}/{y}.png`                      | Standard, reliable    |
| CartoDB Positron    | `https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png`           | Light theme           |
| CartoDB Dark Matter | `https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png`            | Dark theme            |
| OpenTopoMap         | `https://a.tile.opentopomap.org/{z}/{x}/{y}.png`                      | Terrain/hiking        |

### Paid Providers (API Key Required)

| Provider | URL Template                                                                                                        | Free Tier  |
| -------- | ------------------------------------------------------------------------------------------------------------------- | ---------- |
| TomTom   | `https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key={apiKey}`                                         | 2,500/day  |
| Mapbox   | `https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={apiKey}`                       | 100K/month |
| HERE     | `https://{1-4}.base.maps.ls.hereapi.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?apiKey={apiKey}` | 250K/month |

---

## Best Practices

### 1. Configuration Management

```dart
// ✅ Good: Centralized configuration
class MapConfig {
  static const String apiKey = String.fromEnvironment('MAP_API_KEY');
}

// ❌ Bad: Hardcoded API keys in widgets
TileLayer(urlTemplate: 'https://api.com?key=abc123');
```

### 2. Error Handling

```dart
// ✅ Good: Handle location errors gracefully
Future<LatLng?> getLocation() async {
  try {
    return await LocationService.getCurrentLocation();
  } catch (e) {
    // Show user-friendly message
    return null;
  }
}
```

### 3. Performance

```dart
// ✅ Good: Use const constructors
const MapTileLayer();

// ✅ Good: Cache tile layers
final tileLayer = MapTileLayer(urlTemplate: config.tileUrl);

// ❌ Bad: Rebuild widgets unnecessarily
Widget build(context) {
  return MapTileLayer(urlTemplate: getTileUrl()); // Called every rebuild
}
```

### 4. Memory Management

```dart
@override
void dispose() {
  _mapController.dispose(); // Always dispose controllers
  _locationSubscription?.cancel(); // Cancel streams
  super.dispose();
}
```

### 5. Marker Updates

```dart
// ✅ Good: Update markers efficiently
void _updateMarkers() {
  setState(() {
    _markers = buildMarkers();
  });
}

// ❌ Bad: Rebuild entire widget tree
void _addMarker(LatLng point) {
  setState(() {}); // Unnecessary full rebuild
}
```

---

## Troubleshooting

### Map Not Loading

1. Check internet connection
2. Verify tile URL is correct
3. Check if API key is valid (for paid providers)
4. Look for console errors

### Location Not Working

1. Check location permissions in app settings
2. Verify `geolocator` configuration in AndroidManifest.xml / Info.plist
3. Test on real device (emulators may have GPS issues)

### Markers Not Showing

1. Ensure markers list is not empty
2. Check marker coordinates are valid
3. Verify markers are within visible map bounds

---

## Summary

The MapWidget implementation follows a modular architecture:

1. **MapConfig** - Central configuration for tile URLs and settings
2. **LocationService** - GPS location handling
3. **MapTileLayer** - Renders map tiles
4. **MapMarkers** - Builds marker widgets
5. **RoutePolylines** - Builds route lines
6. **MapControls** - Zoom and layer controls
7. **MapWidget** - Main widget combining all components

This architecture allows you to:

- Switch tile providers easily
- Reuse components across screens
- Maintain consistent styling
- Add new features without modifying core code

Copy this entire structure to your new app and adjust the package imports and theme colors as needed.
