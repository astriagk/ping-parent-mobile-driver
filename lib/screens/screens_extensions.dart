import '../config.dart';

extension ScreenExtensions on Widget {
  Widget authExtension(context) => Container(child: this).decorated(
      color: appColor(context).appTheme.bgBox,
      bLRadius: Sizes.s20,
      bRRadius: Sizes.s20);

  Widget notificationExtension(context, e) => Container(child: this).decorated(
          allRadius: Sizes.s10,
          color: e['isRead'] == true
              ? appColor(context).appTheme.white
              : appColor(context).appTheme.bgBox,
          sideColor: appColor(context).appTheme.bgBox,
          boxShadow: [
            BoxShadow(
                color: e['isRead'] == true
                    ? appColor(context).appTheme.primary.withValues(alpha: 0.06)
                    : appColor(context).appTheme.trans,
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0)
          ]);

  Widget offerExtension(context) {
    return Container(child: this).decorated(
        allRadius: Sizes.s10,
        color: appColor(context).appTheme.white,
        sideColor: appColor(context).appTheme.borderColor,
        boxShadow: [
          BoxShadow(
              color: appColor(context).appTheme.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0)
        ]);
  }

  Widget settingWalletExtension(context) {
    return Container(child: this)
        .paddingDirectional(vertical: Sizes.s15)
        .width(MediaQuery.of(context).size.width)
        .decorated(
            allRadius: Sizes.s10,
            image: DecorationImage(
              image: AssetImage(imageAssets.myWallet),
              fit: BoxFit.fill,
            ))
        .padding(top: Sizes.s20, bottom: Sizes.s15);
  }

/*

  Widget selectCategoryExtension(e, context) {
    return Consumer<NewLocationProvider>(builder: (context, newCtrl, child) {
      return Container(child: this).decorated(
          allRadius: Sizes.s6,
          sideColor: newCtrl.selectedOption == e.value
              ? appColor(context).appTheme.darkText
              : appColor(context).appTheme.darkText.withValues(alpha:0.15));
    });
  }
*/

  Widget saveLocationExtension(context) {
    return Container(child: this)
        .paddingDirectional(all: Sizes.s15)
        .decorated(color: appColor(context).appTheme.white, allRadius: Sizes.s8)
        .padding(horizontal: Sizes.s15, bottom: Sizes.s15);
  }

  Widget boxBorderExtension(context,
          {Color? color, bColor, double? radius, bool? isShadow = false}) =>
      Container(
          decoration: ShapeDecoration(
              color: color ?? appColor(context).appTheme.white,
              shadows: isShadow == true
                  ? [
                      BoxShadow(
                          color: appColor(context)
                              .appTheme
                              .darkText
                              .withValues(alpha: 0.06),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2))
                    ]
                  : [],
              shape: SmoothRectangleBorder(
                  side: BorderSide(
                      color: bColor ?? appColor(context).appTheme.stroke),
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: radius ?? 8, cornerSmoothing: 1))),
          child: this);

  Widget chatAppBarExtension(context) => Container(child: this)
      .paddingDirectional(
          horizontal: Sizes.s20,
          top: MediaQuery.of(context).padding.top + Insets.i12)
      .paddingDirectional(bottom: Insets.i12)
      .decorated(
          bLRadius: AppRadius.r20,
          bRRadius: AppRadius.r20,
          sideColor: appColor(context).appTheme.stroke,
          color: appColor(context).appTheme.bgBox);

  Widget boxShapeExtension(
          {Color? color, double? radius, Color? borderColor, context}) =>
      Container(
          decoration: ShapeDecoration(
              color: color,
              shadows: [
                BoxShadow(
                    color: appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: 0.06),
                    blurRadius: 20,
                    spreadRadius: 4)
              ],
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: radius ?? 8, cornerSmoothing: 1),
                  side: BorderSide(color: borderColor ?? Colors.transparent))),
          child: this);

  Widget backButtonBorderExtension(context) => Container(child: this).decorated(
      color: appColor(context).appTheme.white,
      sideColor: appColor(context).appTheme.stroke,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 4)
      ],
      allRadius: Sizes.s20);

  Widget offerFareExtension(context) =>
      Container(child: this).width(MediaQuery.of(context).size.width).decorated(
          color: appColor(context).appTheme.white,
          tRRadius: Sizes.s20,
          tLRadius: Sizes.s20);

  Widget riderScreenBg(context) => Container(child: this)
      .width(MediaQuery.of(context).size.width)
      .padding(top: Sizes.s25)
      .decorated(
          tLRadius: Sizes.s20,
          tRRadius: Sizes.s20,
          color: appColor(context).appTheme.bgBox);

  Widget freightImageExtension(context) => Container(child: this)
      .paddingDirectional(all: Sizes.s10)
      .height(Sizes.s102)
      .width(MediaQuery.of(context).size.width)
      .decorated(allRadius: Sizes.s6, color: appColor(context).appTheme.bgBox);

  Widget cancelRideButton(context, {Color? color}) =>
      Container(child: this).height(Sizes.s46).decorated(
          allRadius: Sizes.s9,
          color: color ?? appColor(context).appTheme.primary);

  Widget cancelMainListExtension(context) => Container(child: this)
      .paddingDirectional(all: Sizes.s12)
      .decorated(color: appColor(context).appTheme.white, allRadius: Sizes.s10)
      .padding(bottom: Sizes.s12);

  Widget findingExtension(context) => Container(child: this)
      .paddingDirectional(all: Sizes.s15)
      .decorated(color: appColor(context).appTheme.bgBox, allRadius: Sizes.s6)
      .padding(horizontal: Sizes.s20);

  Widget findingListExtension(context) => Container(child: this)
          .paddingDirectional(all: Sizes.s12)
          .decorated(boxShadow: [
        BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            spreadRadius: 7)
      ], color: appColor(context).appTheme.white, allRadius: Sizes.s10).padding(
              bottom: Sizes.s12);

  Widget rentalScreenExtension(context) =>
      Container(child: this).width(MediaQuery.of(context).size.width).decorated(
          tLRadius: Sizes.s20,
          tRRadius: Sizes.s20,
          color: appColor(context).appTheme.white);

  Widget reviewExtension(context) => Container(child: this)
      .paddingDirectional(
          horizontal: Sizes.s10, top: Sizes.s10, bottom: Sizes.s11)
      .decorated(color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8);

  Widget carDetailsExtension(context) => Container(child: this)
      .paddingDirectional(all: Sizes.s15)
      .decorated(color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8)
      .padding(top: Sizes.s25, bottom: Sizes.s20);

  Widget commonBgBox(context) => Container(child: this)
      .decorated(color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8);

  Widget myRideListExtension(context) => Container(child: this)
          .paddingDirectional(horizontal: Sizes.s15, vertical: Sizes.s15)
          .decorated(
              boxShadow: [
            BoxShadow(
                color:
                    appColor(context).appTheme.primary.withValues(alpha: 0.03),
                blurRadius: 12,
                spreadRadius: 4)
          ],
              color: appColor(context).appTheme.white,
              sideColor: appColor(context).appTheme.bgBox,
              allRadius:
                  Sizes.s10).padding(horizontal: Sizes.s20, bottom: Sizes.s15);

  Widget rideAppBarExtension(context) => Container(child: this)
      .paddingDirectional(
          horizontal: Sizes.s20,
          top: MediaQuery.of(context).padding.top + Sizes.s15,
          bottom: Sizes.s25)
      .decorated(
          color: appColor(context).appTheme.bgBox,
          bLRadius: Sizes.s20,
          bRRadius: Sizes.s20);
}
