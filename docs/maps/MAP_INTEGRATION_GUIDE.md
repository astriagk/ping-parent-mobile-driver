# Map Integration Guide

This guide explains how to integrate new map providers into the Ping Parent app. The architecture follows a modular pattern that makes it easy to add new map services.

## Current Map Implementations

| Provider | Prefix | API Key Required | Features |
|----------|--------|------------------|----------|
| OpenFreeMap | `OFM` | No | Basic tiles, OSRM routing, Nominatim geocoding |
| TomTom | `TT` | Yes | Premium tiles, Traffic-aware routing, Search API |

## Architecture Overview

Each map provider follows the same file structure:

```
lib/
├── common/
│   └── {provider}_config.dart          # Configuration & API keys
├── widgets/
│   └── {provider}_maps/
│       ├── index.dart                   # Export all widgets
│       ├── {prefix}_map_widget.dart     # Main map widget
│       ├── {prefix}_markers.dart        # Marker builders
│       ├── {prefix}_polylines.dart      # Polyline builders
│       ├── {prefix}_overlays.dart       # UI overlay widgets
│       ├── {prefix}_utils.dart          # Utility functions
│       ├── {prefix}_routing_service.dart # Routing API
│       └── layout/
│           └── {prefix}_tile_layer.dart # Tile layer widget
└── screens/
    └── {provider}_maps/
        ├── {prefix}_basic_map_screen.dart      # Basic map example
        └── {prefix}_location_picker_screen.dart # Location picker
```

## Step-by-Step Integration Guide

### Step 1: Create Configuration File

Create `lib/common/{provider}_config.dart`:

```dart
/// {Provider} Maps Configuration
class {Provider}Config {
  // API Key (if required)
  static const String apiKey = 'YOUR_API_KEY';

  // Selected tile index
  static const int selectedTileIndex = 0;

  // Available tile options
  static const List<Map<String, String>> allTileOptions = [
    {
      'name': 'Style Name',
      'url': 'https://tiles.example.com/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Description of this style',
    },
    // Add more tile options...
  ];

  // Get selected tile URL
  static String get selectedTileUrl => allTileOptions[selectedTileIndex]['url']!;

  // Get selected tile name
  static String get selectedTileName => allTileOptions[selectedTileIndex]['name']!;

  // User agent for tile requests
  static const String userAgentPackageName = 'com.pingparent.app';

  // Default map settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 19.0;

  // Default location
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;

  // API base URLs (if applicable)
  static const String routingBaseUrl = 'https://api.example.com/routing';
  static const String searchBaseUrl = 'https://api.example.com/search';
}
```

### Step 2: Create Tile Layer Widget

Create `lib/widgets/{provider}_maps/layout/{prefix}_tile_layer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../common/{provider}_config.dart';

/// {Provider} TileLayer widget
class {Prefix}TileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;

  const {Prefix}TileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = urlTemplate ?? {Provider}Config.selectedTileUrl;

    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: {Provider}Config.userAgentPackageName,
      maxZoom: {Provider}Config.maxZoom,
    );
  }
}

/// Adaptive tile layer (switches based on theme)
class {Prefix}AdaptiveTileLayer extends StatelessWidget {
  final String? lightTileUrl;
  final String? darkTileUrl;

  const {Prefix}AdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final url = isDark
        ? (darkTileUrl ?? {Provider}Config.allTileOptions[1]['url']!)
        : (lightTileUrl ?? {Provider}Config.selectedTileUrl);

    return {Prefix}TileLayer(urlTemplate: url);
  }
}
```

### Step 3: Create Map Widget

Create `lib/widgets/{provider}_maps/{prefix}_map_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../common/{provider}_config.dart';
import 'layout/{prefix}_tile_layer.dart';

class {Prefix}MapWidget extends StatelessWidget {
  final MapController? controller;
  final LatLng initialCenter;
  final double initialZoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final Function(TapPosition, LatLng)? onTap;
  // ... other properties

  const {Prefix}MapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = {Provider}Config.defaultZoom,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        onTap: onTap,
      ),
      children: [
        const {Prefix}TileLayer(),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }
}
```

### Step 4: Create Markers

