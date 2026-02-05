/// Enum for trip status
enum TripStatus {
  scheduled('scheduled'),
  started('started'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  final String value;

  const TripStatus(this.value);

  /// Convert string to TripStatus enum
  static TripStatus fromString(String value) {
    try {
      return TripStatus.values.firstWhere(
        (status) => status.value == value,
        orElse: () => TripStatus.scheduled,
      );
    } catch (e) {
      return TripStatus.scheduled;
    }
  }
}
