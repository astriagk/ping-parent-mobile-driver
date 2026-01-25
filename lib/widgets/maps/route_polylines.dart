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

  /// Completed route (green)
  static Polyline completedRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.online,
      strokeWidth: 4.0,
      borderColor: appTheme.online.withOpacity(0.8),
      borderStrokeWidth: 1.0,
    );
  }

  /// Planned route (dotted line - represented with dashes)
  static Polyline plannedRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.yellowIcon,
      strokeWidth: 3.0,
      borderColor: appTheme.yellowIcon.withOpacity(0.8),
      borderStrokeWidth: 1.0,
      isDotted: true,
    );
  }

  /// Alternative route (dashed line)
  static Polyline alternativeRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.yellowIcon,
      strokeWidth: 3.0,
      borderColor: appTheme.yellowIcon.withOpacity(0.8),
      borderStrokeWidth: 1.0,
      isDotted: true,
    );
  }

  /// Alert/danger route (red)
  static Polyline alertRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.alertZone,
      strokeWidth: 4.0,
      borderColor: appTheme.alertZone.withOpacity(0.8),
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

  /// Multi-segment route with gradient colors
  static List<Polyline> gradientRoute(
    List<LatLng> points,
    BuildContext context, {
    Color? startColor,
    Color? endColor,
    int segments = 5,
  }) {
    if (points.length < 2) return [];

    startColor ??= appTheme.online;
    endColor ??= appTheme.alertZone;

    final polylines = <Polyline>[];
    final segmentSize = (points.length / segments).ceil();

    for (int i = 0; i < segments; i++) {
      final startIdx = i * segmentSize;
      final endIdx = ((i + 1) * segmentSize).clamp(0, points.length);

      if (startIdx >= points.length) break;

      final segmentPoints = points.sublist(
        startIdx,
        endIdx.clamp(0, points.length),
      );

      // Interpolate color
      final progress = i / (segments - 1);
      final r =
          (startColor.red * (1 - progress) + endColor.red * progress).toInt();
      final g = (startColor.green * (1 - progress) + endColor.green * progress)
          .toInt();
      final b =
          (startColor.blue * (1 - progress) + endColor.blue * progress).toInt();

      final segmentColor = Color.fromARGB(255, r, g, b);

      polylines.add(
        Polyline(
          points: segmentPoints,
          color: segmentColor,
          strokeWidth: 4.0,
        ),
      );
    }

    return polylines;
  }

  /// Walking route (dotted blue line)
  static Polyline walkingRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.primary,
      strokeWidth: 3.0,
      isDotted: true,
    );
  }

  /// Cycling route (dashed green line)
  static Polyline cyclingRoute(List<LatLng> points, BuildContext context) {
    return Polyline(
      points: points,
      color: appTheme.online,
      strokeWidth: 3.0,
      isDotted: true,
    );
  }
}
