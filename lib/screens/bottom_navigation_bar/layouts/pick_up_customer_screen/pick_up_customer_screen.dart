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
  Timer? _socketUpdateTimer;
  Timer? _databaseUpdateTimer;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Cancel location update timers when screen is disposed
    _socketUpdateTimer?.cancel();
    _databaseUpdateTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeProviders() {
    _pickUpProvider = PickUpCustomerProvider();
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

    if (tripId != null) {
      try {
        // Get current location
        final myRidesProvider = MyRidesProvider();
        final position = await myRidesProvider.determinePosition();
        final lat = position.latitude;
        final lng = position.longitude;

        // Call the API using PickUpCustomerProvider from state
        final success = await _pickUpProvider.fetchOptimizedRoute(
          tripId: tripId,
          currentLatitude: lat,
          currentLongitude: lng,
        );

        // If route fetched successfully, trigger trip status update to "started"
        if (success && _pickUpProvider.optimizedRoute != null) {
          final routeId = _pickUpProvider.optimizedRoute!.id;
          _currentTripId = tripId;

          await _pickUpProvider.updateTripStatus(
            tripId: routeId,
            tripStatus: TripStatus.started.value,
          );

          // Start location tracking for live position updates
          _startLocationTracking();
        }
      } catch (e) {
        // Error fetching location and route
      }
    }
  }

  void _startLocationTracking() {
    final myRidesProvider = MyRidesProvider();

    _socketUpdateTimer = Timer.periodic(
      AppConstants.socketUpdateInterval,
      (_) async {
        try {
          final position = await myRidesProvider.determinePosition();
          _pickUpProvider.updateDriverPosition(
            tripId: _currentTripId,
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed ?? 0,
            heading: position.heading ?? 0,
            accuracy: position.accuracy ?? 0,
          );
        } catch (e) {}
      },
    );

    _databaseUpdateTimer = Timer.periodic(
      AppConstants.databaseUpdateInterval,
      (_) async {
        try {
          final position = await myRidesProvider.determinePosition();
          await _pickUpProvider.updateDriverPosition(
            tripId: _currentTripId,
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed ?? 0,
            heading: position.heading ?? 0,
            accuracy: position.accuracy ?? 0,
          );
        } catch (e) {}
      },
    );
  }

  void _stopLocationTracking() {
    _socketUpdateTimer?.cancel();
    _databaseUpdateTimer?.cancel();
    _socketUpdateTimer = null;
    _databaseUpdateTimer = null;
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

  void _handleWaypointCompletion() {
    final currentWaypoint = _getCurrentWaypoint(_pickUpProvider.optimizedRoute);
    final isSchoolLocation =
        currentWaypoint?.studentParentId == AppConstants.schoolLocationType;

    if (isSchoolLocation) {
      // For school location, stop tracking and navigate to ride details
      _stopLocationTracking();
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
                                  _pickUpProvider.optimizedRoute))

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
