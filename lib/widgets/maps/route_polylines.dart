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

  /// Current route segment (dark/prominent color)
  /// This segment is from current waypoint to the next waypoint
  static Polyline currentRouteSegment(
    List<LatLng> points,
    BuildContext context,
  ) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.primary,
      strokeWidth: Insets.i4,
      borderColor: appColor(context).appTheme.primary.withOpacity(0.8),
      borderStrokeWidth: Insets.i1,
    );
  }

  /// Upcoming route segment (light/muted color)
  /// These segments are from future waypoints onwards
  static Polyline upcomingRouteSegment(
    List<LatLng> points,
    BuildContext context,
  ) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.primary.withOpacity(0.3),
      strokeWidth: Insets.i3,
      borderColor: appColor(context).appTheme.primary.withOpacity(0.15),
      borderStrokeWidth: Insets.i1,
    );
  }

  /// Completed route segment (greyed out / faded to show progress)
  /// These segments have already been traversed by the driver
  static Polyline completedRouteSegment(
    List<LatLng> points,
    BuildContext context,
  ) {
    return Polyline(
      points: points,
      color: appColor(context).appTheme.primary.withOpacity(0.15),
      strokeWidth: Insets.i3,
      borderColor: appColor(context).appTheme.primary.withOpacity(0.08),
      borderStrokeWidth: Insets.i1,
      isDotted: true,
    );
  }

  /// Find the index in coordinates closest to a given waypoint location
  static int _findClosestCoordinateIndex(
    List<LatLng> coordinates,
    double waypointLat,
    double waypointLng,
    int searchFrom,
  ) {
    int closestIdx = searchFrom;
    double minDist = double.infinity;

    for (int j = searchFrom; j < coordinates.length; j++) {
      final dLat = coordinates[j].latitude - waypointLat;
      final dLng = coordinates[j].longitude - waypointLng;
      final dist = dLat * dLat + dLng * dLng;
      if (dist < minDist) {
        minDist = dist;
        closestIdx = j;
      }
      // Once distance starts increasing after a close match, stop early
      if (dist > minDist && minDist < 0.0001) break;
    }
    return closestIdx;
  }

  /// Split the entire route into segments based on actual waypoint locations
  /// Finds each waypoint's position in the coordinates array for accurate splitting
  /// Returns polylines with color coding: current (dark), upcoming (light), completed (dotted)
  static List<Polyline> segmentedRoute({
    required List<LatLng> allCoordinates,
    required int waypointCount,
    required int currentWaypointIndex,
    required BuildContext context,
    List<LatLng>? waypointLocations,
  }) {
    if (allCoordinates.isEmpty || waypointCount <= 1) {
      return [activeRoute(allCoordinates, context)];
    }

    // Find split indices from actual waypoint locations
    final List<int> splitIndices = [0];

    if (waypointLocations != null && waypointLocations.length == waypointCount) {
      int searchFrom = 0;
      for (int i = 0; i < waypointLocations.length; i++) {
        final idx = _findClosestCoordinateIndex(
          allCoordinates,
          waypointLocations[i].latitude,
          waypointLocations[i].longitude,
          searchFrom,
        );
        splitIndices.add(idx);
        searchFrom = idx;
      }
    } else {
      // Fallback: evenly divide if no waypoint locations provided
      final pointsPerSegment =
          (allCoordinates.length / (waypointCount - 1)).ceil();
      for (int i = 1; i < waypointCount; i++) {
        splitIndices.add(
          (i * pointsPerSegment).clamp(0, allCoordinates.length),
        );
      }
    }

    // Ensure last index covers all coordinates
    if (splitIndices.last < allCoordinates.length) {
      splitIndices.add(allCoordinates.length);
    }

    final List<Polyline> polylines = [];

    // Build segments between consecutive split points
    for (int i = 0; i < splitIndices.length - 1; i++) {
      final startIdx = splitIndices[i];
      final endIdx = splitIndices[i + 1];

      if (startIdx >= endIdx || startIdx >= allCoordinates.length) continue;

      // Include the start point of next segment for continuity
      final segmentEnd = (endIdx + 1).clamp(0, allCoordinates.length);
      final segmentCoords = allCoordinates.sublist(startIdx, segmentEnd);

      if (segmentCoords.isEmpty) continue;

      if (i == currentWaypointIndex) {
        polylines.add(currentRouteSegment(segmentCoords, context));
      } else if (i > currentWaypointIndex) {
        polylines.add(upcomingRouteSegment(segmentCoords, context));
      } else {
        polylines.add(completedRouteSegment(segmentCoords, context));
      }
    }

    return polylines.isNotEmpty
        ? polylines
        : [activeRoute(allCoordinates, context)];
  }

  /// Layered route rendering using coordinates for full route + legs for current segment
  /// - Light line: full route from coordinates
  /// - Dark line: current leg from legs[currentWaypointIndex]
  static List<Polyline> layeredRoute({
    required List<LatLng> allCoordinates,
    required List<LatLng> legPoints,
    required int currentWaypointIndex,
    required BuildContext context,
  }) {
    if (allCoordinates.isEmpty) return [];

    final List<Polyline> polylines = [];

    // Base layer: full route as light line
    polylines.add(upcomingRouteSegment(allCoordinates, context));

    // Current leg: dark line on top
    if (legPoints.isNotEmpty) {
      polylines.add(currentRouteSegment(legPoints, context));
    }

    return polylines;
  }
}
