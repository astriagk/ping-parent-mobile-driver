class DriverDocumentsResponse {
  final bool success;
  final DriverDocumentsData? data;
  final String? message;
  final String? error;
  final List<String>? details;

  DriverDocumentsResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.details,
  });

  /// Factory constructor to parse JSON response
  factory DriverDocumentsResponse.fromJson(Map<String, dynamic> json) {
    return DriverDocumentsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? DriverDocumentsData.fromJson(json['data'])
          : null,
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

class DriverDocumentsData {
  final String id;
  final String driverId;
  final String drivingLicenseNumber;
  final String drivingLicensePhotoUrl;
  final String vehicleLicenseNumber;
  final String vehicleLicensePhotoUrl;
  final String insuranceNumber;
  final String insurancePhotoUrl;
  final String createdAt;
  final String updatedAt;

  DriverDocumentsData({
    required this.id,
    required this.driverId,
    required this.drivingLicenseNumber,
    required this.drivingLicensePhotoUrl,
    required this.vehicleLicenseNumber,
    required this.vehicleLicensePhotoUrl,
    required this.insuranceNumber,
    required this.insurancePhotoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse JSON
  factory DriverDocumentsData.fromJson(Map<String, dynamic> json) {
    return DriverDocumentsData(
      id: json['_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      drivingLicenseNumber: json['driving_license_number'] ?? '',
      drivingLicensePhotoUrl: json['driving_license_photo_url'] ?? '',
      vehicleLicenseNumber: json['vehicle_license_number'] ?? '',
      vehicleLicensePhotoUrl: json['vehicle_license_photo_url'] ?? '',
      insuranceNumber: json['insurance_number'] ?? '',
      insurancePhotoUrl: json['insurance_photo_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driver_id': driverId,
      'driving_license_number': drivingLicenseNumber,
      'driving_license_photo_url': drivingLicensePhotoUrl,
      'vehicle_license_number': vehicleLicenseNumber,
      'vehicle_license_photo_url': vehicleLicensePhotoUrl,
      'insurance_number': insuranceNumber,
      'insurance_photo_url': insurancePhotoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
