import 'dart:async';

import 'package:gif/gif.dart';
import 'package:taxify_driver_ui/common/maps/map_config.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/maps/index.dart';
import 'package:taxify_driver_ui/provider/bottom_bar_provider/pick_up_customer_provider.dart';
import 'layout/on_the_way_sheet.dart';
import 'layout/otp_verification_sheet.dart';

class PickUpCustomerScreen extends StatefulWidget {
  const PickUpCustomerScreen({super.key});

  @override
  State<PickUpCustomerScreen> createState() => _PickUpCustomerScreenState();
}

class _PickUpCustomerScreenState extends State<PickUpCustomerScreen>
    with TickerProviderStateMixin {
  bool _latLongFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTripLatLongOnce();
  }

  Future<void> _fetchTripLatLongOnce() async {
    if (_latLongFetched) return;
    _latLongFetched = true;
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

        // Call the API using PickUpCustomerProvider
        final pickUpProvider = PickUpCustomerProvider();
        final success = await pickUpProvider.fetchOptimizedRoute(
          tripId: tripId,
          currentLatitude: lat,
          currentLongitude: lng,
        );

        if (success) {
          // Route fetched successfully
        } else {
          // Error fetching route
        }
      } catch (e) {
        // Error fetching location and route
      }
    }
  }

  // bool showStartTripButton = true;
  bool isOtpVerify = false;
  bool showGif = false;
  bool isRideComplete = false;
  bool isPickedUpCustomerClick = false;
  bool isOtp = false;

  @override
  void initState() {
    super.initState();
    rideStart();
  }

  rideStart() {
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

  void startDismissOtpSuccess() {
    Timer(const Duration(seconds: 3), () {
      if (isOtp) {
        // Make sure the timer runs only when isAccepted is true
        setState(() {
          showGif = false;
        });

        isRideCompleted();
      }
    });
  }

  isRideCompleted() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isRideComplete = true;
      });
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
          body: Stack(children: [
            MapWidget(
              config: config,
              tileLayerBuilder: (urlTemplate) => MapTileLayer(
                urlTemplate: urlTemplate,
              ),
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
                        : OtpVerificationSheet(onTap: () => otpSuccess())

                    // start trip button
                    : CommonButton(
                            margin:
                                EdgeInsets.symmetric(horizontal: Insets.i20),
                            onTap: () {
                              setState(() {
                                isPickedUpCustomerClick = true;
                              });
                            },
                            text: language(context, appFonts.startTrip))
                        .marginOnly(bottom: Insets.i20))
          ]));
    });
  }
}
