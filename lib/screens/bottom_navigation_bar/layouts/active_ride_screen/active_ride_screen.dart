import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/widgets/common_bg_layout.dart';
import 'package:skolo_driver/widgets/empty_state/index.dart';
import 'package:skolo_driver/api/enums/trip_type_enum.dart';
import 'package:skolo_driver/api/enums/trip_status_enum.dart';
import 'package:skolo_driver/api/models/get_my_trips_response.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen>
    with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }
    if (state == AppLifecycleState.resumed && _wasInBackground) {
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

  /// Whether the "End Trip" button should be shown for this trip type
  bool _canEndTrip(TripType tripType, ActiveRideProvider activeRidePvr) {
    final trip = _getTripForType(tripType, activeRidePvr);
    if (trip == null) return false;
    final status = TripStatus.fromString(trip.tripStatus);
    return status == TripStatus.inProgress;
  }

  Future<void> _onEndTripTap(
      TripType tripType, ActiveRideProvider activeRidePvr) async {
    final trip = _getTripForType(tripType, activeRidePvr);
    if (trip == null) return;
    await activeRidePvr.endTrip(tripType: tripType, tripId: trip.id);
    if (mounted && activeRidePvr.errorMessage != null) {
      _showSnackBar(activeRidePvr.errorMessage!);
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
          AppRoute.pickupCustomer.path,
          arg: {
            'tripId': trip.id,
            if (tripType == TripType.drop) 'isDropTrip': true,
          },
        );
      } else if (tripType == TripType.drop) {
        // For DROP trips (not in-progress), go to student selection screen
        context.read<DropStudentSelectionProvider>().setCurrentTripId(trip.id);
        await route.pushNamed(context, AppRoute.dropStudentSelection.path);
      } else {
        // For PICKUP trips, go directly to map
        await route.pushNamed(
          context,
          AppRoute.pickupCustomer.path,
          arg: {'tripId': trip.id, 'tripStatus': trip.tripStatus},
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
                .setCurrentTripId(updatedTrip.id);
            await route.pushNamed(
                context, AppRoute.dropStudentSelection.path);
          } else {
            await route.pushNamed(
              context,
              AppRoute.pickupCustomer.path,
              arg: {
                'tripId': updatedTrip.id,
                'tripStatus': updatedTrip.tripStatus
              },
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
                final isPickup = ride['tripType'] == TripType.pickup;
                final badgeColor =
                    isPickup ? appTheme.primary : appTheme.yellowIcon;
                final timeBgColor =
                    isPickup ? appTheme.yellowIcon.withValues(alpha: 0.15) : appTheme.primary.withValues(alpha: 0.08);
                final timeTextColor =
                    isPickup ? appTheme.yellowIcon : appTheme.primary;

                return CommonBgLayout(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      // Header: vehicle icon + title + time badge + trip type
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.10),
                                    borderRadius:
                                        BorderRadius.circular(Insets.i12)),
                                child: Icon(
                                    isPickup
                                        ? Icons.directions_bus_rounded
                                        : Icons.directions_car_rounded,
                                    size: 30,
                                    color: badgeColor)),
                            HSpace(Insets.i12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(ride['userName'],
                                      style: AppCss.lexendSemiBold15
                                          .textColor(appTheme.textClr)),
                                  VSpace(Insets.i6),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: timeBgColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                                isPickup
                                                    ? Icons.wb_sunny_rounded
                                                    : Icons
                                                        .nights_stay_rounded,
                                                size: 12,
                                                color: timeTextColor),
                                            HSpace(4),
                                            Text(ride['timeLabel'],
                                                style: AppCss.lexendRegular11
                                                    .textColor(timeTextColor))
                                          ]))
                                ])),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: badgeColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                    ride['tripType'].value.toUpperCase(),
                                    style: AppCss.lexendBold10.textColor(
                                        isPickup
                                            ? appTheme.white
                                            : appTheme.textClr)))
                          ]),
                      VSpace(Insets.i14),
                      homeScreenWidget.dottedLineCommon(),
                      VSpace(Insets.i12),
                      // Route direction chips
                      Row(children: [
                        _RouteChip(
                            icon: isPickup
                                ? Icons.home_rounded
                                : Icons.school_rounded,
                            label: ride['fromLabel'],
                            color: isPickup
                                ? appTheme.priceClr
                                : appTheme.primary),
                        Expanded(
                            child: Icon(Icons.arrow_forward_rounded,
                                size: 16, color: appTheme.lightText)),
                        _RouteChip(
                            icon: isPickup
                                ? Icons.school_rounded
                                : Icons.home_rounded,
                            label: ride['toLabel'],
                            color: isPickup
                                ? appTheme.primary
                                : appTheme.priceClr),
                      ]),
                      VSpace(Insets.i14),
                      if (_canEndTrip(ride['tripType'], activeRidePvr))
                        Row(children: [
                          Expanded(
                              child: CommonButton(
                                  style: AppCss.lexendRegular15
                                      .textColor(appTheme.white),
                                  color: appTheme.alertZone,
                                  onTap: () => _onEndTripTap(
                                      ride['tripType'], activeRidePvr),
                                  text: language(context, appFonts.endTrip),
                                  isLoading: activeRidePvr
                                      .isEndingForType(ride['tripType']))),
                          HSpace(Insets.i10),
                          Expanded(
                              child: CommonButton(
                                  style: AppCss.lexendRegular15
                                      .textColor(appTheme.white),
                                  color: appTheme.primary,
                                  onTap: () => _onCreateTripTap(
                                      ride['tripType'], activeRidePvr),
                                  text: _getButtonLabel(
                                      context, ride['tripType'], activeRidePvr),
                                  isLoading: activeRidePvr
                                      .isLoadingForType(ride['tripType'])))
                        ])
                      else
                        CommonButton(
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
                                .isLoadingForType(ride['tripType']))
                    ])).marginOnly(bottom: Insets.i10);
              }));
    });
  }
}

class _RouteChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _RouteChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(Insets.i8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: color),
          HSpace(Insets.i6),
          Text(label, style: AppCss.lexendMedium12.textColor(color)),
        ]));
  }
}
