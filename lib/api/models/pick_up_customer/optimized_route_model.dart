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
  final String id;
  final String tripId;
  final RouteGeometry routeGeometry;

  OptimizedRoute({
    required this.id,
    required this.tripId,
    required this.routeGeometry,
  });

  /// totalDistance and totalDuration are accessed via routeGeometry
  double get totalDistance => routeGeometry.totalDistance;
  double get totalDuration => routeGeometry.totalDuration;

  factory OptimizedRoute.fromJson(Map<String, dynamic> json) {
    return OptimizedRoute(
      id: json['_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      routeGeometry: RouteGeometry.fromJson(json['route_geometry'] ?? {}),
    );
  }
}

class RouteGeometry {
  final List<RouteWaypoint> waypoints;
  final double totalDistance;
  final double totalDuration;
  final List<List<double>> coordinates;
  final List<RouteLeg> legs;

  RouteGeometry({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
    required this.legs,
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
      legs: ((json['legs'] as List?) ?? [])
          .map((leg) => RouteLeg.fromJson(leg))
          .toList(),
    );
  }

  /// Convert coordinates to LatLng list for map display
  List<LatLng> get routePoints {
    return coordinates.map((coord) => LatLng(coord[0], coord[1])).toList();
  }
}

/// Represents a route leg between two consecutive waypoints
class RouteLeg {
  final double distance;
  final int duration;
  final List<List<double>> coordinates;

  RouteLeg({
    required this.distance,
    required this.duration,
    required this.coordinates,
  });

  factory RouteLeg.fromJson(Map<String, dynamic> json) {
    return RouteLeg(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      coordinates: ((json['coordinates'] as List?) ?? [])
          .map((coord) => [
                ((coord as List?)?[0] as num?)?.toDouble() ?? 0.0,
                ((coord as List?)?[1] as num?)?.toDouble() ?? 0.0,
              ])
          .toList(),
    );
  }

  /// Convert coordinates to LatLng list for this leg
  List<LatLng> get legPoints {
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
  final String? studentGender;
  final String? studentSection;
  final String? studentClass;
  final String? studentPhotoUrl;
  final String? parentName;
  final String? parentUserId;
  final String? parentEmail;
  final String? parentPhoneNumber;
  final WaypointSchool? school;
  final String? schoolId;
  final String? schoolName;
  final List<String>? schoolIds;
  final Map<String, dynamic>? schoolIdMap;
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
    this.studentGender,
    this.studentSection,
    this.studentClass,
    this.studentPhotoUrl,
    this.parentName,
    this.parentUserId,
    this.parentEmail,
    this.parentPhoneNumber,
    this.school,
    this.schoolId,
    this.schoolName,
    this.schoolIds,
    this.schoolIdMap,
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
      studentGender: json['student_gender'],
      studentSection: json['student_section'],
      studentClass: json['student_class'],
      studentPhotoUrl: json['student_photo_url'],
      parentUserId: json['parent_user_id'],
      parentName: json['parent_name'],
      parentEmail: json['parent_email'],
      parentPhoneNumber: json['parent_phone_number'],
      school: json['school'] != null
          ? WaypointSchool.fromJson(json['school'])
          : null,
      schoolId: json['school_id'] ?? (json['school'] != null ? json['school']['school_id'] : null),
      schoolName: json['school_name'] ?? (json['school'] != null ? json['school']['school_name'] : null),
      schoolIds: json['school_ids'] != null
          ? List<String>.from(json['school_ids'] as List)
          : null,
      schoolIdMap: json['school_id_map'] as Map<String, dynamic>?,
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

/// Represents school details nested within a route waypoint
class WaypointSchool {
  final String? schoolId;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolCity;
  final String? schoolState;
  final double? schoolLatitude;
  final double? schoolLongitude;
  final String? schoolContact;
  final String? schoolEmail;

  WaypointSchool({
    this.schoolId,
    this.schoolName,
    this.schoolAddress,
    this.schoolCity,
    this.schoolState,
    this.schoolLatitude,
    this.schoolLongitude,
    this.schoolContact,
    this.schoolEmail,
  });

  factory WaypointSchool.fromJson(Map<String, dynamic> json) {
    return WaypointSchool(
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      schoolAddress: json['school_address'],
      schoolCity: json['school_city'],
      schoolState: json['school_state'],
      schoolLatitude: (json['school_latitude'] as num?)?.toDouble(),
      schoolLongitude: (json['school_longitude'] as num?)?.toDouble(),
      schoolContact: json['school_contact'],
      schoolEmail: json['school_email'],
    );
  }

  LatLng? get location =>
      schoolLatitude != null && schoolLongitude != null
          ? LatLng(schoolLatitude!, schoolLongitude!)
          : null;
}
