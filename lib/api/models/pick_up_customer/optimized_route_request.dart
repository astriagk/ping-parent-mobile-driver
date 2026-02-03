class OptimizedRouteRequest {
  final String tripId;
  final double currentLatitude;
  final double currentLongitude;

  OptimizedRouteRequest({
    required this.tripId,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }

  @override
  String toString() {
    return 'OptimizedRouteRequest(tripId: $tripId, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude)';
  }
}
