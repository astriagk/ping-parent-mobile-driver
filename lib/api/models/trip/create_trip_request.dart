import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';

class CreateTripRequest {
  final TripType tripType;
  final DateTime tripDate;

  CreateTripRequest({
    required this.tripType,
    required this.tripDate,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'trip_type': tripType.value,
      'trip_date': tripDate.toIso8601String(),
    };
  }

  /// Create from JSON
  factory CreateTripRequest.fromJson(Map<String, dynamic> json) {
    return CreateTripRequest(
      tripType: TripType.fromString(json['trip_type'] ?? 'pickup'),
      tripDate: DateTime.tryParse(json['trip_date'] ?? '') ?? DateTime.now(),
    );
  }
}
