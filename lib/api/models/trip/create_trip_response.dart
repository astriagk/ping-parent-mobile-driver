import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';

class Trip {
  final String id;
  final String driverId;
  final TripType tripType;
  final String tripDate;
  final String tripStatus;
  final String createdAt;
  final String updatedAt;

  Trip({
    required this.id,
    required this.driverId,
    required this.tripType,
    required this.tripDate,
    required this.tripStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'] ?? '',
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
      'driver_id': driverId,
      'trip_type': tripType.value,
      'trip_date': tripDate,
      'trip_status': tripStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CreateTripResponse {
  final bool success;
  final Trip? data;
  final String message;

  CreateTripResponse({
    required this.success,
    this.data,
    required this.message,
  });

  /// Create from JSON
  factory CreateTripResponse.fromJson(Map<String, dynamic> json) {
    // Handle both 'message' and 'error' fields from backend
    final message = json['message'] ?? json['error'] ?? '';
    return CreateTripResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? Trip.fromJson(json['data']) : null,
      message: message,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}
