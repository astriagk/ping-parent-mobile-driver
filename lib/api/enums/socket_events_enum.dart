/// Socket events for driver app real-time communication
/// Based on WEBSOCKET.md v3.1.0

/// Events emitted by the driver to the server
enum DriverSocketEvent {
  /// ✅ USED - Subscribe to trip before sending position updates
  /// Used in: socket_service.dart (subscribeToTrip method)
  subscribeTrp('driver:subscribe_trip'),

  /// ✅ USED - Unsubscribe from trip (cleanup)
  /// Used in: socket_service.dart (unsubscribeFromTrip method)
  unsubscribeTrp('driver:unsubscribe_trip'),

  /// ✅ USED - Sends driver location every 10 seconds
  /// Used in: socket_service.dart, background_location_handler.dart
  updatePosition('driver:update_position'),

  /// ✅ USED - Notifies server when driver starts the trip
  /// Used in: socket_service.dart (startTripViaWebSocket method)
  tripStarted('driver:trip_started'),

  /// ✅ USED - Notify server when driver completes the trip
  /// Used in: socket_service.dart (completeTripViaWebSocket method)
  tripCompleted('driver:trip_completed'),

  /// ✅ USED - Notify server when approaching a student location
  /// Used in: socket_service.dart (approachingWaypointViaWebSocket method)
  approachingWaypoint('driver:approaching_waypoint'),

  /// ✅ USED - Notify server when a student is picked up
  /// Used in: socket_service.dart (studentPickedViaWebSocket method)
  studentPicked('driver:student_picked'),

  /// ✅ USED - Notify server when a student is dropped off
  /// Used in: socket_service.dart (studentDroppedViaWebSocket method)
  studentDropped('driver:student_dropped');

  final String value;

  const DriverSocketEvent(this.value);
}

/// Events broadcast by the server to driver
/// Rate-limited: Position updates = 1 per 5 seconds per trip
enum BroadcastSocketEvent {
  /// Real-time position update from driver (5s-15s interval)
  positionUpdate('trip:position_update'),

  /// Trip status changed
  tripStarted('trip:started'),
  tripCompleted('trip:completed'),

  /// Route calculated/recalculated via REST API
  routeCalculated('trip:route_calculated'),

  /// Driver approaching student location
  approaching('trip:approaching'),

  /// Student lifecycle events
  studentPicked('trip:student_picked'),
  studentDropped('trip:student_dropped'),

  /// Socket/authorization error
  error('socket:error');

  final String value;

  const BroadcastSocketEvent(this.value);
}

/// Events sent to specific parent only (their child's events)
/// Auto-triggered when pickup/drop recorded via REST API
enum ParentNotificationEvent {
  /// Sent when parent's child is picked up from home
  myStudentPicked('parent:my_student_picked'),

  /// Sent when parent's child is dropped off at home
  myStudentDropped('parent:my_student_dropped'),

  /// Sent when driver approaching parent's child location
  myStudentApproaching('parent:my_student_approaching');

  final String value;

  const ParentNotificationEvent(this.value);
}
