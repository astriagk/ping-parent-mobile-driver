import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class RideBottomSheetContent extends StatelessWidget {
  final VoidCallback? onAcceptRide;

  const RideBottomSheetContent({super.key, this.onAcceptRide});

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
                  ])),
              VSpace(Insets.i25),
              CommonButton(
                  margin: EdgeInsets.symmetric(horizontal: Insets.i20),
                  onTap: onAcceptRide,
                  text: language(context, appFonts.acceptFare))
            ]));
  }
}
