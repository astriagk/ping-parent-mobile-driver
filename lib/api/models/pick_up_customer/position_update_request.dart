class PositionUpdateRequest {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final double accuracy;

  PositionUpdateRequest({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'accuracy': accuracy,
    };
  }
}
