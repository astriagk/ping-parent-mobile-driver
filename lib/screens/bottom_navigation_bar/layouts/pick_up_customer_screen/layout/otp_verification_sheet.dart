import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/config/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OtpVerificationSheet extends StatelessWidget {
  final GestureTapCallback? onTap;
  final RouteWaypoint? waypoint;
  final VoidCallback? onEndTrip;

  const OtpVerificationSheet(
      {super.key, this.onTap, this.waypoint, this.onEndTrip});

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
                Text(language(context, appFonts.nextRide),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset('assets/image/home/car.png', height: 25)
              ]),
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              Row(children: [
                // TODO: Replace with dummy image if null
                CircleAvatar(
                    backgroundImage: waypoint?.studentImage != null
                        ? NetworkImage(waypoint!.studentImage!)
                        : AssetImage('assets/image/home/user2.png')
                            as ImageProvider,
                    radius: 20),
                SizedBox(width: Insets.i8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      waypoint?.studentParentId ==
                              AppConstants.schoolLocationType
                          ? 'School'
                          : waypoint?.parentName ?? '',
                      style:
                          AppCss.lexendRegular14.textColor(appTheme.primary)),
                  VSpace(Insets.i4),
                  Text(waypoint?.studentNames.join(', ') ?? '',
                      style:
                          AppCss.lexendRegular12.textColor(appTheme.textClr)),
                ]),
                Spacer(),
                // TODO: Enable chat functionality once we are ready
                // CommonIconButton(
                //     onTap: () => route.pushNamed(context, routeName.chatScreen),
                //     icon: svgAssets.message,
                //     bgColor: appTheme.bgBox),
                // SizedBox(width: Insets.i12),
                if (waypoint?.studentParentId !=
                    AppConstants.schoolLocationType)
                  CommonIconButton(
                      bgColor: appTheme.bgBox,
                      icon: svgAssets.call,
                      onTap: () async {
                        // Request phone permission
                        PermissionStatus status =
                            await Permission.phone.request();

                        if (status.isGranted) {
                          final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: waypoint?.parentPhoneNumber ?? '');

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
              if (waypoint?.studentParentId == AppConstants.schoolLocationType)
                Row(children: [
                  Expanded(
                    child: CommonButton(
                        text: language(context, appFonts.completeRide),
                        onTap: onTap),
                  ),
                  SizedBox(width: Insets.i12),
                  SizedBox(
                    width: 80,
                    child: CommonButton(
                        text: 'End',
                        color: appTheme.alertZone,
                        onTap: onEndTrip),
                  ),
                ])
              else
                Column(mainAxisSize: MainAxisSize.min, children: [
                  AuthCommonWidgets().textAndTextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      language(context, appFonts.oTPVerification),
                      language(context, appFonts.enterOtp),
                      context,
                      fieldBgColor: appTheme.bgBox),
                  VSpace(Insets.i25),
                  Row(children: [
                    Expanded(
                      child: CommonButton(
                          text: language(context, appFonts.verifyOTP),
                          onTap: onTap),
                    ),
                    SizedBox(width: Insets.i12),
                    SizedBox(
                      width: 80,
                      child: CommonButton(
                          text: 'End',
                          color: appTheme.alertZone,
                          onTap: onEndTrip),
                    ),
                  ])
                ])
            ]));
  }
}
