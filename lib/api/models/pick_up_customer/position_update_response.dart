class PositionUpdateResponse {
  final bool success;
  final PositionData? data;
  final String? message;

  PositionUpdateResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory PositionUpdateResponse.fromJson(Map<String, dynamic> json) {
    return PositionUpdateResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? PositionData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class PositionData {
  final String id;
  final String trackingId;
  final String tripId;
  final String driverId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final double accuracy;
  final DateTime timestamp;

  PositionData({
    required this.id,
    required this.trackingId,
    required this.tripId,
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
    required this.timestamp,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) {
    return PositionData(
      id: json['_id'] ?? '',
      trackingId: json['tracking_id'] ?? '',
      tripId: json['trip_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      heading: (json['heading'] as num?)?.toDouble() ?? 0.0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}
