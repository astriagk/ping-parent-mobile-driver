class DriverProfileData {
  final String userId;
  final String driverUniqueId;
  final String name;
  final String email;
  final String? photoUrl;
  final String vehicleType;
  final String vehicleNumber;
  final int vehicleCapacity;
  final int currentStudentCount;
  final String approvalStatus;
  final bool isAvailable;
  final int rating;
  final int totalTrips;
  final String createdAt;
  final String updatedAt;

  DriverProfileData({
    required this.userId,
    required this.driverUniqueId,
    required this.name,
    required this.email,
    this.photoUrl,
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

  factory DriverProfileData.fromJson(Map<String, dynamic> json) {
    return DriverProfileData(
      userId: json['user_id'] ?? '',
      driverUniqueId: json['driver_unique_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleCapacity: json['vehicle_capacity'] ?? 0,
      currentStudentCount: json['current_student_count'] ?? 0,
      approvalStatus: json['approval_status'] ?? '',
      isAvailable: json['is_available'] ?? true,
      rating: json['rating'] ?? 0,
      totalTrips: json['total_trips'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class UserDetailsUpdateResponse {
  final bool success;
  final DriverProfileData data;
  final String? message;

  UserDetailsUpdateResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory UserDetailsUpdateResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsUpdateResponse(
      success: json['success'] ?? false,
      data: DriverProfileData.fromJson(json['data'] ?? {}),
      message: json['message'],
    );
  }
}
