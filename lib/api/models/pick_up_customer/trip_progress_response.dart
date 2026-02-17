/// Response model for GET /trips/:id/progress endpoint
class TripProgressResponse {
  final bool success;
  final TripProgressData? data;
  final String? message;
  final String? error;

  TripProgressResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory TripProgressResponse.fromJson(Map<String, dynamic> json) {
    return TripProgressResponse(
      success: json['success'] ?? false,
      data:
          json['data'] != null ? TripProgressData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
      'error': error,
    };
  }
}

class TripProgressData {
  final String tripId;
  final String tripType;
  final String tripStatus;
  final int currentWaypointIndex;
  final int totalWaypoints;
  final List<String> processedStudentIds;
  final List<String> inTransitStudentIds;
  final List<String> absentStudentIds;
  final String optimizedRouteId;
  final DateTime? startedAt;
  final DateTime? lastPositionUpdate;

  TripProgressData({
    required this.tripId,
    required this.tripType,
    required this.tripStatus,
    required this.currentWaypointIndex,
    required this.totalWaypoints,
    required this.processedStudentIds,
    required this.inTransitStudentIds,
    required this.absentStudentIds,
    required this.optimizedRouteId,
    this.startedAt,
    this.lastPositionUpdate,
  });

  factory TripProgressData.fromJson(Map<String, dynamic> json) {
    return TripProgressData(
      tripId: json['tripId'] ?? '',
      tripType: json['tripType'] ?? '',
      tripStatus: json['tripStatus'] ?? '',
      currentWaypointIndex: json['currentWaypointIndex'] ?? 0,
      totalWaypoints: json['totalWaypoints'] ?? 0,
      processedStudentIds: json['processedStudentIds'] != null
          ? List<String>.from(json['processedStudentIds'])
          : [],
      inTransitStudentIds: json['inTransitStudentIds'] != null
          ? List<String>.from(json['inTransitStudentIds'])
          : [],
      absentStudentIds: json['absentStudentIds'] != null
          ? List<String>.from(json['absentStudentIds'])
          : [],
      optimizedRouteId: json['optimizedRouteId'] ?? '',
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      lastPositionUpdate: json['lastPositionUpdate'] != null
          ? DateTime.parse(json['lastPositionUpdate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'tripType': tripType,
      'tripStatus': tripStatus,
      'currentWaypointIndex': currentWaypointIndex,
      'totalWaypoints': totalWaypoints,
      'processedStudentIds': processedStudentIds,
      'inTransitStudentIds': inTransitStudentIds,
      'absentStudentIds': absentStudentIds,
      'optimizedRouteId': optimizedRouteId,
      'startedAt': startedAt?.toIso8601String(),
      'lastPositionUpdate': lastPositionUpdate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TripProgressData(tripId: $tripId, tripType: $tripType, tripStatus: $tripStatus, '
        'currentWaypointIndex: $currentWaypointIndex, totalWaypoints: $totalWaypoints, '
        'processedStudentIds: $processedStudentIds, inTransitStudentIds: $inTransitStudentIds, '
        'absentStudentIds: $absentStudentIds, optimizedRouteId: $optimizedRouteId, '
        'startedAt: $startedAt, lastPositionUpdate: $lastPositionUpdate)';
  }
}
