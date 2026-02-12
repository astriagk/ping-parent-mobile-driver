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
import 'package:taxify_driver_ui/widgets/empty_state/empty_state_widget.dart';
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

  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  bool isOtpVerify = false;
  bool isOtp = false;
  bool showGif = false;
  bool isRideComplete = false;
  bool isTripComplete = false;
  int currentWaypointIndex = 0;

  // Track if this is a DROP trip (school → homes) vs PICKUP trip (homes → school)
  bool _isDropTrip = false;

  // Track if this is a resumed trip (not a fresh start)
  bool _isResuming = false;

  // Callback to center map on current location
  VoidCallback? _centerOnCurrentLocation;

  /// Reset all state variables for a fresh trip
  void _resetTripState() {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    isOtpVerify = false;
    isOtp = false;
    showGif = false;
    isRideComplete = false;
    isTripComplete = false;
    currentWaypointIndex = 0;
    _isDropTrip = false;
    _isResuming = false;
    _pickedUpStudentIds.clear();
    _currentTripId = null;
    _centerOnCurrentLocation = null;
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
    // Check trip progress first, then start/resume trip
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTrip();
    });
  }

  /// Initialize trip - check progress and start/resume accordingly
  Future<void> _initializeTrip() async {
    // First, check if there's existing trip progress
    await _fetchTripProgressOnLoad();

    // Then start or resume the trip based on progress
    await _autoStartTrip();
  }

  /// Auto-start trip when screen loads
  Future<void> _autoStartTrip() async {
    _fetchTripLatLongOnce().then((_) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = error?.toString();
        });
      }
    });
  }

  /// Fetch trip progress when screen loads and set state if resuming
  Future<void> _fetchTripProgressOnLoad() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    String? tripId;
    if (args is Map && args['tripId'] != null) {
      tripId = args['tripId'].toString();
      // Check if this is a DROP trip from route arguments
      if (args['isDropTrip'] == true) {
        _isDropTrip = true;
      }
    }
    // If tripId not in args, try getting from DropStudentSelectionProvider
    if (tripId == null || tripId.isEmpty) {
      tripId = context.read<DropStudentSelectionProvider>().currentTripId;
      if (tripId != null && tripId.isNotEmpty) {
        _isDropTrip = true;
      }
    }
    if (tripId != null && tripId.isNotEmpty) {
      await _checkAndApplyTripProgress(tripId);
    }
  }

  /// Check trip progress and apply state if trip is already in progress
  Future<void> _checkAndApplyTripProgress(String tripId) async {
    try {
      final tripProgress =
          await _pickUpProvider.getTripProgress(tripId: tripId);
      if (tripProgress != null) {
        final status = tripProgress.tripStatus.toLowerCase();

        // Set trip type from progress
        _isDropTrip = tripProgress.tripType.toLowerCase() == 'drop';

        // Only consider it "resuming" if status is truly in_progress
        // If status is 'started', we still need to update to 'in_progress'
        if (status == 'in_progress') {
          _isResuming = true;

          // Set waypoint index from progress
          currentWaypointIndex = tripProgress.currentWaypointIndex;

          // Set already processed students (picked up + in transit)
          _pickedUpStudentIds.clear();
          _pickedUpStudentIds.addAll(tripProgress.processedStudentIds);
          _pickedUpStudentIds.addAll(tripProgress.inTransitStudentIds);
        } else if (status == 'started') {
          // Trip is started but not in_progress yet
          // Apply waypoint index if available, but don't skip status update
          if (tripProgress.currentWaypointIndex > 0) {
            currentWaypointIndex = tripProgress.currentWaypointIndex;
          }
        }
      }
    } catch (e) {
      // Silent catch - fresh trip or progress fetch failed
    }
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
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    // Then check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      // Check if this is a DROP trip from route arguments (if not already set)
      if (!_isDropTrip && args['isDropTrip'] == true) {
        _isDropTrip = true;
      }
    }

    // If tripId not in args, try getting from DropStudentSelectionProvider (for DROP trips)
    if (tripId == null || tripId.isEmpty) {
      tripId = context.read<DropStudentSelectionProvider>().currentTripId;
      // If coming from DropStudentSelectionProvider, this is a DROP trip
      if (tripId != null && tripId.isNotEmpty && !_isDropTrip) {
        _isDropTrip = true;
      }
    }

    // Check if tripId is provided
    if (tripId == null || tripId.isEmpty) {
      throw Exception('Trip ID not found');
    }

    // Check location permission before starting
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      throw Exception('Location permission denied');
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

        // Only set waypoint index for fresh DROP trips (not resuming)
        // For resuming trips, waypoint index is already set from progress
        if (_isDropTrip && !_isResuming) {
          // For fresh DROP trips, school pickup is already handled
          // Skip the school waypoint (index 0) and start from first student home (index 1)
          currentWaypointIndex = 1;
        }

        // Only update trip status if NOT resuming (fresh start)
        if (!_isResuming) {
          // For DROP trips, status is already 'started' from drop_student_selection_screen
          // So we update to 'in_progress' here. For PICKUP trips, we set 'started'
          await _pickUpProvider.updateTripStatus(
            tripId: routeId,
            tripStatus: _isDropTrip
                ? TripStatus.inProgress.value
                : TripStatus.started.value,
          );
          _showSnackBar('Trip started successfully');
        } else {
          _showSnackBar('Trip resumed successfully');
        }

        await _pickUpProvider.startLocationTracking(_currentTripId!);
      } else {
        final errorMsg = _pickUpProvider.errorMessage ?? 'Failed to start trip';
        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
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

      // Get all student IDs from non-school waypoints to calculate skipped/absent students
      final allStudentIds = _getAllStudentIdsFromWaypoints();
      final skippedStudentIds =
          allStudentIds.where((id) => !studentIds.contains(id)).toList();

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Call school-point API
      // Only pass skipped_student_ids when all students are absent (student_ids is empty)
      final response = await _pickUpProvider.processSchoolPoint(
        tripId: _currentTripId!,
        studentIds: studentIds,
        latitude: position.latitude,
        longitude: position.longitude,
        skippedStudentIds: studentIds.isEmpty && skippedStudentIds.isNotEmpty
            ? skippedStudentIds
            : null,
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

  /// Get all student IDs from non-school waypoints
  List<String> _getAllStudentIdsFromWaypoints() {
    final waypoints = _pickUpProvider.optimizedRoute?.routeGeometry.waypoints;
    if (waypoints == null) return [];

    final allIds = <String>[];
    for (final waypoint in waypoints) {
      // Skip school location waypoint
      if (waypoint.studentParentId == AppConstants.schoolLocationType) continue;
      allIds.addAll(waypoint.studentIds);
    }
    return allIds;
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
          body: ChangeNotifierProvider<PickUpCustomerProvider>.value(
        value: _pickUpProvider,
        child: isLoading
            // Show skeleton while trip is initializing
            ? const PickUpScreenSkeleton()
            : hasError
                // Show error state with retry option
                ? Center(
                    child: EmptyStateWidget(
                      title: language(context, appFonts.somethingWentWrong),
                      message: errorMessage ??
                          language(context, appFonts.clickTheRefresh),
                      buttonText: language(context, appFonts.tryAgain),
                      onButtonTap: () {
                        setState(() {
                          isLoading = true;
                          hasError = false;
                          errorMessage = null;
                        });
                        _initializeTrip();
                      },
                    ),
                  )
                : Stack(children: [
                    Consumer<PickUpCustomerProvider>(
                      builder: (context, pickUpProvider, _) {
                        final currentWaypoint =
                            _getCurrentWaypoint(pickUpProvider.optimizedRoute);
                        final totalWaypoints = pickUpProvider.optimizedRoute
                                ?.routeGeometry.waypoints.length ??
                            0;

                        return Column(
                          children: [
                            // Map Header with waypoint info
                            if (!isLoading && currentWaypoint != null)
                              CommonMapHeader(
                                waypoint: currentWaypoint,
                                waypointIndex: currentWaypointIndex,
                                totalWaypoints: totalWaypoints,
                                onBack: () => route.pop(context),
                              ),
                            // Map
                            Expanded(
                              child: MapWidget(
                                config: config,
                                tileLayerBuilder: (urlTemplate) => MapTileLayer(
                                  urlTemplate: urlTemplate,
                                ),
                                trackCurrentLocation: true,
                                navigationMode: true,
                                currentLocationMarkerBuilder:
                                    (position, context,
                                            {double heading = 0.0}) =>
                                        MapMarkers.driverLocationMarker(
                                  position,
                                  context,
                                  heading: heading,
                                ),
                                markers: () => _buildWaypointMarkers(
                                    pickUpProvider.optimizedRoute),
                                polylineBuilder: (context) =>
                                    _buildRoutePolyline(
                                        pickUpProvider.optimizedRoute),
                                onMapReady: (centerCallback) {
                                  _centerOnCurrentLocation = centerCallback;
                                },
                              ),
                            ),
                            // Spacer to push map content above bottom sheet
                            SizedBox(height: Insets.i200),
                          ],
                        );
                      },
                    ),
                    // Current location floating button - above bottom sheet on right
                    Positioned(
                      bottom: Insets.i360,
                      right: Insets.i16,
                      child: CommonIconButton(
                        icon: svgAssets.gps,
                        bgColor: appTheme.white,
                        onTap: () => _centerOnCurrentLocation?.call(),
                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          language(
                                              context, appFonts.completeRide),
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
                                              duration:
                                                  const Duration(seconds: 5),
                                              image: const AssetImage(
                                                  "assets/gif/successful.gif"))),
                                      VSpace(Insets.i20),
                                      CommonButton(
                                          text: language(
                                              context, appFonts.rideDetails),
                                          onTap: () => route.pushNamed(context,
                                              routeName.rideDetailsScreen)),
                                    ]))
                            : isOtpVerify == true
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
                                    isFirstWaypointInteraction:
                                        _pickedUpStudentIds.isEmpty,
                                    isDropTrip: _isDropTrip,
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
                                  ))
                  ]),
      ));
    });
  }
}
