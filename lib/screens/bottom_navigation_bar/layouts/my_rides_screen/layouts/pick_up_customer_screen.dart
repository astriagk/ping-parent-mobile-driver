import 'dart:async';
import 'dart:developer';

import 'package:gif/gif.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_back_button1.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/common_divider.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../widgets/common_confirmation_dialog.dart';

class PickUpCustomerScreen extends StatefulWidget {
  const PickUpCustomerScreen({super.key});

  @override
  State<PickUpCustomerScreen> createState() => _PickUpCustomerScreenState();
}

class _PickUpCustomerScreenState extends State<PickUpCustomerScreen>
    with TickerProviderStateMixin {
  bool showPickupButton = false;

  @override
  void initState() {
    super.initState();
    customPickMarker();
    rideStart();
    super.initState();
    // getRoutePolyline();
  }

  rideStart() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        showGif = false;
      });
    });
  }

  bool isPickedUpCustomerClick = false;

  late GoogleMapController mapController;
  bool isMapLoading = true;
  int value = 266;

  // Function to increment the value by 10
  void incrementValue() {
    setState(() {
      value += 10;
    });
  }

  // Function to decrement the value by 10
  void decrementValue() {
    setState(() {
      value -= 10;
    });
  }

  // Define pickup and drop-off locations
  final LatLng pickupLocation = const LatLng(37.7749, -122.4194);
  final LatLng dropOffLocation = const LatLng(37.7849, -122.4094);

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  // BitmapDescriptor customIcon1 = BitmapDescriptor.defaultMarker;

  void customPickMarker() {
    setState(() {});
    BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(15, 15)), svgAssets.marker)
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
    /*BitmapDescriptor.asset(const ImageConfiguration(size: Size(15, 15)),
            "assets/svg/home/Group 1000003073.svg")
        .then((icon) {
      setState(() {
        log("adkasjf $icon");
        log("customIcon $customIcon1");
        customIcon1 = icon;
      });
    });*/
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      isMapLoading = false;
    });
  }

  /* Future<void> getRoutePolyline() async {
    const String apiKey = 'AIzaSyA8TmZCuqpQELfh9OOceElF68LUdRcpSvQ';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickupLocation.latitude},${pickupLocation.longitude}&destination=${dropoffLocation.latitude},${dropoffLocation.longitude}&key=$apiKey';

    log('url $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final List<LatLng> polylinePoints =
            decodePolyline(data['routes'][0]['overview_polyline']['points']);

        setState(() {
          polyLines = {
            Polyline(
                polylineId: const PolylineId('route'),
                points: polylinePoints,
                color: Colors.blue,
                width: 5)
          };
        });
      } else {
        log('Error fetching directions: ${data['status']}');
      }
    } else {
      log('Failed to fetch directions');
    }
  }*/

  void acceptRide() {
    setState(() {
      isAccepted = true;
      showPickupButton = false;
    });
    startDismissTimer();
  }

  bool isOtp = false;

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

  void startDismissTimer() {
    isHavingAppBar = true;
    Timer(const Duration(seconds: 2), () {
      if (isAccepted) {
        // Make sure the timer runs only when isAccepted is true
        setState(() {
          showPickupButton = true;
          isHavingAppBar = false;
        });
      }
    });
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // bool isSheetVisible = false;

  void setPolyline() {
    setState(() {
      polyLines = {
        Polyline(
            polylineId: const PolylineId('distance_line'),
            points: [pickupLocation, dropOffLocation],
            color: Colors.blue,
            width: 5)
      };
    });
  }

  int fps = 30;
  Set<Polyline> polyLines = {};
  bool isAccepted = false;
  bool isConfirmed = false;
  bool isOtpVerify = false;
  bool showGif = false;
  bool isRideComplete = false;
  bool isHavingAppBar = false;

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
      return Scaffold(
          body: Stack(children: [
        GoogleMap(
            polylines: polyLines,
            buildingsEnabled: true,
            compassEnabled: true,
            initialCameraPosition:
                CameraPosition(target: pickupLocation, zoom: 14),
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                  markerId: const MarkerId('pickup'),
                  position: pickupLocation,
                  infoWindow: const InfoWindow(title: 'Pickup Location'),
                  icon: customIcon)
            },
            zoomControlsEnabled: false,
            mapType: MapType.normal),
        isHavingAppBar
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
                height: 100,
                decoration: BoxDecoration(
                    color: appTheme.white,
                    borderRadius: SmoothBorderRadius(cornerRadius: 20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonIconButton(
                          onTap: () => route.pop(context),
                          bgColor: appTheme.bgBox,
                          icon: svgAssets.back),
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomConfirmationDialog(
                                      message:
                                          "Are you sure you want to cancel your ride?",
                                      onConfirm: () {
                                        route.pop(context);
                                        route.pop(context);
                                      },
                                      onCancel: () => route.pop(context));
                                });
                          },
                          child: Text(language(context, appFonts.cancelRide),
                              style: AppCss.lexendMedium14
                                  .textColor(appTheme.primary)))
                    ]))
            : Positioned(
                top: 50,
                left: 20,
                child: CommonIconButton1(
                    onTap: () => route.pop(context), icon: svgAssets.back)),
        isHavingAppBar
            ? Positioned(
                top: 350,
                right: 15,
                child: CommonIconButton(
                    icon: svgAssets.gps1,
                    onTap: () async => await myRidesPvr.determinePosition()))
            : Container(),
        isAccepted == true
            ? Positioned(
                bottom: showPickupButton
                    ? isPickedUpCustomerClick == true
                        ? 0
                        : 30
                    : 0,
                left: 0,
                right: 0,
                child: showPickupButton
                    ? isPickedUpCustomerClick == true
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
                            : OtpVerificationSheet(onTap: () => otpSuccess())
                        : CommonButton(
                            margin:
                                EdgeInsets.symmetric(horizontal: Insets.i20),
                            onTap: () {
                              setState(() {
                                isPickedUpCustomerClick = true;
                              });
                            },
                            text: language(context, appFonts.pickupCustomer))
                    : RideBottomSheetContent())
            : Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CommonBgLayout(
                    cornerRadius: Insets.i20,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidgetCommon(
                              text: language(context, appFonts.offerYourFare)),
                          VSpace(Insets.i10),
                          Row(children: [
                            GestureDetector(
                                onTap: () => decrementValue(),
                                child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: appTheme.bgBox,
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 6)),
                                    child: Text(
                                        language(
                                            context, appFonts.valueDecrease),
                                        style: AppCss.lexendMedium14
                                            .textColor(appTheme.primary)))),
                            HSpace(Insets.i12),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    decoration: BoxDecoration(
                                        color: appTheme.bgBox,
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 6)),
                                    child: Text('\$$value',
                                        style: AppCss.lexendSemiBold16
                                            .textColor(appTheme.priceClr)))),
                            HSpace(Insets.i12),
                            GestureDetector(
                                onTap: () => incrementValue(),
                                child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: appTheme.bgBox,
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 6)),
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                        language(
                                            context, appFonts.valueIncrease),
                                        style: AppCss.lexendMedium14
                                            .textColor(appTheme.primary))))
                          ]),
                          VSpace(Insets.i25),
                          CommonButton(
                              width: Insets.i50,
                              height: Insets.i50,
                              onTap: () => acceptRide(),
                              text:
                                  '${language(context, appFonts.acceptFare)} \$$value')
                        ]))),
        isAccepted
            ? Container()
            : Positioned(
                bottom: 205,
                left: 0,
                right: 0,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Insets.i20),
                    padding: EdgeInsets.all(Insets.i15),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: appTheme.primary.withValues(alpha: 0.06),
                              offset: const Offset(0, 4),
                              blurRadius: Insets.i20,
                              blurStyle: BlurStyle.normal)
                        ],
                        color: appTheme.white,
                        border:
                            Border.all(width: Insets.i1, color: appTheme.bgBox),
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: Insets.i10,
                            cornerSmoothing: Insets.i20)),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                  height: Insets.i25,
                                  width: Insets.i25,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/image/home/user.png')))),
                              HSpace(Insets.i6),
                              Text(
                                  language(context, appFonts.johnsonSmithkover),
                                  style: AppCss.lexendRegular12
                                      .textColor(appTheme.primary))
                            ]),
                            Row(children: [
                              SvgPicture.asset(svgAssets.star),
                              HSpace(Insets.i1),
                              Text(language(context, appFonts.rating2),
                                  style: AppCss.lexendRegular12
                                      .textColor(appTheme.primary)),
                              HSpace(Insets.i10),
                              CommonDivider(height: Insets.i16),
                              HSpace(Insets.i10),
                              Text(language(context, appFonts.amount1),
                                  style: AppCss.lexendMedium16
                                      .textColor(appTheme.priceClr))
                            ])
                          ]),
                      VSpace(Insets.i16),
                      homeScreenWidget.dottedLineCommon(),
                      VSpace(Insets.i15),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SvgPicture.asset(
                                  height: Insets.i15,
                                  width: Insets.i15,
                                  svgAssets.location),
                              HSpace(Insets.i2),
                              Text(language(context, appFonts.km),
                                  style: AppCss.lexendRegular12
                                      .textColor(appTheme.primary)
                                      .textHeight(1.3))
                            ]),
                            Text(language(context, appFonts.timeAndDate),
                                style: AppCss.lexendRegular12
                                    .textColor(appTheme.textClr))
                          ]),
                      VSpace(Insets.i15),
                      CommonLocationLayout(
                          pickUpAddress: language(context, appFonts.pickUpAdd1),
                          droppingAddress: language(context, appFonts.dropAdd1))
                    ])))
      ]));
    });
  }
}

