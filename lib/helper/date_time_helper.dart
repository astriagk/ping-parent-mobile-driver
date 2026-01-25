class DateTimeHelper {
  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  /// Determines if the given time string is morning or evening
  /// Morning: 12:00 AM - 11:59 AM
  /// Evening: 12:00 PM - 11:59 PM
  /// Returns: "morning" or "evening"
  /// Example time format: "8:00 AM" or "2:30 PM"
  static String getTimeOfDay(String timeString) {
    try {
      final timeFormat = timeString.toUpperCase();

      // Extract hour from time string
      final parts = timeString.split(':');
      if (parts.isNotEmpty) {
        final hour = int.tryParse(parts[0]) ?? 0;

        // Check if it's PM
        final isPM = timeFormat.contains('PM');

        // Convert to 24-hour format
        final hour24 =
            isPM && hour != 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour);

        // Morning: 0-11 (12:00 AM to 11:59 AM)
        // Evening: 12-23 (12:00 PM to 11:59 PM)
        return hour24 < 12 ? 'morning' : 'evening';
      }
    } catch (e) {
      // Default to morning on error
      return 'morning';
    }
    return 'morning';
  }

  /// Formats the current date with the given time
  /// If [timeOfDay] is not provided, returns current date and time in the same format
  /// Example: "25 Jan'26 at 8:00 AM"
  static String getFormattedDateTime({String? timeOfDay}) {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = _getMonthName(now.month);
    final year = now.year.toString().substring(2);

    if (timeOfDay == null) {
      // If no time provided, use current time in 12-hour format
      int hour = now.hour;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour > 12) {
        hour = hour - 12;
      } else if (hour == 0) {
        hour = 12;
      }

      final formattedHour = hour.toString().padLeft(2, '0');
      return '$day $month\'$year at $formattedHour:$minute $period';
    }

    return '$day $month\'$year at $timeOfDay';
  }

  /// Checks if the given formatted time string is within 1 hour from now
  /// Returns true if within 1 hour, false otherwise
  /// Example: "25 Jan'26 at 8:00 AM"
  static bool isRideWithinOneHour(String formattedDateTime) {
    // try {
    //   // Parse the formatted string: "25 Jan'26 at 8:00 AM"
    //   final parts = formattedDateTime.split(' at ');
    //   if (parts.length != 2) return false;

    //   final datePart = parts[0]; // "25 Jan'26"
    //   final timePart = parts[1]; // "8:00 AM"

    //   // Parse date
    //   final dateParts = datePart.split(' ');
    //   if (dateParts.length != 2) return false;

    //   final day = int.parse(dateParts[0]);
    //   final monthStr = dateParts[1].replaceAll("'", '');
    //   final yearStr = dateParts[2];

    //   final months = {
    //     'Jan': 1,
    //     'Feb': 2,
    //     'Mar': 3,
    //     'Apr': 4,
    //     'May': 5,
    //     'Jun': 6,
    //     'Jul': 7,
    //     'Aug': 8,
    //     'Sep': 9,
    //     'Oct': 10,
    //     'Nov': 11,
    //     'Dec': 12
    //   };
    //   final month = months[monthStr] ?? 1;
    //   final year = 2000 + int.parse(yearStr);

    //   // Parse time
    //   final timeParts = timePart.split(' ');
    //   if (timeParts.length != 2) return false;

    //   final timeComponents = timeParts[0].split(':');
    //   if (timeComponents.length != 2) return false;

    //   var hour = int.parse(timeComponents[0]);
    //   final minute = int.parse(timeComponents[1]);
    //   final period = timeParts[1];

    //   // Convert to 24-hour format
    //   if (period == 'PM' && hour != 12) {
    //     hour += 12;
    //   } else if (period == 'AM' && hour == 12) {
    //     hour = 0;
    //   }

    //   // Create DateTime from parsed values
    //   final rideDateTime = DateTime(year, month, day, hour, minute);
    //   final now = DateTime.now();

    //   // Check if ride is within 1 hour from now
    //   final difference = rideDateTime.difference(now).inMinutes;
    //   return difference >= 0 && difference <= 60;
    // } catch (e) {
    //   return false;
    // }
    return true;
  }
}
