class DriverDocumentsRequest {
  final String drivingLicenseNumber;
  final String drivingLicensePhotoUrl;
  final String vehicleLicenseNumber;
  final String vehicleLicensePhotoUrl;
  final String insuranceNumber;
  final String insurancePhotoUrl;

  DriverDocumentsRequest({
    required this.drivingLicenseNumber,
    required this.drivingLicensePhotoUrl,
    required this.vehicleLicenseNumber,
    required this.vehicleLicensePhotoUrl,
    required this.insuranceNumber,
    required this.insurancePhotoUrl,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'driving_license_number': drivingLicenseNumber,
      'driving_license_photo_url': drivingLicensePhotoUrl,
      'vehicle_license_number': vehicleLicenseNumber,
      'vehicle_license_photo_url': vehicleLicensePhotoUrl,
      'insurance_number': insuranceNumber,
      'insurance_photo_url': insurancePhotoUrl,
    };
  }
}