Create `lib/widgets/{provider}_maps/{prefix}_markers.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class {Prefix}Markers {
  static const double defaultSize = 40.0;

  static Marker pickupMarker(LatLng point, {VoidCallback? onTap}) {
    return Marker(
      point: point,
      width: defaultSize,
      height: defaultSize,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(Icons.location_on, color: Colors.green.shade700, size: defaultSize),
      ),
    );
  }

  static Marker dropMarker(LatLng point, {VoidCallback? onTap}) {
    return Marker(
      point: point,
      width: defaultSize,
      height: defaultSize,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(Icons.flag, color: Colors.red.shade700, size: defaultSize),
      ),
    );
  }

  static Marker currentLocationMarker(LatLng point) {
    return Marker(
      point: point,
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withValues(alpha: 0.2),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ],
      ),
    );
  }

  // Add more marker types as needed...
}
```

### Step 5: Create Polylines

Create `lib/widgets/{provider}_maps/{prefix}_polylines.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class {Prefix}Polylines {
  static const double defaultStrokeWidth = 5.0;

  static Polyline activeRoute(List<LatLng> points) {
    return Polyline(
      points: points,
      strokeWidth: defaultStrokeWidth,
      color: Colors.blue.shade600,
    );
  }

  static Polyline alternativeRoute(List<LatLng> points) {
    return Polyline(
      points: points,
      strokeWidth: defaultStrokeWidth,
      color: Colors.grey.shade400,
    );
  }

  // Add more polyline types...
}

class {Prefix}Circles {
  static CircleMarker safeZone(LatLng center, {required double radiusMeters}) {
    return CircleMarker(
      point: center,
      radius: radiusMeters,
      useRadiusInMeter: true,
      color: Colors.green.withValues(alpha: 0.2),
      borderColor: Colors.green.shade700,
      borderStrokeWidth: 2.0,
    );
  }
}
```

### Step 6: Create Overlays

Create `lib/widgets/{provider}_maps/{prefix}_overlays.dart`:

```dart
import 'package:flutter/material.dart';

class {Prefix}MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;

  const {Prefix}MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          _buildButton(Icons.add, onZoomIn),
          const SizedBox(height: 8),
          _buildButton(Icons.remove, onZoomOut),
          const SizedBox(height: 8),
          _buildButton(Icons.my_location, onMyLocation, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback? onPressed, {Color? color}) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color ?? Colors.grey.shade800),
        ),
      ),
    );
  }
}
```

### Step 7: Create Utilities

Create `lib/widgets/{provider}_maps/{prefix}_utils.dart`:

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class {Prefix}Utils {
  static const Distance _distance = Distance();

  static double calculateDistance(LatLng start, LatLng end) {
    return _distance.as(LengthUnit.Meter, start, end);
  }

  static String formatDistance(double meters) {
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  static String formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = (minutes / 60).floor();
    return '$hours hr ${minutes % 60} min';
  }

  static LatLngBounds? calculateBounds(List<LatLng> points) {
    if (points.isEmpty) return null;
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  static void fitBounds(MapController controller, List<LatLng> points) {
    final bounds = calculateBounds(points);
    if (bounds != null) {
      controller.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ));
    }
  }
}
```

### Step 8: Create Routing Service (if API available)

Create `lib/widgets/{provider}_maps/{prefix}_routing_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../common/{provider}_config.dart';

class {Prefix}RoutingService {
  static Future<{Prefix}RouteResult?> getRoute(
    List<LatLng> waypoints, {
    {Prefix}RouteProfile profile = {Prefix}RouteProfile.driving,
  }) async {
    if (waypoints.length < 2) return null;

    try {
      // Build API URL based on provider's API format
      final url = Uri.parse('{Provider}Config.routingBaseUrl/...');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Parse response and return route result
        return {Prefix}RouteResult(
          points: [...],
          distanceMeters: ...,
          durationSeconds: ...,
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }
}

class {Prefix}RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  {Prefix}RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get formattedDistance {
    if (distanceMeters < 1000) return '${distanceMeters.toStringAsFixed(0)} m';
    return '${(distanceMeters / 1000).toStringAsFixed(2)} km';
  }

  String get formattedDuration {
    final minutes = (durationSeconds / 60).round();
    if (minutes < 60) return '$minutes min';
    return '${(minutes / 60).floor()} hr ${minutes % 60} min';
  }
}

enum {Prefix}RouteProfile {
  driving('driving'),
  walking('walking'),
  cycling('cycling');