class OnTheWaySheet extends StatelessWidget {
  GestureTapCallback? onTap;
  bool? isRideComplete;

  OnTheWaySheet({super.key, this.onTap, this.isRideComplete = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.onTheWay),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset('assets/image/home/car.png', height: Insets.i25)
              ]),
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              Row(children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/image/home/user2.png'),
                    radius: 20),
                SizedBox(width: Insets.i8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(language(context, appFonts.peterThornton),
                      style:
                          AppCss.lexendRegular14.textColor(appTheme.primary)),
                  Row(children: [
                    SvgPicture.asset(svgAssets.star),
                    SizedBox(width: Insets.i4),
                    Text(language(context, appFonts.rating3),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.primary)),
                    Text(language(context, appFonts.reviewTotal),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.textClr))
                  ])
                ]),
                Spacer(),
                CommonIconButton(
                    onTap: () => route.pushNamed(context, routeName.chatScreen),
                    icon: svgAssets.message,
                    bgColor: appTheme.bgBox),
                SizedBox(width: Insets.i12),
                CommonIconButton(
                    bgColor: appTheme.bgBox,
                    icon: svgAssets.call,
                    onTap: () => openDialer(appFonts.phoneNum))
              ]),
              VSpace(Insets.i25),
              CommonButton(
                  textColor: isRideComplete == true
                      ? appTheme.white
                      : appTheme.textClr,
                  text: language(context, appFonts.completeRide),
                  onTap: onTap,
                  color: isRideComplete == true
                      ? appTheme.primary
                      : appTheme.stroke)
            ]));
  }

  Future<void> openDialer(String phoneNumber) async {
    // Request phone permission
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      // Try to launch the dialer
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        log("Could not open dialer");
      }
    } else if (status.isDenied) {
      log("Phone permission denied");
    } else if (status.isPermanentlyDenied) {
      log("Phone permission permanently denied, open app settings.");
      openAppSettings();
    }
  }
}

