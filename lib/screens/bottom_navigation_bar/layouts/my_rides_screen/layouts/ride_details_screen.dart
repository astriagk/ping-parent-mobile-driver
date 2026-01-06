import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/my_rides_tab_inner_common_layout.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/common_bill_summary_layout.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RideDetailsProvider>(
        builder: (context, rideDetailsPvr, child) {
      return Scaffold(
          body: MyRidesTabInnerCommonLayout(
              isUseWidget: rideDetailsPvr.isCompleteRide ? true : false,
              widget: SvgPicture.asset(svgAssets.import1).inkWell(onTap: () {
                rideDetailsPvr.copyAssetToFile();
              }),
              rideStatus: rideDetailsPvr.isCompleteRide
                  ? language(context, appFonts.complete)
                  : '',
              isNotHavingStatus: rideDetailsPvr.isCompleteRide ? false : true,
              title: rideDetailsPvr.isCompleteRide
                  ? language(context, appFonts.completeRide)
                  : language(context, appFonts.rideDetails),
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Divider(color: appColor(context).appTheme.stroke, height: 0)
                        .marginOnly(
                            bottom: Insets.i15,
                            right: Insets.i20,
                            left: Insets.i20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language(context, appFonts.date),
                              style: AppCss.lexendRegular12
                                  .textColor(appTheme.textClr)),
                          Row(children: [
                            Text(language(context, appFonts.bookingDate),
                                style: AppCss.lexendRegular14
                                    .textColor(appTheme.primary)),
                            Text(language(context, appFonts.bookingTime),
                                style: AppCss.lexendRegular14
                                    .textColor(appTheme.primary))
                          ])
                        ]).marginSymmetric(horizontal: Insets.i20),
                    rideDetailsPvr.isCompleteRide
                        ? Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      language(context, appFonts.tripCompleted),
                                      style: AppCss.lexendRegular12
                                          .textColor(appTheme.textClr)),
                                  Text(language(context, appFonts.bookingIDNum),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]).marginSymmetric(
                                horizontal: Insets.i20, vertical: Insets.i10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.mobileNumber),
                                      style: AppCss.lexendRegular12
                                          .textColor(appTheme.textClr)),
                                  Text(language(context, appFonts.mobNo),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]).marginSymmetric(horizontal: Insets.i20)
                          ])
                        : Container(),
                    // VSpace(Insets.i15),
                    CommonLocationLayout(
                        padding: EdgeInsets.symmetric(
                            vertical: Insets.i20, horizontal: Insets.i20),
                        color: Colors.transparent,
                        isDottedLine: false,
                        pickUpAddress: appFonts.pickUpAdd,
                        droppingAddress: appFonts.dropAdd),
                    VSpace(Insets.i10),
                    rideDetailsPvr.isCompleteRide == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(language(context, appFonts.reviews),
                                        style: AppCss.lexendMedium14
                                            .textColor(appTheme.primary))
                                    .marginOnly(
                                        left: Insets.i20, bottom: Insets.i10),
                                CommonBgLayout(
                                        padding: EdgeInsets.zero,
                                        color: appTheme.bgBox,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                      language(
                                                          context,
                                                          appFonts
                                                              .customerRatingForYou),
                                                      style: AppCss
                                                          .lexendRegular14
                                                          .textColor(
                                                              appTheme.textClr))
                                                  .marginAll(Insets.i15),
                                              Divider(
                                                  color: appColor(context)
                                                      .appTheme
                                                      .stroke,
                                                  height: 0),
                                              Column(children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(children: [
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i5),
                                                        Text(
                                                            language(
                                                                context,
                                                                appFonts
                                                                    .rating1),
                                                            style: AppCss
                                                                .lexendMedium13
                                                                .textColor(
                                                                    appTheme
                                                                        .primary))
                                                      ]),
                                                      Text(
                                                          language(context,
                                                              appFonts.minAgo),
                                                          style: AppCss
                                                              .lexendLight12
                                                              .textColor(appTheme
                                                                  .walletClr))
                                                    ]),
                                                VSpace(Insets.i10),
                                                Text(
                                                    language(context,
                                                        appFonts.theBestRide),
                                                    style: AppCss
                                                        .lexendRegular12
                                                        .textColor(appTheme
                                                            .feedbackText))
                                              ]).marginAll(Insets.i15)
                                            ]))
                                    .marginSymmetric(horizontal: Insets.i20),
                                VSpace(Insets.i20),
                                rideDetailsPvr.isDeleted != true
                                    ? CommonBgLayout(
                                        padding: EdgeInsets.zero,
                                        color: appTheme.bgBox,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        language(
                                                            context,
                                                            appFonts
                                                                .yourRatingForCustomer),
                                                        style: AppCss
                                                            .lexendRegular14
                                                            .textColor(appTheme
                                                                .textClr)),
                                                    Row(children: [
                                                      SvgPicture.asset(
                                                              svgAssets.edit)
                                                          .inkWell(
                                                              onTap: () =>
                                                                  rideDetailsPvr
                                                                      .showBottomSheet(
                                                                          context)),
                                                      HSpace(Insets.i20),
                                                      SvgPicture.asset(
                                                              svgAssets.bin)
                                                          .inkWell(onTap: () {
                                                        rideDetailsPvr
                                                            .isDeleted = true;
                                                        rideDetailsPvr
                                                            .notifyListeners();
                                                      })
                                                    ])
                                                  ]).marginAll(Insets.i15),
                                              Divider(
                                                  color: appColor(context)
                                                      .appTheme
                                                      .stroke,
                                                  height: 0),
                                              Column(children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(children: [
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i2),
                                                        SvgPicture.asset(
                                                            svgAssets.star),
                                                        HSpace(Insets.i5),
                                                        Text(
                                                            language(
                                                                context,
                                                                appFonts
                                                                    .rating1),
                                                            style: AppCss
                                                                .lexendMedium13
                                                                .textColor(
                                                                    appTheme
                                                                        .primary))
                                                      ]),
                                                      Text(
                                                          language(context,
                                                              appFonts.minAgo),
                                                          style: AppCss
                                                              .lexendLight12
                                                              .textColor(appTheme
                                                                  .walletClr))
                                                    ]),
                                                VSpace(Insets.i10),
                                                Text(
                                                    language(
                                                        context,
                                                        appFonts
                                                            .amazingExperience),
                                                    style: AppCss
                                                        .lexendRegular12
                                                        .textColor(appTheme
                                                            .feedbackText))
                                              ]).marginAll(Insets.i15)
                                            ])).marginSymmetric(
                                        horizontal: Insets.i20,
                                      )
                                    : Container()
                              ]).marginOnly(bottom: Insets.i25)
                        : Container(),
                    billSummaryLayout(context)
                  ]).marginOnly(
                      top: MediaQuery.of(context).size.height * 0.37))));
    });
  }
}
