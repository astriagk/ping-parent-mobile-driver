import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/common_divider.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final String? userName;
  final double? rating;
  final int? reviews;
  final String? distance;
  final double? amount;
  final String? pickupTime;
  final String? pickUpAddress;
  final String? dropOffAddress;
  final VoidCallback? onTap;
  final bool showActionButtons;
  final String? assignmentId;
  final String? phoneNumber;
  final Function(String)? onApprove;
  final Function(String)? onReject;
  final bool isActionLoading;

  const CustomerCard(
      {super.key,
      this.userName,
      this.rating,
      this.reviews,
      this.distance,
      this.amount,
      this.pickupTime,
      this.pickUpAddress,
      this.dropOffAddress,
      this.onTap,
      this.showActionButtons = false,
      this.assignmentId,
      this.phoneNumber,
      this.onApprove,
      this.onReject,
      this.isActionLoading = false});

  @override
  Widget build(BuildContext context) {
    return CommonBgLayout(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: Insets.i50,
                          width: Insets.i50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: appTheme.borderColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Insets.i7)),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/image/home/user2.png')))),
                      HSpace(Insets.i6),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [screensWidgets.userName(userName)]),
                            VSpace(Insets.i6),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // screensWidgets.ratingCounting(
                                  //     rating, reviews),
                                  // const CommonDivider(),
                                  SvgPicture.asset(svgAssets.routing),
                                  HSpace(Insets.i4),
                                  Text(distance!,
                                      style: AppCss.lexendRegular12
                                          .textColor(appTheme.textClr))
                                ])
                          ])
                    ]),
                // screensWidgets.priceText(amount,
                //     bottomMargin: 23.0, leftMargin: 40.0)
              ]),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(pickupTime!,
                style: AppCss.lexendLight12
                    .textColor(appTheme.primary)
                    .textHeight(1.3)),
            Row(children: [
              // CommonIconButton(
              //     onTap: () => route.pushNamed(context, routeName.chatScreen),
              //     icon: svgAssets.message,
              //     bgColor: appTheme.bgBox),
              // HSpace(Insets.i10),
              CommonIconButton(
                  onTap: () async {
                    // Request phone permission
                    PermissionStatus status = await Permission.phone.request();

                    if (status.isGranted) {
                      final Uri phoneUri =
                          Uri(scheme: 'tel', path: phoneNumber ?? '');

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
                  },
                  icon: svgAssets.call,
                  bgColor: appTheme.bgBox),
            ])
          ]),
          VSpace(Insets.i15),
          CommonLocationLayout(
              pickUpAddress: pickUpAddress, droppingAddress: dropOffAddress),
          if (showActionButtons)
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                      style: AppCss.lexendRegular14.textColor(appTheme.textClr),
                      color: appColor(context).appTheme.bgBox,
                      onTap: isActionLoading
                          ? null
                          : () => onReject?.call(assignmentId!),
                      isLoading: isActionLoading,
                      text: appFonts.reject),
                ),
                SizedBox(width: Insets.i10),
                Expanded(
                  child: CommonButton(
                      style: AppCss.lexendRegular15.textColor(appTheme.white),
                      onTap: isActionLoading
                          ? null
                          : () => onApprove?.call(assignmentId!),
                      isLoading: isActionLoading,
                      text: appFonts.approve),
                ),
              ],
            ).marginOnly(top: Insets.i15)
        ]))
        .marginSymmetric(horizontal: Insets.i20, vertical: Insets.i7)
        .inkWell(onTap: onTap);
  }
}
