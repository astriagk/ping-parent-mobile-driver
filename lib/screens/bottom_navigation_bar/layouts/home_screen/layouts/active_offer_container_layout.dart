import 'package:skolo_driver/widgets/common_divider.dart';

import '../../../../../config.dart';

class OfferCard extends StatelessWidget {
  final String name;
  final String discountText;
  final String carType;
  final String peopleCount;
  final String validTill;
  final bool isToggled;
  final VoidCallback onToggle;
  final VoidCallback? editOnTap, deleteOnTap;

  const OfferCard(
      {super.key,
      required this.name,
      required this.discountText,
      required this.carType,
      required this.peopleCount,
      required this.validTill,
      required this.isToggled,
      required this.onToggle,
      this.editOnTap,
      this.deleteOnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(Insets.i15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: appTheme.primary.withValues(alpha: 0.06),
                  offset: const Offset(0, 4),
                  blurRadius: Insets.i20,
                  blurStyle: BlurStyle.normal)
            ],
            color: appTheme.white,
            border: Border.all(width: 1, color: appTheme.bgBox),
            borderRadius: SmoothBorderRadius(
                cornerRadius: Insets.i10, cornerSmoothing: Insets.i20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                  height: Insets.i25,
                  width: Insets.i25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imageAssets.user)))),
              HSpace(Insets.i6),
              Text(name,
                  style: AppCss.lexendRegular12.textColor(appTheme.primary))
            ]),
            Row(children: [
              CommonIconButton(
                  onTap: editOnTap,
                  height: Insets.i30,
                  width: Insets.i30,
                  icon: svgAssets.edit,
                  bgColor: appTheme.borderColor),
              HSpace(Insets.i10),
              CommonIconButton(
                  onTap: deleteOnTap,
                  height: Insets.i30,
                  width: Insets.i30,
                  icon: svgAssets.bin,
                  bgColor: appTheme.alertZone.withValues(alpha: 0.10))
            ])
          ]),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                style: AppCss.lexendRegular12.textColor(appTheme.primary),
                text: language(context, appFonts.offer)),
            TextSpan(
                text: discountText,
                style: AppCss.lexendSemiBold12.textColor(appTheme.primary))
          ])),
          VSpace(Insets.i15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              SvgPicture.asset(svgAssets.carLight, height: Insets.i15),
              HSpace(Insets.i5),
              Text(carType,
                  style: AppCss.lexendLight11.textColor(appTheme.primary)),
              HSpace(Insets.i6),
              CommonDivider(height: Insets.i14, color: appTheme.textClr),
              HSpace(Insets.i6),
              SvgPicture.asset(svgAssets.profile1),
              Text('$peopleCount ${language(context, appFonts.person)}',
                  style: AppCss.lexendLight11.textColor(appTheme.primary))
            ]),
            SizedBox(
                width: 90,
                child: Text(
                    ' ${language(context, appFonts.validTill1)} $validTill',
                    overflow: TextOverflow.fade,
                    style: AppCss.lexendRegular11.textColor(appTheme.textClr)))
          ]),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(language(context, appFonts.activeStatus),
                style: AppCss.lexendLight11.textColor(appTheme.primary)),
            screensWidgets.customToggle(
                onToggle: onToggle, isToggled: isToggled)
          ])
        ]));
  }
}