class OtpVerificationSheet extends StatelessWidget {
  final GestureTapCallback? onTap;

  const OtpVerificationSheet({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.yourRideIsConfirmed),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset('assets/image/home/car.png', height: 25)
              ]),
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              Row(children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/image/home/user2.png'),
                    radius: 20),
                SizedBox(width: Insets.i8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(language(context, appFonts.peterThornton),
                      style:
                          AppCss.lexendRegular14.textColor(appTheme.primary)),
                  Row(children: [
                    SvgPicture.asset(svgAssets.star),
                    SizedBox(width: Insets.i4),
                    Text(language(context, appFonts.rating3),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.primary)),
                    Text(language(context, appFonts.reviewTotal),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.textClr))
                  ])
                ]),
                Spacer(),
                CommonIconButton(
                    onTap: () => route.pushNamed(context, routeName.chatScreen),
                    icon: svgAssets.message,
                    bgColor: appTheme.bgBox),
                SizedBox(width: Insets.i12),
                CommonIconButton(
                    bgColor: appTheme.bgBox,
                    icon: svgAssets.call,
                    onTap: () async {
                      // Request phone permission
                      PermissionStatus status =
                          await Permission.phone.request();

                      if (status.isGranted) {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: appFonts.phoneNum);

                        // Try to launch the dialer
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          log("Could not open dialer");
                        }
                      } else if (status.isDenied) {
                        log("Phone permission denied");
                      } else if (status.isPermanentlyDenied) {
                        log("Phone permission permanently denied, open app settings.");
                        openAppSettings();
                      }
                    })
              ]),
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              AuthCommonWidgets().textAndTextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  language(context, appFonts.oTPVerification),
                  language(context, appFonts.enterOtp),
                  context,
                  fieldBgColor: appTheme.bgBox),
              VSpace(Insets.i25),
              CommonButton(
                  text: language(context, appFonts.verifyOTP), onTap: onTap)
            ]));
  }
}

