/// Driver socket events
enum DriverSocketEvent {
  subscribeTrp('driver:subscribe_trip'),
  unsubscribeTrp('driver:unsubscribe_trip'),
  updatePosition('driver:update_position'),
  tripStarted('driver:trip_started'),
  tripCompleted('driver:trip_completed');

  final String value;

  const DriverSocketEvent(this.value);
}

/// Events broadcast from server
enum BroadcastSocketEvent {
  error('socket:error'),
  routeCalculated('trip:route_calculated');

  final String value;

  const BroadcastSocketEvent(this.value);
}
