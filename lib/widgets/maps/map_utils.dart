import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

/// Utility functions for map operations
class MapUtils {
  /// Calculate distance between two points in kilometers using Haversine formula
  static double calculateDistance(LatLng point1, LatLng point2) {
    const earthRadiusKm = 6371.0;

    final dLat = _toRadians(point2.latitude - point1.latitude);
    final dLon = _toRadians(point2.longitude - point1.longitude);

    final lat1 = _toRadians(point1.latitude);
    final lat2 = _toRadians(point2.latitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) *
            math.sin(dLon / 2) *
            math.cos(lat1) *
            math.cos(lat2);

    final c = 2 * math.asin(math.sqrt(a));
    return earthRadiusKm * c;
  }

  /// Convert degrees to radians
  static double _toRadians(double degree) {
    return degree * math.pi / 180.0;
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
      return '${minutes} min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours h';
    }
    return '$hours h ${mins} min';
  }

  /// Get bearing between two points (0-360 degrees)
  static double getBearing(LatLng from, LatLng to) {
    final lat1 = _toRadians(from.latitude);
    final lat2 = _toRadians(to.latitude);
    final dLon = _toRadians(to.longitude - from.longitude);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = (math.atan2(y, x) * 180 / math.pi + 360) % 360;
    return bearing;
  }

  /// Convert bearing to compass direction
  static String getBearingDirection(double bearing) {
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];
    final index = ((bearing + 11.25) / 22.5).toInt() % 16;
    return directions[index];
  }

  /// Check if point is within bounds
  static bool isPointInBounds(
    LatLng point,
    LatLng southwest,
    LatLng northeast,
  ) {
    return point.latitude >= southwest.latitude &&
        point.latitude <= northeast.latitude &&
        point.longitude >= southwest.longitude &&
        point.longitude <= northeast.longitude;
  }

  /// Get center point of multiple markers
  static LatLng getCenterPoint(List<LatLng> points) {
    if (points.isEmpty) {
      return const LatLng(0, 0);
    }
    if (points.length == 1) {
      return points[0];
    }

    double lat = 0;
    double lon = 0;

    for (final point in points) {
      lat += point.latitude;
      lon += point.longitude;
    }

    return LatLng(lat / points.length, lon / points.length);
  }

  /// Simplify polyline points (reduce points for performance)
  static List<LatLng> simplifyPolyline(
    List<LatLng> points, {
    double tolerance = 0.00001,
  }) {
    if (points.length <= 2) return points;

    final simplified = <LatLng>[];
    simplified.add(points[0]);

    for (int i = 1; i < points.length - 1; i++) {
      final point = points[i];
      final prev = points[i - 1];
      final next = points[i + 1];

      final distance = _perpendicularDistance(point, prev, next);
      if (distance > tolerance) {
        simplified.add(point);
      }
    }

    simplified.add(points[points.length - 1]);
    return simplified;
  }

  /// Calculate perpendicular distance from point to line
  static double _perpendicularDistance(
    LatLng point,
    LatLng lineStart,
    LatLng lineEnd,
  ) {
    final x0 = point.longitude;
    final y0 = point.latitude;
    final x1 = lineStart.longitude;
    final y1 = lineStart.latitude;
    final x2 = lineEnd.longitude;
    final y2 = lineEnd.latitude;

    final numerator = ((x2 - x1) * (y1 - y0) - (x1 - x0) * (y2 - y1)).abs();
    final denominator =
        math.sqrt((((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))));

    return numerator / denominator;
  }

  /// Estimate zoom level based on distance between points
  ///
  /// Returns an appropriate zoom level for the given distance in kilometers.
  /// Useful for automatically zooming to fit multiple markers on the map.
  ///
  /// Distance mapping:
  /// - > 300 km: zoom 5 (regional view)
  /// - > 100 km: zoom 7 (regional/city view)
  /// - > 50 km: zoom 9 (city view)
  /// - > 20 km: zoom 11 (city/neighborhood view)
  /// - > 10 km: zoom 12 (neighborhood view)
  /// - > 5 km: zoom 13 (street view)
  /// - > 2 km: zoom 14 (street detail view)
  /// - <= 2 km: zoom 15 (building/street detail view)
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

  /// Validate coordinates
  static bool isValidCoordinate(LatLng point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }
}
