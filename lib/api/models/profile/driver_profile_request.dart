class DriverProfileRequest {
  final String name;
  final String email;
  final String photoUrl;
  final String vehicleType;
  final String vehicleNumber;
  final int vehicleCapacity;
  final bool isAvailable;

  DriverProfileRequest({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    required this.isAvailable,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'vehicle_capacity': vehicleCapacity,
      'is_available': isAvailable,
    };
  }

  /// Factory constructor to parse JSON
  factory DriverProfileRequest.fromJson(Map<String, dynamic> json) {
    return DriverProfileRequest(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleCapacity: json['vehicle_capacity'] ?? 0,
      isAvailable: json['is_available'] ?? true,
    );
  }
}
