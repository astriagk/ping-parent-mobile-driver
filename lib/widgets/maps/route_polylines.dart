import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:skolo_driver/config.dart' hide Marker, Polyline, LatLng;

/// Reusable polyline builder for all map providers
class RoutePolylines {
  static Polyline activeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.primary,
      strokeWidth: Insets.i4,
      borderColor: appColor(context).appTheme.primary.withOpacity(0.8),
      borderStrokeWidth: Insets.i1,
    );
  }

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
