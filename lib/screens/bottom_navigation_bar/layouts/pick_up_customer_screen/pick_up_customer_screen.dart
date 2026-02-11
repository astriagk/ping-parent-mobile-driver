import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:gif/gif.dart';
import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/common/maps/map_config.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/config/app_constants.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/maps/index.dart';
import 'package:taxify_driver_ui/provider/bottom_bar_provider/pick_up_customer_provider.dart';
import 'layout/on_the_way_sheet.dart';
import 'layout/otp_verification_sheet.dart';
import 'layout/common_map_header.dart';

class PickUpCustomerScreen extends StatefulWidget {
  const PickUpCustomerScreen({super.key});

  @override
  State<PickUpCustomerScreen> createState() => _PickUpCustomerScreenState();
}

class _PickUpCustomerScreenState extends State<PickUpCustomerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late PickUpCustomerProvider _pickUpProvider;
  String? _currentTripId;

  bool isPickedUpCustomerClick = false;
  bool isOtpVerify = false;
  bool isOtp = false;
  bool showGif = false;
  bool isRideComplete = false;
  bool isTripComplete = false;
  int currentWaypointIndex = 0;

  // Track if this is a DROP trip (school → homes) vs PICKUP trip (homes → school)
  bool _isDropTrip = false;

  /// Reset all state variables for a fresh trip
  void _resetTripState() {
    isPickedUpCustomerClick = false;
    isOtpVerify = false;
    isOtp = false;
    showGif = false;
    isRideComplete = false;
    isTripComplete = false;
    currentWaypointIndex = 0;
    _isDropTrip = false;
    _pickedUpStudentIds.clear();
    _currentTripId = null;
  }

  // Track students who were marked as present during pickup
  final List<String> _pickedUpStudentIds = [];

  @override
  void initState() {
    super.initState();
    _initializeProviders();
    WidgetsBinding.instance.addObserver(this);
    // Ensure clean state for new trip
    _resetTripState();
    rideStart();
    // Request location permission on screen load for map
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _stopTracking();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _stopTracking() async {
    await _pickUpProvider.stopLocationTracking();
  }

  void _initializeProviders() {
    _pickUpProvider = PickUpCustomerProvider();
  }

  /// Show snackbar message to user
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidgetCommon(text: message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Check and request location permission
  Future<bool> _checkLocationPermission() async {
    // First check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied', isError: true);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
          'Location permission permanently denied. Please enable in settings.',
          isError: true);
      return false;
    }

    // Then check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Please enable location services in device settings',
          isError: true);
      // Try to open location settings
      await Geolocator.openLocationSettings();
      return false;
    }

    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Location tracking continues in both foreground and background
  }

  RouteWaypoint? _getCurrentWaypoint(OptimizedRoute? route) {
    if (route == null) return null;
    final waypoints = route.routeGeometry.waypoints;
    if (currentWaypointIndex >= waypoints.length) return null;
    return waypoints[currentWaypointIndex];
  }

  void _moveToNextWaypoint(OptimizedRoute? route) {
    if (route == null) return;
    final waypoints = route.routeGeometry.waypoints;
    if (currentWaypointIndex < waypoints.length - 1) {
      setState(() {
        currentWaypointIndex++;
        isOtpVerify = false;
        isOtp = false;
      });
    } else {
      setState(() {
        isRideComplete = true;
      });
    }
  }

  Future<void> _fetchTripLatLongOnce() async {
    final args = ModalRoute.of(context)?.settings.arguments;

    String? tripId;
    if (args is Map && args['tripId'] != null) {
      tripId = args['tripId'].toString();
      // Check if this is a DROP trip from route arguments
      if (args['isDropTrip'] == true) {
        _isDropTrip = true;
      }
    }

    // If tripId not in args, try getting from DropStudentSelectionProvider (for DROP trips)
    if (tripId == null || tripId.isEmpty) {
      tripId = context.read<DropStudentSelectionProvider>().currentTripId;
      // If coming from DropStudentSelectionProvider, this is a DROP trip
      if (tripId != null && tripId.isNotEmpty) {
        _isDropTrip = true;
      }
    }

    // Check if tripId is provided
    if (tripId == null || tripId.isEmpty) {
      _showSnackBar('Trip ID not found. Please try again.', isError: true);
      return;
    }

    // Check location permission before starting
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      return;
    }

    try {
      final myRidesProvider = MyRidesProvider();
      final position = await myRidesProvider.determinePosition();

      final success = await _pickUpProvider.fetchOptimizedRoute(
        tripId: tripId,
        currentLatitude: position.latitude,
        currentLongitude: position.longitude,
      );

      if (success && _pickUpProvider.optimizedRoute != null) {
        final routeId = _pickUpProvider.optimizedRoute!.id;
        _currentTripId = tripId;

        // For DROP trips, school pickup is already handled in drop_student_selection_screen
        // Skip the school waypoint (index 0) and start from first student home (index 1)
        if (_isDropTrip) {
          currentWaypointIndex = 1;
        }

        await _pickUpProvider.updateTripStatus(
          tripId: routeId,
          tripStatus: TripStatus.started.value,
        );

        await _pickUpProvider.startLocationTracking(_currentTripId!);
        _showSnackBar('Trip started successfully');
      } else {
        _showSnackBar(_pickUpProvider.errorMessage ?? 'Failed to start trip',
            isError: true);
      }
    } catch (e) {
      print('[D] Error: $e');
      _showSnackBar('Error starting trip: ${e.toString()}', isError: true);
    }
  }

  List<Marker> _buildWaypointMarkers(OptimizedRoute? route) {
    if (route == null) return [];

    final waypoints = route.routeGeometry.waypoints;
    if (waypoints.isEmpty) return [];

    return waypoints.map((waypoint) {
      final isSchoolLocation =
          waypoint.studentParentId == AppConstants.schoolLocationType;

      if (isSchoolLocation) {
        return MapMarkers.dropOffMarker(waypoint.location, context);
      } else {
        return MapMarkers.waypointMarker(
          waypoint.location,
          waypoint.studentNames.join(', '),
          context,
        );
      }
    }).toList();
  }

  List<Polyline> _buildRoutePolyline(OptimizedRoute? route) {
    if (route == null) return [];

    final routePoints = route.routeGeometry.routePoints;
    if (routePoints.isEmpty) return [];

    return [
      RoutePolylines.activeRoute(routePoints, context),
    ];
  }

  void rideStart() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showGif = false;
      });
    });
  }

  void otpSuccess() {
    setState(() {
      isOtpVerify = true;
      isOtp = true;
      showGif = true;
    });
    startDismissOtpSuccess();
  }

  Future<void> _handleWaypointCompletion() async {
    final currentWaypoint = _getCurrentWaypoint(_pickUpProvider.optimizedRoute);
    final isSchoolLocation =
        currentWaypoint?.studentParentId == AppConstants.schoolLocationType;
    final isLastWaypoint = _isLastWaypoint();

    if (_isDropTrip) {
      // DROP trip flow: school pickup already done, now dropping at student homes
      if (isLastWaypoint) {
        // Last student home - complete the trip
        await _completeDropTrip();
      } else {
        // Student home dropoff - show success and move to next
        otpSuccess();
      }
    } else {
      // PICKUP trip flow: student homes (pickup) → school (dropoff)
      if (isSchoolLocation) {
        // Last waypoint: school - call school-point API to complete
        await _processSchoolDropoff();
      } else {
        // Student home pickup - show success and move to next
        otpSuccess();
      }
    }
  }

  /// Check if current waypoint is the last one
  bool _isLastWaypoint() {
    final waypoints = _pickUpProvider.optimizedRoute?.routeGeometry.waypoints;
    if (waypoints == null) return false;
    return currentWaypointIndex >= waypoints.length - 1;
  }

  /// Complete DROP trip after last student is dropped at home
  Future<void> _completeDropTrip() async {
    try {
      // Update trip status to completed
      if (_pickUpProvider.optimizedRoute != null) {
        final routeId = _pickUpProvider.optimizedRoute!.id;
        await _pickUpProvider.updateTripStatus(
          tripId: routeId,
          tripStatus: TripStatus.completed.value,
        );
      }

      // Stop tracking and show success screen
      await _pickUpProvider.stopLocationTracking();
      if (mounted) {
        setState(() {
          isTripComplete = true;
        });
      }
    } catch (e) {
      _showSnackBar('Error completing trip: ${e.toString()}', isError: true);
      await _pickUpProvider.stopLocationTracking();
      if (mounted) {
        route.pushNamed(context, routeName.rideDetailsScreen);
      }
    }
  }

  /// Process school dropoff by calling the school-point API
  Future<void> _processSchoolDropoff() async {
    try {
      // Get only students who were picked up (marked as present)
      final studentIds = _getPickedUpStudentIds();

      if (studentIds.isEmpty) {
        _showSnackBar('No students were picked up to drop off', isError: true);
        await _pickUpProvider.stopLocationTracking();
        route.pushNamed(context, routeName.rideDetailsScreen);
        return;
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Call school-point API
      final response = await _pickUpProvider.processSchoolPoint(
        tripId: _currentTripId!,
        studentIds: studentIds,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (response != null && response.success) {
        // Check for any failed students
        if (response.data != null && response.data!.failedStudents.isNotEmpty) {
          final failedCount = response.data!.failedStudents.length;
          final processedCount = response.data!.processedStudents.length;
          _showSnackBar(
            'Dropped $processedCount students. $failedCount failed.',
            isError: failedCount > 0,
          );
        }

        // Update trip status to completed
        if (_pickUpProvider.optimizedRoute != null) {
          final routeId = _pickUpProvider.optimizedRoute!.id;
          await _pickUpProvider.updateTripStatus(
            tripId: routeId,
            tripStatus: TripStatus.completed.value,
          );
        }

        // Stop tracking and show success screen
        await _pickUpProvider.stopLocationTracking();
        if (mounted) {
          setState(() {
            isTripComplete = true;
          });
        }
      } else {
        _showSnackBar(
          _pickUpProvider.errorMessage ?? 'Failed to complete school dropoff',
          isError: true,
        );
        // Stop tracking and navigate to ride details on error
        await _pickUpProvider.stopLocationTracking();
        if (mounted) {
          route.pushNamed(context, routeName.rideDetailsScreen);
        }
      }
    } catch (e) {
      _showSnackBar('Error completing school dropoff: ${e.toString()}',
          isError: true);
      await _pickUpProvider.stopLocationTracking();
      if (mounted) {
        route.pushNamed(context, routeName.rideDetailsScreen);
      }
    }
  }

  /// Get the list of students who were picked up (marked as present)
  List<String> _getPickedUpStudentIds() {
    return List<String>.from(_pickedUpStudentIds);
  }

  /// Add picked up students to the tracking list
  /// Also updates trip status to in_progress on first pickup
  /// Emits WebSocket events to notify parents in the trip room
  Future<void> _addPickedUpStudents(List<String> studentIds) async {
    // Check if this is the first pickup (trip was just started, no students picked up yet)
    final isFirstPickup = _pickedUpStudentIds.isEmpty && studentIds.isNotEmpty;

    setState(() {
      for (final id in studentIds) {
        if (!_pickedUpStudentIds.contains(id)) {
          _pickedUpStudentIds.add(id);
        }
      }
    });

    // Note: Student pickup/dropoff events are handled via REST API only

    // Update trip status to in_progress after first successful pickup
    if (isFirstPickup && _pickUpProvider.optimizedRoute != null) {
      final routeId = _pickUpProvider.optimizedRoute!.id;
      await _pickUpProvider.updateTripStatus(
        tripId: routeId,
        tripStatus: TripStatus.inProgress.value,
      );
    }
  }

  void startDismissOtpSuccess() {
    Timer(const Duration(seconds: 3), () {
      if (isOtp) {
        setState(() {
          showGif = false;
        });
        _moveToNextWaypoint(_pickUpProvider.optimizedRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRidesProvider>(builder: (context, myRidesPvr, child) {
      final config = MapProvidersRegistry.getConfig();
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: language(context, appFonts.currenRide),
              titleWidth: MediaQuery.of(context).size.width * 0.01,
              icon: false,
              onTap: () => route.pop(context)),
          body: ChangeNotifierProvider<PickUpCustomerProvider>.value(
            value: _pickUpProvider,
            child: Stack(children: [
              Consumer<PickUpCustomerProvider>(
                builder: (context, pickUpProvider, _) {
                  final currentWaypoint =
                      _getCurrentWaypoint(pickUpProvider.optimizedRoute);
                  final totalWaypoints = pickUpProvider
                          .optimizedRoute?.routeGeometry.waypoints.length ??
                      0;

                  return Column(
                    children: [
                      // Map Header with waypoint info
                      if (isPickedUpCustomerClick && currentWaypoint != null)
                        CommonMapHeader(
                          waypoint: currentWaypoint,
                          waypointIndex: currentWaypointIndex,
                          totalWaypoints: totalWaypoints,
                        ),
                      // Map
                      Expanded(
                        child: MapWidget(
                          config: config,
                          tileLayerBuilder: (urlTemplate) => MapTileLayer(
                            urlTemplate: urlTemplate,
                          ),
                          currentLocationMarkerBuilder:
                              (position, controller) =>
                                  MapMarkers.driverLocationMarker(
                                      position, controller),
                          markers: () => _buildWaypointMarkers(
                              pickUpProvider.optimizedRoute),
                          polylineBuilder: (context) => _buildRoutePolyline(
                              pickUpProvider.optimizedRoute),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: isTripComplete == true
                      // Ride completed success screen
                      ? Container(
                          decoration: BoxDecoration(
                              color: appTheme.white,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(language(context, appFonts.completeRide),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                VSpace(Insets.i20),
                                CommonBgLayout(
                                    width: double.infinity,
                                    color: appTheme.bgBox,
                                    child: Gif(
                                        autostart: Autostart.loop,
                                        height: 128,
                                        width: 128,
                                        duration: const Duration(seconds: 5),
                                        image: const AssetImage(
                                            "assets/gif/successful.gif"))),
                                VSpace(Insets.i20),
                                CommonButton(
                                    text:
                                        language(context, appFonts.rideDetails),
                                    onTap: () => route.pushNamed(
                                        context, routeName.rideDetailsScreen)),
                              ]))
                      : isPickedUpCustomerClick == true
                          ? isOtpVerify == true
                              ? showGif == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: appTheme.white,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(20))),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                language(
                                                    context,
                                                    appFonts
                                                        .otpVerifiedSuccess),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            VSpace(Insets.i20),
                                            CommonBgLayout(
                                                width: double.infinity,
                                                color: appTheme.bgBox,
                                                child: Gif(
                                                    autostart: Autostart.loop,
                                                    height: 128,
                                                    width: 128,
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    image: const AssetImage(
                                                        "assets/gif/successful.gif")))
                                          ]))
                                  : OnTheWaySheet(
                                      onTap: isRideComplete == true
                                          ? () => route.pushNamed(context,
                                              routeName.rideDetailsScreen)
                                          : () {},
                                      isRideComplete: isRideComplete)
                              : OtpVerificationSheet(
                                  onTap: () => _handleWaypointCompletion(),
                                  waypoint: _getCurrentWaypoint(
                                      _pickUpProvider.optimizedRoute),
                                  tripId: _currentTripId,
                                  pickUpProvider: _pickUpProvider,
                                  onPickupSuccess: _addPickedUpStudents,
                                  onAllAbsent: () {
                                    // Move to next waypoint when all students marked absent
                                    _moveToNextWaypoint(
                                        _pickUpProvider.optimizedRoute);
                                  },
                                  onEndTrip: () async {
                                    await _stopTracking();
                                    if (mounted) {
                                      route.pop(context);
                                    }
                                  },
                                )

                          // start trip button
                          : CommonButton(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Insets.i20),
                                  onTap: () {
                                    _fetchTripLatLongOnce().then((_) {
                                      setState(() {
                                        isPickedUpCustomerClick = true;
                                      });
                                    });
                                  },
                                  text: language(context, appFonts.startTrip))
                              .marginOnly(bottom: Insets.i20))
            ]),
          ));
    });
  }
}
