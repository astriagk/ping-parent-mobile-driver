import '../../../../../config.dart';
import 'my_rides_tab_inner_common_layout.dart';

class CancelRideDetailsScreen extends StatelessWidget {
  const CancelRideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyRidesTabInnerCommonLayout(
            title: 'Cancel Ride',
            body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        VSpace(Insets.i10),
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
                        VSpace(Insets.i10),
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
                          pickUpAddress: language(context, appFonts.pickUpAdd),
                          droppingAddress: language(context, appFonts.dropAdd)),
                      VSpace(Insets.i15),
                      Text(language(context, appFonts.reason),
                          style: AppCss.lexendMedium14
                              .textColor(appTheme.alertZone)),
                      VSpace(Insets.i8),
                      CommonBgLayout(
                          color: appTheme.alertZone.withValues(alpha: 0.10),
                          isBorder: false,
                          child: Text(language(context, appFonts.loremIpsum),
                              style: AppCss.lexendRegular12
                                  .textColor(appTheme.alertZone)
                                  .textHeight(1.5)))
                    ]).marginSymmetric(horizontal: Insets.i20).marginOnly(
                    top: MediaQuery.of(context).size.height * 0.37)),
            rideStatus: 'Cancel'));
  }
}
