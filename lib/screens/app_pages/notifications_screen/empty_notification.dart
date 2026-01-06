import '../../../../../config.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Container(
              decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                          bottomRight: SmoothRadius(
                              cornerRadius: Sizes.s102, cornerSmoothing: 1))),
                  color: appColor(context).appTheme.bgBox),
              child: Column(children: [
                VSpace(Sizes.s58),
                Row(children: [
                  HSpace(Sizes.s20),
                  CommonIconButton(
                      icon: svgAssets.back, onTap: () => route.pop(context)),
                  HSpace(Sizes.s70),
                  TextWidgetCommon(
                      text: appFonts.notification,
                      style: AppCss.lexendMedium18
                          .textColor(appColor(context).appTheme.darkText)),
                ]),
                Image.asset('assets/image/home/empty.png').padding(
                    vertical: Sizes.s56, right: Sizes.s58, left: Sizes.s90)
              ])).paddingOnly(right: Sizes.s30),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextWidgetCommon(
                text: appFonts.nothingHere,
                style: AppCss.lexendSemiBold18
                    .textColor(appColor(context).appTheme.darkText)),
            VSpace(Sizes.s8),
            TextWidgetCommon(
                    text: appFonts.clickTheRefresh,
                    style: AppCss.lexendRegular12
                        .textColor(appColor(context).appTheme.lightText)
                        .textHeight(1.2),
                    textAlign: TextAlign.center)
                .padding(horizontal: Sizes.s15),
            CommonButton(
                    text: appFonts.refresh,
                    onTap: () =>
                        route.pushNamed(context, routeName.notificationScreen))
                .padding(bottom: Sizes.s20, top: Sizes.s75)
          ]).padding(horizontal: Sizes.s20)
        ]));
  }
}
