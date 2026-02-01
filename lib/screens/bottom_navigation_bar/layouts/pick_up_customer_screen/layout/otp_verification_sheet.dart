import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:url_launcher/url_launcher.dart';

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
                Text(language(context, appFonts.nextRide),
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
