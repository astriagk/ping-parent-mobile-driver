class TripStatusResponse {
  final bool success;
  final TripStatusData? data;
  final String? message;

  TripStatusResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory TripStatusResponse.fromJson(Map<String, dynamic> json) {
    return TripStatusResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? TripStatusData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class TripStatusData {
  final String id;
  final String tripId;
  final String driverId;
  final String tripType;
  final DateTime tripDate;
  final String tripStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OptimizedRouteData? optimizedRouteData;
  final double totalDistance;
  final DateTime? startTime;

  TripStatusData({
    required this.id,
    required this.tripId,
    required this.driverId,
    required this.tripType,
    required this.tripDate,
    required this.tripStatus,
    required this.createdAt,
    required this.updatedAt,
    this.optimizedRouteData,
    required this.totalDistance,
    this.startTime,
  });

  factory TripStatusData.fromJson(Map<String, dynamic> json) {
    return TripStatusData(
      id: json['_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      tripType: json['trip_type'] ?? '',
      tripDate: json['trip_date'] != null
          ? DateTime.parse(json['trip_date'] as String)
          : DateTime.now(),
      tripStatus: json['trip_status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      optimizedRouteData: json['optimized_route_data'] != null
          ? OptimizedRouteData.fromJson(json['optimized_route_data'])
          : null,
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0.0,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : null,
    );
  }
}

class OptimizedRouteData {
  final List<Waypoint> waypoints;
  final double totalDistance;
  final double totalDuration;
  final List<List<double>> coordinates;

  OptimizedRouteData({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
  });

  factory OptimizedRouteData.fromJson(Map<String, dynamic> json) {
    return OptimizedRouteData(
      waypoints: ((json['waypoints'] as List?) ?? [])
          .map((w) => Waypoint.fromJson(w))
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
}

class Waypoint {
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
  final double distanceFromPrevious;
  final double durationFromPrevious;
  final DateTime estimatedArrivalTime;

  Waypoint({
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
    required this.distanceFromPrevious,
    required this.durationFromPrevious,
    required this.estimatedArrivalTime,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
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
      distanceFromPrevious:
          (json['distance_from_previous'] as num?)?.toDouble() ?? 0.0,
      durationFromPrevious:
          (json['duration_from_previous'] as num?)?.toDouble() ?? 0.0,
      estimatedArrivalTime: json['estimated_arrival_time'] != null
          ? DateTime.parse(json['estimated_arrival_time'] as String)
          : DateTime.now(),
    );
  }
}
