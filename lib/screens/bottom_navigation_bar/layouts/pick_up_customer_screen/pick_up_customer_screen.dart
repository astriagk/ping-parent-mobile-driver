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
  late String _currentTripId;

  bool isPickedUpCustomerClick = false;
  bool isOtpVerify = false;
  bool isOtp = false;
  bool showGif = false;
  bool isRideComplete = false;
  int currentWaypointIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
    WidgetsBinding.instance.addObserver(this);
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

        await _pickUpProvider.updateTripStatus(
          tripId: routeId,
          tripStatus: TripStatus.started.value,
        );

        await _pickUpProvider.startLocationTracking(_currentTripId);
        _showSnackBar('Trip started successfully');
      } else {
        _showSnackBar(_pickUpProvider.errorMessage ?? 'Failed to start trip',
            isError: true);
      }
    } catch (e) {
      print('[Screen] Error: $e');
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

    if (isSchoolLocation) {
      // For school location, stop tracking and navigate to ride details
      await _pickUpProvider.stopLocationTracking();
      route.pushNamed(context, routeName.rideDetailsScreen);
    } else {
      // For student pickups, show OTP verification success
      otpSuccess();
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
                  child: isPickedUpCustomerClick == true
                      ? isOtpVerify == true
                          ? showGif == true
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
                                            language(context,
                                                appFonts.otpVerifiedSuccess),
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
                                                    "assets/gif/successful.gif")))
                                      ]))
                              : OnTheWaySheet(
                                  onTap: isRideComplete == true
                                      ? () => route.pushNamed(
                                          context, routeName.rideDetailsScreen)
                                      : () {},
                                  isRideComplete: isRideComplete)
                          : OtpVerificationSheet(
                              onTap: () => _handleWaypointCompletion(),
                              waypoint: _getCurrentWaypoint(
                                  _pickUpProvider.optimizedRoute),
                              tripId: _currentTripId,
                              pickUpProvider: _pickUpProvider,
                              onEndTrip: () async {
                                await _stopTracking();
                                if (mounted) {
                                  route.pop(context);
                                }
                              },
                            )

                      // start trip button
                      : CommonButton(
                              margin:
                                  EdgeInsets.symmetric(horizontal: Insets.i20),
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
