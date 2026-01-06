import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';

import '../../../config.dart';

class OfferListScreen extends StatelessWidget {
  const OfferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferListProvider>(builder: (context, promoCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => promoCtrl.init()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  title: language(context, appFonts.offerList),
                  titleWidth: MediaQuery.of(context).size.width * 0.01,
                  icon: true,
                  onTap: () =>
                      route.pushNamed(context, routeName.createOfferScreen)),
              body: ListView.builder(
                  padding: EdgeInsets.all(Insets.i8),
                  itemCount: appArray.offersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final offer = appArray.offersList[index];
                    return OfferCard1(
                        discount: offer["discount"],
                        description: offer["description"],
                        carType: offer["carType"],
                        capacity: offer["capacity"],
                        validTill: offer["validTill"],
                        isActive: offer["isActive"],
                        onTapSwitch: (bool newIsActive) =>
                            promoCtrl.updateIsActive(index, newIsActive),
                        onDeleteTap: () => promoCtrl.deleteOffer(index),
                        onEditTap: () => route.pushNamed(
                            context, routeName.createOfferScreen));
                  }).marginSymmetric(vertical: Insets.i10)));
    });
  }
}

class OfferCard1 extends StatelessWidget {
  final String discount;
  final String description;
  final String carType;
  final String capacity;
  final String validTill;
  final bool isActive;
  final ValueChanged<bool>? onTapSwitch;
  final GestureTapCallback? onEditTap, onDeleteTap;

  const OfferCard1(
      {super.key,
      required this.discount,
      required this.description,
      required this.carType,
      required this.capacity,
      required this.validTill,
      required this.isActive,
      required this.onTapSwitch,
      required this.onEditTap,
      required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferListProvider>(builder: (context, promoCtrl, child) {
      return CommonBgLayout(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Text(language(context, discount),
                  style: AppCss.lexendSemiBold16)),
          CommonIconButton(
              bgColor: appTheme.bgBox, icon: svgAssets.edit1, onTap: onEditTap),
          HSpace(Insets.i10),
          CommonIconButton(
              bgColor: appTheme.alertZone.withValues(alpha: 0.10),
              icon: svgAssets.bin,
              onTap: onDeleteTap)
        ]),
        homeScreenWidget.dottedLineCommon(vertical: Insets.i15),
        Text(language(context, description),
            style: AppCss.lexendRegular12.textColor(appTheme.primary)),
        SizedBox(height: Insets.i15),
        Row(children: [
          SvgPicture.asset(svgAssets.carLight,
              width: Insets.i15, height: Insets.i15),
          SizedBox(width: Insets.i5),
          Text(language(context, carType), style: AppCss.lexendLight11),
          SvgPicture.asset(svgAssets.verticalLine)
              .marginSymmetric(horizontal: Insets.i6),
          SvgPicture.asset(svgAssets.profile1),
          Text(language(context, capacity), style: AppCss.lexendLight11),
          const Spacer(),
          Text("${language(context, appFonts.validTill1)} $validTill",
              style: AppCss.lexendRegular11.textColor(appTheme.textClr))
        ]),
        SizedBox(height: Insets.i8),
        homeScreenWidget.dottedLineCommon(vertical: Insets.i15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(language(context, appFonts.activeStatus),
              style: AppCss.lexendLight11.textColor(appTheme.primary)),
          GestureDetector(
              onTap: () {
                onTapSwitch!.call(!isActive);
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: Insets.i35,
                  height: Insets.i22,
                  padding: EdgeInsets.symmetric(horizontal: Insets.i4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                      color: isActive ? Colors.black : Colors.white,
                      border: Border.all(
                          color: isActive ? appTheme.trans : appTheme.stroke,
                          width: Insets.i1)),
                  child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: isActive
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          width: Insets.i12,
                          height: Insets.i12,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? appTheme.white
                                  : appTheme.textClr)))))
        ])
      ])).marginSymmetric(horizontal: Insets.i20, vertical: Insets.i10);
    });
  }
}
