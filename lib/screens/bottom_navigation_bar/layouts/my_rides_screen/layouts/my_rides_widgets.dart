import '../../../../../config.dart';
import '../../../../../widgets/common_bg_layout.dart';
import '../../../../../widgets/common_location_layout.dart';

class MyRidesWidgets {
  Widget buildTabButton(String text, int index, screenWidth, selectedIndex,
      GestureTapCallback? onTap) {
    bool isSelected = selectedIndex == index;

    return Column(children: [
      Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: appTheme.primary.withValues(alpha: 0.04),
                        blurStyle: BlurStyle.normal,
                        offset: const Offset(0, 4),
                        blurRadius: Insets.i10)
                  ],
                  border: Border.all(
                      width: 1,
                      color: isSelected ? appTheme.primary : appTheme.bgBox),
                  color: isSelected ? appTheme.primary : appTheme.white,
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: Insets.i8, cornerSmoothing: Insets.i20)),
              child: Text(text,
                      style: AppCss.lexendRegular14.textColor(
                          isSelected ? appTheme.white : appTheme.textClr))
                  .marginSymmetric(
                      vertical: Insets.i11, horizontal: Insets.i12))
          .inkWell(onTap: onTap)
    ]);
  }

  Widget buildCommonLayout(
      {String? userName,
      String? time,
      int? price,
      String? distance,
      String? pickUpAddress,
      int? reviews,
      double? rating,
      String? droppingAddress,
      VoidCallback? onTap}) {
    return CommonBgLayout(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Container(
                            height: Insets.i50,
                            width: Insets.i50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: appTheme.borderColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Insets.i7)),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/image/home/user2.png')))),
                        HSpace(Insets.i10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              screensWidgets.userName(userName),
                              VSpace(Insets.i6),
                              screensWidgets.ratingCounting(rating, reviews)
                            ])
                      ]),
                      screensWidgets.priceText(price, topMargin: 7.0)
                    ]))
              ]),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(time!,
                style: AppCss.lexendLight12
                    .textColor(appTheme.primary)
                    .textHeight(1.3)),
            Row(children: [
              SvgPicture.asset(svgAssets.routing,
                  colorFilter:
                      ColorFilter.mode(appTheme.primary, BlendMode.srcIn)),
              HSpace(Insets.i4),
              Text(distance!,
                  style: AppCss.lexendLight12.textColor(appTheme.primary))
            ])
          ]),
          VSpace(Insets.i15),
          CommonLocationLayout(
              pickUpAddress: pickUpAddress, droppingAddress: droppingAddress)
        ]))
        .inkWell(onTap: onTap)
        .marginSymmetric(horizontal: Insets.i20, vertical: Insets.i7);
  }
}
