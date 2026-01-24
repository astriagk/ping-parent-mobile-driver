/// Enum for driver-student assignment status
enum AssignmentStatus {
  active('active'),
  inactive('inactive'),
  pending('pending'),
  parentRequested('parent_requested'),
  rejected('rejected'),
  approved('approved');

  final String value;

  const AssignmentStatus(this.value);

  /// Convert string to AssignmentStatus enum
  static AssignmentStatus fromString(String value) {
    try {
      return AssignmentStatus.values.firstWhere(
        (status) => status.value == value,
        orElse: () => AssignmentStatus.pending,
      );
    } catch (e) {
      return AssignmentStatus.pending;
    }
  }

  /// Convert enum to string
  @override
  String toString() => value;
}
