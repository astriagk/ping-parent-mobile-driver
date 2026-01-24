/// Utility file for formatting addresses
class AddressUtil {
  /// Format parent address from address components
  /// Returns formatted string: "address_line1, address_line2, city, state pincode"
  static String formatParentAddress({
    required String? addressLine1,
    required String? addressLine2,
    required String? city,
    required String? state,
    required String? pincode,
  }) {
    final parts = <String>[];

    if (addressLine1?.isNotEmpty ?? false) parts.add(addressLine1!);
    if (addressLine2?.isNotEmpty ?? false) parts.add(addressLine2!);
    if (city?.isNotEmpty ?? false) parts.add(city!);

    String address = parts.join(', ');

    if ((state?.isNotEmpty ?? false) || (pincode?.isNotEmpty ?? false)) {
      final statePin =
          [state, pincode].where((s) => s?.isNotEmpty ?? false).join(' ');
      if (address.isNotEmpty && statePin.isNotEmpty) {
        address += ', $statePin';
      } else if (statePin.isNotEmpty) {
        address = statePin;
      }
    }

    return address.isEmpty ? 'Address not available' : address;
  }

  /// Format school address
  /// Returns formatted string: "address, city, state"
  static String formatSchoolAddress({
    required String? address,
    required String? city,
    required String? state,
  }) {
    final parts = <String>[];

    if (address?.isNotEmpty ?? false) parts.add(address!);
    if (city?.isNotEmpty ?? false) parts.add(city!);
    if (state?.isNotEmpty ?? false) parts.add(state!);

    final formatted = parts.join(', ');
    return formatted.isEmpty ? 'Address not available' : formatted;
  }
}
