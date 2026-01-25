import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/helper/date_time_helper.dart';
import 'package:taxify_driver_ui/api/enums/trip_type_enum.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndPrintTrips();
    });
  }

  /// Fetch and print my trips data
  Future<void> _fetchAndPrintTrips() async {
    final activeRideProvider = context.read<ActiveRideProvider>();
    final success = await activeRideProvider.fetchMyTrips();

    if (success) {
      print('=== MY TRIPS DATA ===');
      for (var trip in activeRideProvider.myTrips) {
        print('Trip ID: ${trip.tripId}');
        print('Driver ID: ${trip.driverId}');
        print('Trip Type: ${trip.tripType.value}');
        print('Trip Date: ${trip.tripDate}');
        print('Trip Status: ${trip.tripStatus}');
        print('Created At: ${trip.createdAt}');
        print('---');
      }
      print('Total Trips: ${activeRideProvider.myTrips.length}');
    } else {
      print('Error fetching trips: ${activeRideProvider.errorMessage}');
    }
  }

  /// Helper function to show SnackBar
  void _showSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidgetCommon(text: message),
        duration: duration,
      ),
    );
  }

  /// Check if a trip with the same type already exists
  bool _tripExists(TripType tripType, ActiveRideProvider activeRidePvr) {
    return activeRidePvr.myTrips.any((trip) => trip.tripType == tripType);
  }

  /// Handle button tap - either navigate to map or create trip
  Future<void> _onCreateTripTap(
      TripType tripType, ActiveRideProvider activeRidePvr) async {
    // Check if trip already exists
    if (_tripExists(tripType, activeRidePvr)) {
      print('Trip with type ${tripType.value} already exists');
      print('Navigating to pickup customer screen...');
      // Navigate to next screen if trip exists
      route.pushNamed(context, routeName.pickupCustomerScreen);
    } else {
      print('Trip with type ${tripType.value} does not exist, creating...');
      // Create new trip if it doesn't exist
      final success = await activeRidePvr.createTrip(
        tripType: tripType,
        tripDate: DateTime.now(),
      );

      if (!mounted) return;

      final message =
          success ? activeRidePvr.successMessage : activeRidePvr.errorMessage;

      if (message != null) {
        _showSnackBar(message);
      }

      // If trip created successfully, navigate to next screen
      if (success) {
        route.pushNamed(context, routeName.pickupCustomerScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ActiveRideProvider, MyRidesProvider>(
        builder: (context, activeRidePvr, myRidePvr, child) {
      return appArray.ridesData.isNotEmpty
          ? SingleChildScrollView(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  screensWidgets.userName(
                                                      ride['userName'])
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
                                        text: ride['tripType']
                                            .value
                                            .toUpperCase(),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            ride['tripType'] == TripType.pickup
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
                                      onTap: () => activeRidePvr
                                          .openDialer(ride['contact']),
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
                                    style: DateTimeHelper.isRideWithinOneHour(
                                            ride['time'])
                                        ? AppCss.lexendRegular15
                                            .textColor(appTheme.white)
                                        : AppCss.lexendRegular15
                                            .textColor(appTheme.lightText),
                                    color: DateTimeHelper.isRideWithinOneHour(
                                            ride['time'])
                                        ? appTheme.primary
                                        : appTheme.bgBox,
                                    onTap: DateTimeHelper.isRideWithinOneHour(
                                            ride['time'])
                                        ? () => _onCreateTripTap(
                                            ride['tripType'], activeRidePvr)
                                        : () {
                                            _showSnackBar(
                                              language(
                                                context,
                                                appFonts
                                                    .ridePickupWithinOneHour,
                                              ),
                                            );
                                          },
                                    text: _tripExists(
                                            ride['tripType'], activeRidePvr)
                                        ? language(context, appFonts.viewMap)
                                        : language(
                                            context, appFonts.createTrip)))
                          ]).marginOnly(top: Insets.i15, bottom: Insets.i10)
                        ])).marginOnly(bottom: Insets.i10);
                  }))
          : Center(
              child: Text(language(context, appFonts.noActiveRide),
                      style:
                          AppCss.lexendRegular16.textColor(appTheme.lightText))
                  .marginSymmetric(
                      horizontal: Insets.i20, vertical: Insets.i20));
    });
  }
}
