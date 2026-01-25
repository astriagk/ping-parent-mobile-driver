/// Enum for trip type
enum TripType {
  pickup('pickup'),
  drop('drop');

  final String value;

  const TripType(this.value);

  /// Convert string to TripType enum
  static TripType fromString(String value) {
    try {
      return TripType.values.firstWhere(
        (type) => type.value == value,
        orElse: () => TripType.pickup,
      );
    } catch (e) {
      return TripType.pickup;
    }
  }
}
