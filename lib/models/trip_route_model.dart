import 'package:latlong2/latlong.dart';

class TripRoute {
  final String tripId;
  final List<List<double>> coordinates;
  final List<Waypoint> waypoints;
  final List<Waypoint> waypointsOptimized;
  final double totalDistance;
  final double totalDuration;

  TripRoute({
    required this.tripId,
    required this.coordinates,
    required this.waypoints,
    required this.waypointsOptimized,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory TripRoute.fromJson(Map<String, dynamic> json) {
    return TripRoute(
      tripId: json['trip_id'] ?? '',
      coordinates: List<List<double>>.from(
        (json['route_geometry']['coordinates'] as List).map(
          (coord) => [
            (coord[0] as num).toDouble(),
            (coord[1] as num).toDouble(),
          ],
        ),
      ),
      waypoints: (json['route_geometry']['waypoints'] as List)
          .map((w) => Waypoint.fromJson(w))
          .toList(),
      waypointsOptimized: (json['waypoints_optimized'] as List)
          .map((w) => Waypoint.fromJson(w))
          .toList(),
      totalDistance:
          (json['route_geometry']['total_distance'] as num).toDouble(),
      totalDuration:
          (json['route_geometry']['total_duration'] as num).toDouble(),
    );
  }

  /// Convert coordinates to LatLng list for map display
  List<LatLng> get routePoints {
    return coordinates.map((coord) => LatLng(coord[0], coord[1])).toList();
  }
}

class Waypoint {
  final String studentId;
  final String studentName;
  final String studentRollNumber;
  final double latitude;
  final double longitude;
  final String address;
  final School? school;
  final double? distanceFromPrevious;
  final int? durationFromPrevious;
  final DateTime? estimatedArrivalTime;

  Waypoint({
    required this.studentId,
    required this.studentName,
    required this.studentRollNumber,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.school,
    this.distanceFromPrevious,
    this.durationFromPrevious,
    this.estimatedArrivalTime,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentRollNumber: json['student_roll_number'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      distanceFromPrevious: json['distance_from_previous'] != null
          ? (json['distance_from_previous'] as num).toDouble()
          : null,
      durationFromPrevious: json['duration_from_previous'],
      estimatedArrivalTime: json['estimated_arrival_time'] != null
          ? DateTime.parse(json['estimated_arrival_time'])
          : null,
    );
  }

  LatLng get location => LatLng(latitude, longitude);
}

class School {
  final String schoolId;
  final String schoolName;
  final String schoolAddress;
  final String schoolCity;
  final String schoolState;
  final double schoolLatitude;
  final double schoolLongitude;
  final String? schoolContact;
  final String? schoolEmail;

  School({
    required this.schoolId,
    required this.schoolName,
    required this.schoolAddress,
    required this.schoolCity,
    required this.schoolState,
    required this.schoolLatitude,
    required this.schoolLongitude,
    this.schoolContact,
    this.schoolEmail,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolId: json['school_id'] ?? '',
      schoolName: json['school_name'] ?? '',
      schoolAddress: json['school_address'] ?? '',
      schoolCity: json['school_city'] ?? '',
      schoolState: json['school_state'] ?? '',
      schoolLatitude: (json['school_latitude'] as num).toDouble(),
      schoolLongitude: (json['school_longitude'] as num).toDouble(),
      schoolContact: json['school_contact'],
      schoolEmail: json['school_email'],
    );
  }

  LatLng get location => LatLng(schoolLatitude, schoolLongitude);
}