  final String value;
  const {Prefix}RouteProfile(this.value);
}
```

### Step 9: Create Index Export File

Create `lib/widgets/{provider}_maps/index.dart`:

```dart
// Core widgets
export '{prefix}_map_widget.dart';
export 'layout/{prefix}_tile_layer.dart';

// Markers
export '{prefix}_markers.dart';

// Polylines and shapes
export '{prefix}_polylines.dart';

// UI overlays
export '{prefix}_overlays.dart';

// Utilities
export '{prefix}_utils.dart';

// Routing service
export '{prefix}_routing_service.dart';
```

### Step 10: Create Example Screens

Create basic map and location picker screens in `lib/screens/{provider}_maps/`.

## Common Map Tile Providers

### Free (No API Key Required)
- **OpenStreetMap**: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **CartoDB Positron**: `https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png`
- **CartoDB Dark Matter**: `https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png`
- **OpenTopoMap**: `https://a.tile.opentopomap.org/{z}/{x}/{y}.png`

### Paid (API Key Required)
- **TomTom**: `https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key={apiKey}`
- **Mapbox**: `https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={apiKey}`
- **Google Maps**: Requires Google Maps Flutter plugin
- **HERE Maps**: `https://{1-4}.base.maps.ls.hereapi.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?apiKey={apiKey}`

## Routing APIs

| Provider | Free Tier | Traffic | Turn-by-turn |
|----------|-----------|---------|--------------|
| OSRM | Unlimited | No | Yes |
| TomTom | 2,500/day | Yes | Yes |
| Mapbox | 100,000/month | Yes | Yes |
| HERE | 250,000/month | Yes | Yes |
| Google | $200 credit | Yes | Yes |

## Best Practices

1. **API Key Security**: Never commit API keys to version control. Use environment variables or secure storage.

2. **Caching**: Implement tile caching for offline support and reduced API calls.

3. **Error Handling**: Always handle network errors gracefully and show appropriate UI feedback.

4. **Rate Limiting**: Respect API rate limits and implement request throttling if needed.

5. **Testing**: Test with various network conditions and edge cases (no GPS, denied permissions, etc.).

## File Naming Conventions

| Component | Prefix Pattern | Example |
|-----------|---------------|---------|
| Config | `{provider}_config.dart` | `tomtom_config.dart` |
| Map Widget | `{prefix}_map_widget.dart` | `tt_map_widget.dart` |
| Tile Layer | `{prefix}_tile_layer.dart` | `tt_tile_layer.dart` |
| Markers | `{prefix}_markers.dart` | `tt_markers.dart` |
| Polylines | `{prefix}_polylines.dart` | `tt_polylines.dart` |
| Overlays | `{prefix}_overlays.dart` | `tt_overlays.dart` |
| Utils | `{prefix}_utils.dart` | `tt_utils.dart` |
| Routing | `{prefix}_routing_service.dart` | `tt_routing_service.dart` |

## Quick Reference - Existing Implementations

### OpenFreeMap (OFM)
- Config: `lib/common/openfreemap_config.dart`
- Widgets: `lib/widgets/open_free_maps/`
- Screens: `lib/screens/open_free_maps/`
- Import: `import 'package:app/widgets/open_free_maps/index.dart';`

### TomTom (TT)
- Config: `lib/common/tomtom_config.dart`
- Widgets: `lib/widgets/tomtom_maps/`
- Screens: `lib/screens/tomtom_maps/`
- Import: `import 'package:app/widgets/tomtom_maps/index.dart';`
- API Key: `WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G`

## Usage Examples

### Basic Map Display
```dart
import 'package:app/widgets/tomtom_maps/index.dart';

TTMapWidget(
  initialCenter: LatLng(37.7749, -122.4194),
  markers: [TTMarkers.currentLocationMarker(location)],
)
```

### Location Picker
```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TTLocationPickerScreen(
      title: 'Select Location',
      initialLocation: currentLocation,
    ),
  ),
);

if (result != null) {
  final lat = result['latitude'];
  final lng = result['longitude'];
  final address = result['address'];
}
```

### Route Calculation
```dart
final route = await TTRoutingService.getRoute(
  [origin, destination],
  profile: TTRouteProfile.car,
  traffic: true,
);

if (route != null) {
  print('Distance: ${route.formattedDistance}');
  print('Duration: ${route.formattedDuration}');
}
```
