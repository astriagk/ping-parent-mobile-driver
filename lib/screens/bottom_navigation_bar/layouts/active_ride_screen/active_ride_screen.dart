import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/empty_state/index.dart';
import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';
import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/api/models/get_my_trips_response.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen>
    with WidgetsBindingObserver, RouteAware {
  int? _lastTabIndex;
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called when a screen pushed on top of this one is popped
  @override
  void didPopNext() {
    _fetchTrips();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Track when app goes to background (not just inactive from notification shade)
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }
    // Refresh only when returning from actual background
    if (state == AppLifecycleState.resumed &&
        _wasInBackground &&
        _lastTabIndex == 1) {
      _wasInBackground = false;
      _fetchTrips();
    }
  }

  /// Fetch trips from API
  void _fetchTrips() {
    if (mounted) {
      context.read<ActiveRideProvider>().fetchMyTripsByDate();
    }
  }

  void _showSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidgetCommon(text: message),
        duration: duration,
      ),
    );
  }

  bool _tripExists(TripType tripType, ActiveRideProvider activeRidePvr) {
    final exists =
        activeRidePvr.myTrips.any((trip) => trip.tripType == tripType);
    return exists;
  }

  /// Get trip data for the given trip type
  TripData? _getTripForType(
      TripType tripType, ActiveRideProvider activeRidePvr) {
    try {
      return activeRidePvr.myTrips
          .firstWhere((trip) => trip.tripType == tripType);
    } catch (e) {
      return null;
    }
  }

  /// Get the button label based on trip status
  String _getButtonLabel(BuildContext context, TripType tripType,
      ActiveRideProvider activeRidePvr) {
    final trip = _getTripForType(tripType, activeRidePvr);

    if (trip == null) {
      return language(context, appFonts.createTrip);
    }

    final status = TripStatus.fromString(trip.tripStatus);
    switch (status) {
      case TripStatus.scheduled:
        return language(context, appFonts.startTrip);
      case TripStatus.started:
        return language(context, appFonts.viewMap);
      case TripStatus.inProgress:
        return language(context, appFonts.inProgress);
      case TripStatus.completed:
        return language(context, appFonts.tripCompleted);
      case TripStatus.cancelled:
        return language(context, appFonts.tripCancelled);
    }
  }

  /// Check if button should be enabled based on trip status
  bool _isButtonEnabled(TripType tripType, ActiveRideProvider activeRidePvr) {
    final trip = _getTripForType(tripType, activeRidePvr);

    if (trip == null) {
      return true; // Enable for create trip
    }

    final status = TripStatus.fromString(trip.tripStatus);
    // Disable button for completed and cancelled trips
    return status != TripStatus.completed && status != TripStatus.cancelled;
  }

  Future<void> _onCreateTripTap(
      TripType tripType, ActiveRideProvider activeRidePvr) async {
    if (_tripExists(tripType, activeRidePvr)) {
      final trip =
          activeRidePvr.myTrips.firstWhere((t) => t.tripType == tripType);
      final status = TripStatus.fromString(trip.tripStatus);

      // If trip is in-progress, go directly to map for both PICKUP and DROP
      if (status == TripStatus.inProgress) {
        await route.pushNamed(
          context,
          routeName.pickupCustomerScreen,
          arg: {
            'tripId': trip.tripId,
            if (tripType == TripType.drop) 'isDropTrip': true,
          },
        );
      } else if (tripType == TripType.drop) {
        // For DROP trips (not in-progress), go to student selection screen
        context
            .read<DropStudentSelectionProvider>()
            .setCurrentTripId(trip.tripId, statusId: trip.id);
        await route.pushNamed(context, routeName.dropStudentSelectionScreen);
      } else {
        // For PICKUP trips, go directly to map
        await route.pushNamed(
          context,
          routeName.pickupCustomerScreen,
          arg: {'tripId': trip.tripId, 'tripStatus': trip.tripStatus},
        );
      }

      // Refresh trips silently when returning from map screen
      if (mounted) {
        activeRidePvr.fetchMyTripsByDate(showLoading: false);
      }
    } else {
      final success = await activeRidePvr.createTrip(
        tripType: tripType,
        tripDate: DateTime.now(),
      );

      if (!mounted) return;

      if (success) {
        await activeRidePvr.fetchMyTripsByDate(showLoading: false);
        // After creating the trip, fetch again to get the newly created trip
        TripData? updatedTrip;
        try {
          updatedTrip =
              activeRidePvr.myTrips.firstWhere((t) => t.tripType == tripType);
        } catch (e) {
          updatedTrip = null;
        }

        if (updatedTrip != null) {
          // Automatically navigate to the appropriate screen
          if (tripType == TripType.drop) {
            context
                .read<DropStudentSelectionProvider>()
                .setCurrentTripId(updatedTrip.tripId, statusId: updatedTrip.id);
            await route.pushNamed(
                context, routeName.dropStudentSelectionScreen);
          } else {
            await route.pushNamed(
              context,
              routeName.pickupCustomerScreen,
              arg: {'tripId': updatedTrip.tripId, 'tripStatus': updatedTrip.tripStatus},
            );
          }
        }
      }

      final message =
          success ? activeRidePvr.successMessage : activeRidePvr.errorMessage;

      if (message != null) {
        _showSnackBar(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch BottomBarProvider to detect tab changes
    final bottomBarProvider = context.watch<BottomBarProvider>();
    final currentTab = bottomBarProvider.currentTab;

    // Fetch trips when this tab becomes active
    if (currentTab == 1 && _lastTabIndex != 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ActiveRideProvider>().fetchMyTripsByDate();
        }
      });
    }
    _lastTabIndex = currentTab;

    return Consumer2<ActiveRideProvider, MyRidesProvider>(
        builder: (context, activeRidePvr, myRidePvr, child) {
      // Show loading state while fetching trips
      if (activeRidePvr.isLoading) {
        return SingleChildScrollView(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    left: Insets.i20,
                    right: Insets.i20,
                    top: Insets.i20,
                    bottom: Insets.i20),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return const ActiveRideCardSkeleton()
                      .marginOnly(bottom: Insets.i10);
                }));
      }

      // Show error state if API call failed
      if (activeRidePvr.errorMessage != null) {
        return EmptyStateWidget(
          message: activeRidePvr.errorMessage,
          buttonText: language(context, appFonts.refresh),
          onButtonTap: () => activeRidePvr.fetchMyTripsByDate(),
        );
      }

      return SingleChildScrollView(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: Insets.i20,
                  right: Insets.i20,
                  top: Insets.i20,
                  bottom: Insets.i20),
              itemCount: appArray.ridesData.length,
              itemBuilder: (context, index) {
                final ride = appArray.ridesData[index];
                return CommonBgLayout(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                  screensWidgets
                                      .userProfileImage(ride['imageUrl']),
                                  HSpace(Insets.i10),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              screensWidgets
                                                  .userName(ride['userName'])
                                            ]),
                                        VSpace(Insets.i6),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              screensWidgets.ratingCounting(
                                                  ride['rating'],
                                                  ride['totalRatings'])
                                            ])
                                      ])),
                                  TextWidgetCommon(
                                    text: ride['tripType'].value.toUpperCase(),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ride['tripType'] == TripType.pickup
                                        ? appTheme.primary
                                        : appTheme.yellowIcon,
                                  )
                                  // screensWidgets.priceText(ride['price'],
                                  //     bottomMargin: 23.0)
                                ]))
                          ]),
                      VSpace(Insets.i15),
                      homeScreenWidget.dottedLineCommon(),
                      VSpace(Insets.i15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ride['time'],
                                style: AppCss.lexendLight12
                                    .textColor(appTheme.textClr)
                                    .textHeight(1.3)),
                            Row(children: [
                              CommonIconButton(
                                  onTap: () => route.pushNamed(
                                      context, routeName.chatScreen),
                                  icon: svgAssets.message,
                                  bgColor: appTheme.bgBox),
                              HSpace(Insets.i10),
                              CommonIconButton(
                                  onTap: () =>
                                      activeRidePvr.openDialer(ride['contact']),
                                  icon: svgAssets.call,
                                  bgColor: appTheme.bgBox)
                            ])
                          ]),
                      VSpace(Insets.i15),
                      // CommonLocationLayout(
                      //     pickUpAddress: ride['pickUpAddress'],
                      //     droppingAddress: ride['droppingAddress']),
                      Row(children: [
                        HSpace(Insets.i10),
                        Expanded(
                            child: CommonButton(
                                style: _isButtonEnabled(
                                        ride['tripType'], activeRidePvr)
                                    ? AppCss.lexendRegular15
                                        .textColor(appTheme.white)
                                    : AppCss.lexendRegular15
                                        .textColor(appTheme.lightText),
                                color: _isButtonEnabled(
                                        ride['tripType'], activeRidePvr)
                                    ? appTheme.primary
                                    : appTheme.bgBox,
                                onTap: _isButtonEnabled(
                                        ride['tripType'], activeRidePvr)
                                    ? () => _onCreateTripTap(
                                        ride['tripType'], activeRidePvr)
                                    : null,
                                text: _getButtonLabel(
                                    context, ride['tripType'], activeRidePvr),
                                isLoading: activeRidePvr
                                    .isLoadingForType(ride['tripType'])))
                      ]).marginOnly(top: Insets.i15, bottom: Insets.i10)
                    ])).marginOnly(bottom: Insets.i10);
              }));
    });
  }
}
