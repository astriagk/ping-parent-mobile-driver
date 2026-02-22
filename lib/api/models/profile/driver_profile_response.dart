class DriverProfileResponse {
  final bool success;
  final DriverData? data;
  final String? message;
  final String? error;
  final List<String>? details;

  DriverProfileResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.details,
  });

  /// Factory constructor to parse JSON response
  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) {
    return DriverProfileResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? DriverData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
      details: json['details'] != null
          ? List<String>.from(json['details'] as List)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
      'error': error,
      'details': details,
    };
  }
}

class DriverData {
  final String id;
  final String userId;
  final String driverUniqueId;
  final String name;
  final String email;
  final String photoUrl;
  final String vehicleType;
  final String vehicleNumber;
  final int vehicleCapacity;
  final int currentStudentCount;
  final String approvalStatus;
  final bool isAvailable;
  final double rating;
  final int totalTrips;
  final String createdAt;
  final String updatedAt;

  DriverData({
    required this.id,
    required this.userId,
    required this.driverUniqueId,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    required this.currentStudentCount,
    required this.approvalStatus,
    required this.isAvailable,
    required this.rating,
    required this.totalTrips,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse JSON
  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      driverUniqueId: json['driver_unique_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleCapacity: json['vehicle_capacity'] ?? 0,
      currentStudentCount: json['current_student_count'] ?? 0,
      approvalStatus: json['approval_status'] ?? '',
      isAvailable: json['is_available'] ?? true,
      rating: (json['rating'] ?? 0).toDouble(),
      totalTrips: json['total_trips'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'driver_unique_id': driverUniqueId,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'vehicle_capacity': vehicleCapacity,
      'current_student_count': currentStudentCount,
      'approval_status': approvalStatus,
      'is_available': isAvailable,
      'rating': rating,
      'total_trips': totalTrips,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
