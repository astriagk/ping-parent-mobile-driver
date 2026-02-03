import 'package:latlong2/latlong.dart';

class OptimizedRouteResponse {
  final bool success;
  final OptimizedRoute? data;
  final String message;

  OptimizedRouteResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory OptimizedRouteResponse.fromJson(Map<String, dynamic> json) {
    return OptimizedRouteResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? OptimizedRoute.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class OptimizedRoute {
  final bool success;
  final String id;
  final String tripId;
  final RouteGeometry routeGeometry;
  final double totalDistance;
  final double totalDuration;
  final int tripStudentsUpdated;
  final String message;

  OptimizedRoute({
    required this.success,
    required this.id,
    required this.tripId,
    required this.routeGeometry,
    required this.totalDistance,
    required this.totalDuration,
    required this.tripStudentsUpdated,
    required this.message,
  });

  factory OptimizedRoute.fromJson(Map<String, dynamic> json) {
    return OptimizedRoute(
      success: json['success'] ?? false,
      id: json['_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      routeGeometry: RouteGeometry.fromJson(json['route_geometry'] ?? {}),
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['total_duration'] as num?)?.toDouble() ?? 0.0,
      tripStudentsUpdated: json['trip_students_updated'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class RouteGeometry {
  final List<RouteWaypoint> waypoints;
  final double totalDistance;
  final double totalDuration;
  final List<List<double>> coordinates;

  RouteGeometry({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
  });

  factory RouteGeometry.fromJson(Map<String, dynamic> json) {
    return RouteGeometry(
      waypoints: ((json['waypoints'] as List?) ?? [])
          .map((w) => RouteWaypoint.fromJson(w))
          .toList(),
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['total_duration'] as num?)?.toDouble() ?? 0.0,
      coordinates: ((json['coordinates'] as List?) ?? [])
          .map((coord) => [
                ((coord as List?)?[0] as num?)?.toDouble() ?? 0.0,
                ((coord as List?)?[1] as num?)?.toDouble() ?? 0.0,
              ])
          .toList(),
    );
  }

  /// Convert coordinates to LatLng list for map display
  List<LatLng> get routePoints {
    return coordinates.map((coord) => LatLng(coord[0], coord[1])).toList();
  }
}

class RouteWaypoint {
  final double latitude;
  final double longitude;
  final String address;
  final List<String> studentIds;
  final String studentParentId;
  final List<String> studentNames;
  final double? distanceFromPrevious;
  final int? durationFromPrevious;
  final DateTime? estimatedArrivalTime;

  RouteWaypoint({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.studentIds,
    required this.studentParentId,
    required this.studentNames,
    this.distanceFromPrevious,
    this.durationFromPrevious,
    this.estimatedArrivalTime,
  });

  factory RouteWaypoint.fromJson(Map<String, dynamic> json) {
    return RouteWaypoint(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      studentIds: List<String>.from(json['student_id'] ?? []),
      studentParentId: json['student_parent_id'] ?? '',
      studentNames: List<String>.from(json['student_names'] ?? []),
      distanceFromPrevious:
          (json['distance_from_previous'] as num?)?.toDouble(),
      durationFromPrevious: json['duration_from_previous'],
      estimatedArrivalTime: json['estimated_arrival_time'] != null
          ? DateTime.parse(json['estimated_arrival_time'])
          : null,
    );
  }

  LatLng get location => LatLng(latitude, longitude);
}
