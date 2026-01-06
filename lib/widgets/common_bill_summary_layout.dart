import 'package:taxify_driver_ui/config.dart';

Widget billSummaryLayout(context) {
  return Consumer<RideDetailsProvider>(
      builder: (context, rideDetailsPvr, child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(language(context, appFonts.billSummary),
              style: AppCss.lexendMedium14.textColor(appTheme.primary))
          .marginOnly(left: Insets.i20, bottom: Insets.i10),
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(text: language(context, appFonts.rideFare)),
          TextWidgetCommon(
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("46")).toStringAsFixed(0)}")
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: language(context, appFonts.totalAccessFee),
              fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("4")).toStringAsFixed(0)}")
        ]).padding(vertical: Sizes.s15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: language(context, appFonts.couponSavings),
              fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              color: appColor(context).appTheme.alertZone,
              text:
                  "-${getSymbol(context)}${(currency(context).currencyVal * double.parse("11")).toStringAsFixed(0)}")
        ]),
        Divider(height: 0, color: appColor(context).appTheme.lightText)
            .padding(top: Sizes.s15, bottom: Sizes.s12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextWidgetCommon(
              text: language(context, appFonts.totalBill),
              fontWeight: FontWeight.w400),
          TextWidgetCommon(
              fontWeight: FontWeight.w400,
              color: appColor(context).appTheme.priceClr,
              text:
                  "${getSymbol(context)}${(currency(context).currencyVal * double.parse("39")).toStringAsFixed(0)}")
        ])
      ]).padding(vertical: Sizes.s20, horizontal: Insets.i20).decorated(
          image: const DecorationImage(
              image: AssetImage('assets/image/home/billSummary.png'),
              fit: BoxFit.fill)),
      rideDetailsPvr.isPaymentComplete
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(language(context, appFonts.paymentMethod),
                      style: AppCss.lexendMedium14.textColor(appTheme.primary))
                  .marginOnly(left: Insets.i20, bottom: Insets.i10),
              Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetCommon(
                          text: language(context, appFonts.paymentID)),
                      TextWidgetCommon(text: language(context, appFonts.payID))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetCommon(
                          text: language(context, appFonts.methodType),
                          fontWeight: FontWeight.w400),
                      TextWidgetCommon(text: language(context, appFonts.cash))
                    ]).padding(vertical: Sizes.s15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidgetCommon(
                          text: language(context, appFonts.status),
                          fontWeight: FontWeight.w400),
                      TextWidgetCommon(
                          fontWeight: FontWeight.w400,
                          color: appColor(context).appTheme.alertZone,
                          text: language(context, appFonts.paid))
                    ])
              ]).padding(vertical: Sizes.s20, horizontal: Insets.i20).decorated(
                  image: const DecorationImage(
                      image: AssetImage('assets/image/home/payment.png'),
                      fit: BoxFit.fitWidth))
            ]).padding(top: Insets.i20)
          : Container(),
      rideDetailsPvr.isPaymentComplete
          ? Container()
          : rideDetailsPvr.isCompleteRide
              ? Container()
              : CommonButton(
                  onTap: () => rideDetailsPvr.paymentRequest(),
                  text: language(context, appFonts.requestAPayment),
                  margin: EdgeInsets.fromLTRB(
                      Insets.i20, Insets.i30, Insets.i20, Insets.i5)),
      rideDetailsPvr.isCompleteRide
          ? Container().marginOnly(bottom: Insets.i25)
          : TextWidgetCommon(
              text: language(context, appFonts.reviewCustomer),
            )
              .center() /* CommonButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: Insets.i20,
                      vertical: rideDetailsPvr.isPaymentComplete
                          ? Insets.i20
                          : Insets.i1),
                  onTap: () => rideDetailsPvr.showBottomSheet(context),
                  color: rideDetailsPvr.isPaymentComplete
                      ? appTheme.bgBox
                      : Colors.transparent,
                  style: AppCss.lexendRegular15.textColor(appTheme.primary),
                  text: language(context, appFonts.reviewCustomer)) */
              .marginZero
    ]);
  });
}
