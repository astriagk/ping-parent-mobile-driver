class TripStatusRequest {
  final String tripStatus;

  TripStatusRequest({
    required this.tripStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'trip_status': tripStatus,
    };
  }
}
