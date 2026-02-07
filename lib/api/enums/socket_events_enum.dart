/// Socket events for driver app real-time communication
///
/// Usage Status:
/// ✅ USED - Currently implemented in the app
/// 🔧 TODO - Required but not yet implemented

/// Events emitted by the driver to the server
enum DriverSocketEvent {
  /// ✅ USED - Sends driver location every 10 seconds
  /// Used in: socket_service.dart, background_location_handler.dart
  updatePosition('driver:update_position'),

  /// ✅ USED - Notifies server when driver starts the trip
  /// Used in: socket_service.dart
  tripStarted('driver:trip_started'),

  /// 🔧 TODO - Notify server when driver completes the trip
  tripCompleted('driver:trip_completed'),

  /// 🔧 TODO - Notify server when a student is picked up
  studentPicked('driver:student_picked'),

  /// 🔧 TODO - Notify server when a student is dropped off
  studentDropped('driver:student_dropped');

  final String value;

  const DriverSocketEvent(this.value);
}

/// Events broadcast by the server (driver listens to these)
enum BroadcastSocketEvent {
  /// 🔧 TODO - Listen for socket/server errors
  error('socket:error');

  final String value;

  const BroadcastSocketEvent(this.value);
}
