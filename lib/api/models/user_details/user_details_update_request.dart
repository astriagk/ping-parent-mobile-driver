import 'dart:convert';

class UserDetailsUpdateRequest {
  final String name;
  final String email;
  final String vehicleType;
  final String vehicleNumber;
  final int vehicleCapacity;
  final bool isAvailable;

  UserDetailsUpdateRequest({
    required this.name,
    required this.email,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    this.isAvailable = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'vehicle_capacity': vehicleCapacity,
      'is_available': isAvailable,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
