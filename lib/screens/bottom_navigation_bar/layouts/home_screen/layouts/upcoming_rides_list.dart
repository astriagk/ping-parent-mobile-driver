import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/home_screen/layouts/common_upcoming_ride_layout.dart';

import '../../../../../config.dart';

class UpcomingRidesList extends StatelessWidget {
  const UpcomingRidesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRidesProvider>(builder: (context, myRidePvr, child) {
      return Column(children: [
        Container(
                decoration: BoxDecoration(
                    borderRadius: SmoothBorderRadius(cornerRadius: Insets.i8),
                    color: appTheme.bgBox),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language(context, appFonts.newUpcomingRide),
                              style: AppCss.lexendBold16
                                  .textColor(appTheme.primary))
                          .padding(top: Insets.i5, bottom: Insets.i12),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: appArray.rides.length,
                          itemBuilder: (context, index) {
                            return CommonUpcomingRideLayout(
                                onTap: () {
                                  myRidePvr.determinePosition().then((value) {
                                    route.pushNamed(context,
                                        routeName.pickupCustomerScreen);
                                  });
                                },
                                rideInfo: appArray.rides[index]);
                          })
                    ]).marginSymmetric(
                    horizontal: Insets.i20, vertical: Insets.i5))
            .marginSymmetric(vertical: Insets.i20)
      ]);
    });
  }
}
