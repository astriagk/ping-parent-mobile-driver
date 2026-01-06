import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';

class ActiveRideScreen extends StatelessWidget {
  const ActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ActiveRideProvider, MyRidesProvider>(
        builder: (context, activeRidePvr, myRidePvr, child) {
      return appArray.ridesData.isNotEmpty
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: appArray.ridesData.length,
              itemBuilder: (context, index) {
                final ride = appArray.ridesData[index];
                return SingleChildScrollView(
                    child: CommonBgLayout(
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
                                  screensWidgets.userProfileImage(),
                                  HSpace(Insets.i10),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              screensWidgets
                                                  .userName(ride['userName'])
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
                                  screensWidgets.priceText(ride['price'],
                                      bottomMargin: 23.0)
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
                                  onTap: () =>
                                      activeRidePvr.openDialer(ride['contact']),
                                  icon: svgAssets.call,
                                  bgColor: appTheme.bgBox)
                            ])
                          ]),
                      VSpace(Insets.i15),
                      CommonLocationLayout(
                          pickUpAddress: ride['pickUpAddress'],
                          droppingAddress: ride['droppingAddress']),
                      Row(children: [
                        Expanded(
                            child: CommonButton(
                                onTap: () =>
                                    activeRidePvr.cancelRideTap(context, index),
                                style: AppCss.lexendLight15
                                    .textColor(appTheme.textClr),
                                color: appTheme.bgBox,
                                text: language(context, appFonts.cancelRide))),
                        HSpace(Insets.i10),
                        Expanded(
                            child: CommonButton(
                                style: AppCss.lexendRegular15
                                    .textColor(appTheme.white),
                                onTap: () {
                                  myRidePvr.determinePosition().then((value) {
                                    route.pushNamed(context,
                                        routeName.pickupCustomerScreen);
                                  });
                                },
                                text: language(context, appFonts.viewMap)))
                      ]).marginOnly(top: Insets.i15)
                    ])).marginOnly(bottom: Insets.i10));
              }).marginSymmetric(horizontal: Insets.i20, vertical: Insets.i20)
          : Text(language(context, appFonts.noActiveRide),
                  style: AppCss.lexendRegular16.textColor(appTheme.lightText))
              .marginOnly(top: MediaQuery.of(context).size.height * 0.35);
    });
  }
}
