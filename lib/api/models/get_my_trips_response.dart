import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';

/// Waypoint data for optimized route
class TripWaypoint {
  final double latitude;
  final double longitude;
  final String address;
  final List<String> studentId;
  final String studentParentId;
  final List<String> studentNames;
  final String? studentPhotoUrl;
  final String? studentGender;
  final String? studentSection;
  final String? studentClass;
  final String? parentName;
  final String? parentEmail;
  final String? parentPhoneNumber;
  final String? parentUserId;
  final double distanceFromPrevious;
  final double durationFromPrevious;
  final String? estimatedArrivalTime;

  TripWaypoint({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.studentId,
    required this.studentParentId,
    required this.studentNames,
    this.studentPhotoUrl,
    this.studentGender,
    this.studentSection,
    this.studentClass,
    this.parentName,
    this.parentEmail,
    this.parentPhoneNumber,
    this.parentUserId,
    required this.distanceFromPrevious,
    required this.durationFromPrevious,
    this.estimatedArrivalTime,
  });

  factory TripWaypoint.fromJson(Map<String, dynamic> json) {
    return TripWaypoint(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      studentId: ((json['student_id'] as List?) ?? []).cast<String>(),
      studentParentId: json['student_parent_id'] ?? '',
      studentNames: ((json['student_names'] as List?) ?? []).cast<String>(),
      studentPhotoUrl: json['student_photo_url'],
      studentGender: json['student_gender'],
      studentSection: json['student_section'],
      studentClass: json['student_class'],
      parentName: json['parent_name'],
      parentEmail: json['parent_email'],
      parentPhoneNumber: json['parent_phone_number'],
      parentUserId: json['parent_user_id'],
      distanceFromPrevious:
          (json['distance_from_previous'] as num?)?.toDouble() ?? 0.0,
      durationFromPrevious:
          (json['duration_from_previous'] as num?)?.toDouble() ?? 0.0,
      estimatedArrivalTime: json['estimated_arrival_time'],
    );
  }
}

/// Optimized route data containing waypoints and coordinates
class TripOptimizedRouteData {
  final List<TripWaypoint> waypoints;
  final double totalDistance;
  final double totalDuration;
  final List<List<double>> coordinates;

  TripOptimizedRouteData({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
  });

  factory TripOptimizedRouteData.fromJson(Map<String, dynamic> json) {
    return TripOptimizedRouteData(
      waypoints: ((json['waypoints'] as List?) ?? [])
          .map((w) => TripWaypoint.fromJson(w as Map<String, dynamic>))
          .toList(),
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['total_duration'] as num?)?.toDouble() ?? 0.0,
      coordinates: ((json['coordinates'] as List?) ?? [])
          .map((coord) => [
                ((coord as List?)?[0] as num?)?.toDouble() ?? 0.0,
                ((coord)?[1] as num?)?.toDouble() ?? 0.0,
              ])
          .toList(),
    );
  }
}

class TripData {
  final String id;
  final String tripId;
  final String driverId;
  final TripType tripType;
  final String tripDate;
  final String tripStatus;
  final String createdAt;
  final String updatedAt;
  final TripOptimizedRouteData? optimizedRouteData;
  final double? totalDistance;
  final String? startTime;

  TripData({
    required this.id,
    required this.tripId,
    required this.driverId,
    required this.tripType,
    required this.tripDate,
    required this.tripStatus,
    required this.createdAt,
    required this.updatedAt,
    this.optimizedRouteData,
    this.totalDistance,
    this.startTime,
  });

  /// Create from JSON
  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      id: json['_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      tripType: TripType.fromString(json['trip_type'] ?? 'pickup'),
      tripDate: json['trip_date'] ?? '',
      tripStatus: json['trip_status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      optimizedRouteData: json['optimized_route_data'] != null
          ? TripOptimizedRouteData.fromJson(json['optimized_route_data'])
          : null,
      totalDistance: (json['total_distance'] as num?)?.toDouble(),
      startTime: json['start_time'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'trip_id': tripId,
      'driver_id': driverId,
      'trip_type': tripType.value,
      'trip_date': tripDate,
      'trip_status': tripStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'total_distance': totalDistance,
      'start_time': startTime,
    };
  }
}

class GetMyTripsResponse {
  final bool success;
  final List<TripData> data;
  final String message;

  GetMyTripsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  /// Create from JSON
  factory GetMyTripsResponse.fromJson(Map<String, dynamic> json) {
    final tripsList = (json['data'] as List<dynamic>?)
            ?.map((trip) => TripData.fromJson(trip as Map<String, dynamic>))
            .toList() ??
        [];

    return GetMyTripsResponse(
      success: json['success'] ?? false,
      data: tripsList,
      message: json['message'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((trip) => trip.toJson()).toList(),
      'message': message,
    };
  }
}
