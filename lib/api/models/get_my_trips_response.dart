import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';

class TripData {
  final String id;
  final String tripId;
  final String driverId;
  final TripType tripType;
  final String tripDate;
  final String tripStatus;
  final String createdAt;
  final String updatedAt;

  TripData({
    required this.id,
    required this.tripId,
    required this.driverId,
    required this.tripType,
    required this.tripDate,
    required this.tripStatus,
    required this.createdAt,
    required this.updatedAt,
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
