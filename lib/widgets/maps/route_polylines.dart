import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;

/// Reusable polyline builder for all map providers
class RoutePolylines {
  /// Active route (solid blue line)
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.primary,
      strokeWidth: 4.0,
      borderColor: appTheme.primary.withOpacity(0.8),
      borderStrokeWidth: 1.0,
    );
  }

  /// Custom route with specified color and width
  static Polyline customRoute({
    required List<LatLng> points,
    required Color color,
    double strokeWidth = 3.0,
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
