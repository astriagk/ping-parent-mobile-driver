import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:skolo_driver/config.dart' hide Marker, Polyline, LatLng;
import 'package:url_launcher/url_launcher.dart';

class OnTheWaySheet extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool? isRideComplete;
  final bool? isLastWaypoint;

  const OnTheWaySheet({
    super.key,
    this.onTap,
    this.isRideComplete = false,
    this.isLastWaypoint = false,
  });

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
                    onTap: () => route.pushNamed(context, AppRoute.chat.path),
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
                  text: _getButtonLabel(context),
                  onTap: onTap,
                  color: isRideComplete == true
                      ? appTheme.primary
                      : appTheme.stroke)
            ]));
  }

  /// Get dynamic button label based on waypoint context
  /// Shows "Complete Trip" for last waypoint, "Continue" for others
  String _getButtonLabel(BuildContext context) {
    if (isLastWaypoint == true) {
      return language(context, appFonts.completeTrip);
    }
    return language(context, appFonts.continueRide);
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
