import 'dart:convert';
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/models/trip/create_trip_request.dart';
import 'package:skolo_driver/api/models/trip/create_trip_response.dart';
import 'package:skolo_driver/api/models/get_my_trips_response.dart';
import 'package:skolo_driver/api/enums/trip_type_enum.dart';

class ActiveRideService {
  final ApiClient _apiClient;

  ActiveRideService(this._apiClient);

  /// Create a new trip
  /// POST /trips
  ///
  /// Parameters:
  ///   - tripType: Type of trip (pickup or drop)
  ///   - tripDate: DateTime object for the trip
  ///
  /// Returns:
  ///   - CreateTripResponse with trip details on success
  Future<CreateTripResponse> createTrip({
    required TripType tripType,
    required DateTime tripDate,
  }) async {
    try {
      final request = CreateTripRequest(
        tripType: tripType,
        tripDate: tripDate,
      );

      final response = await _apiClient.post(
        Endpoints.createTrip,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return CreateTripResponse.fromJson(jsonResponse);
      } else {
        return CreateTripResponse(
          success: false,
          data: null,
          message: 'Failed to create trip. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return CreateTripResponse(
        success: false,
        data: null,
        message: 'Error creating trip: ${e.toString()}',
      );
    }
  }

  /// Get list of trips for the current driver
  /// GET /trips/my-trips
  ///
  /// Returns:
  ///   - GetMyTripsResponse with list of trips on success
  Future<GetMyTripsResponse> getMyTrips() async {
    try {
      final response = await _apiClient.get(Endpoints.myTrips);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return GetMyTripsResponse.fromJson(jsonResponse);
      } else {
        return GetMyTripsResponse(
          success: false,
          data: [],
          message: 'Failed to fetch trips. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return GetMyTripsResponse(
        success: false,
        data: [],
        message: 'Error fetching trips: ${e.toString()}',
      );
    }
  }

  /// Get list of trips for the current driver by date
  /// GET /trips/my-trips/by-date?date=M/D/YYYY
  ///
  /// Parameters:
  ///   - date: DateTime object to filter trips (defaults to current date)
  ///
  /// Returns:
  ///   - GetMyTripsResponse with list of trips on success
  Future<GetMyTripsResponse> getMyTripsByDate({DateTime? date}) async {
    try {
      final tripDate = date ?? DateTime.now();
      // Format date as M/D/YYYY (e.g., 2/9/2026)
      final formattedDate =
          '${tripDate.month}/${tripDate.day}/${tripDate.year}';

      final response =
          await _apiClient.get(Endpoints.myTripsByDate(formattedDate));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return GetMyTripsResponse.fromJson(jsonResponse);
      } else {
        return GetMyTripsResponse(
          success: false,
          data: [],
          message: 'Failed to fetch trips. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return GetMyTripsResponse(
        success: false,
        data: [],
        message: 'Error fetching trips: ${e.toString()}',
      );
    }
  }
}