class RideBottomSheetContent extends StatelessWidget {
  const RideBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(Insets.i20))),
        padding: EdgeInsets.all(Insets.i20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.yourRideIsConfirmed),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset('assets/image/home/car.png', height: 25)
              ]),
              Divider(color: appTheme.stroke),
              SizedBox(height: Insets.i8),
              Row(children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/image/home/user2.png'),
                    radius: AppRadius.r20),
                SizedBox(width: Insets.i8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(language(context, appFonts.peterThornton),
                      style:
                          AppCss.lexendRegular14.textColor(appTheme.primary)),
                  Row(children: [
                    SvgPicture.asset(svgAssets.star),
                    SizedBox(width: Insets.i4),
                    Text(language(context, appFonts.rating3),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.primary)),
                    Text(language(context, appFonts.reviewTotal),
                        style:
                            AppCss.lexendRegular12.textColor(appTheme.textClr))
                  ])
                ]),
                const Spacer(),
                CommonIconButton(
                    onTap: () => route.pushNamed(context, routeName.chatScreen),
                    icon: svgAssets.message,
                    bgColor: appTheme.bgBox),
                SizedBox(width: Insets.i12),
                CommonIconButton(
                    bgColor: appTheme.bgBox,
                    icon: svgAssets.call,
                    onTap: () async {
                      // Request phone permission
                      PermissionStatus status =
                          await Permission.phone.request();

                      if (status.isGranted) {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: appFonts.phoneNum);

                        // Try to launch the dialer
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          log("Could not open dialer");
                        }
                      } else if (status.isDenied) {
                        log("Phone permission denied");
                      } else if (status.isPermanentlyDenied) {
                        log("Phone permission permanently denied, open app settings.");
                        openAppSettings();
                      }
                    })
              ]),
              VSpace(Insets.i25),
              CommonLocationLayout(
                  isHavingDuration: true,
                  index: 13,
                  isDottedLine: false,
                  pickUpAddress: appFonts.dropAdd,
                  droppingAddress: appFonts.dropAdd),
              VSpace(Insets.i15),
              CommonBgLayout(
                  padding: EdgeInsets.zero,
                  color: appTheme.bgBox,
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language(context, appFonts.totalFare),
                              style: AppCss.lexendMedium16
                                  .textColor(appTheme.primary)),
                          Text(language(context, appFonts.amount2),
                              style: AppCss.lexendSemiBold16
                                  .textColor(appTheme.primary))
                        ]).marginOnly(
                        top: Insets.i12, right: Insets.i12, left: Insets.i12),
                    Divider(color: appTheme.stroke),
                    Row(children: [
                      SvgPicture.asset(svgAssets.dollarSquare),
                      HSpace(Insets.i8),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language(context, appFonts.cash),
                                style: AppCss.lexendRegular14
                                    .textColor(appTheme.primary)),
                            Text(language(context, appFonts.payWhenTheRideEnd),
                                style: AppCss.lexendLight12
                                    .textColor(appTheme.textClr))
                          ])
                    ]).marginSymmetric(
                        horizontal: Insets.i12, vertical: Insets.i12)
                  ]))
            ]));
  }
}
