import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/my_rides_tab_inner_common_layout.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';

class PendingRideDetailsScreen extends StatelessWidget {
  const PendingRideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyRidesTabInnerCommonLayout(
            title: language(context, appFonts.pendingRide),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text(language(context, appFonts.paymentMethod1)),
                  Text(language(context, appFonts.cash))
                ]),
                Text(language(context, appFonts.amount),
                    style: AppCss.lexendRegular16.textColor(appTheme.priceClr))
              ]),
              VSpace(Insets.i6),
              Text(language(context, appFonts.theTotalOf),
                  style: AppCss.lexendMedium12.textColor(appTheme.textClr)),
              Divider(color: appTheme.stroke)
                  .marginSymmetric(vertical: Insets.i10),
              Column(children: [
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
                    ]),
                VSpace(Insets.i8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, appFonts.bookingID),
                          style: AppCss.lexendRegular12
                              .textColor(appTheme.textClr)),
                      Text(language(context, appFonts.bookingIDNum),
                          style: AppCss.lexendRegular14
                              .textColor(appTheme.primary))
                    ]),
                VSpace(Insets.i8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, appFonts.mobileNumber),
                          style: AppCss.lexendRegular12
                              .textColor(appTheme.textClr)),
                      Text(language(context, appFonts.mobNo),
                          style: AppCss.lexendRegular14
                              .textColor(appTheme.primary))
                    ])
              ]),
              VSpace(Insets.i20),
              CommonLocationLayout(
                  pickUpAddress: appFonts.pickUpAdd,
                  droppingAddress: appFonts.dropAdd)
            ])
                    .marginSymmetric(horizontal: Insets.i20)
                    .marginOnly(top: MediaQuery.of(context).size.height * 0.35),
            rideStatus: appFonts.pending));
  }
}
