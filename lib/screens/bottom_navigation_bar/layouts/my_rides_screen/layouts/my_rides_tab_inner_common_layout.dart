import '../../../../../config.dart';

class MyRidesTabInnerCommonLayout extends StatelessWidget {
  final Widget body;
  final Widget? widget;
  final String? title, rideStatus;
  final bool? isNotHavingStatus;
  final bool? isUseWidget;

  const MyRidesTabInnerCommonLayout(
      {super.key,
      required this.body,
      required this.title,
      this.rideStatus,
      this.isNotHavingStatus = false,
      this.widget,
      this.isUseWidget = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(alignment: Alignment.topCenter, children: [
      body,
      Image.asset('assets/image/home/map_image.png')
          .marginOnly(top: Insets.i91),
      Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: appTheme.primary.withValues(alpha: 0.12),
                blurRadius: 22,
                offset: const Offset(0, 4),
                blurStyle: BlurStyle.normal,
                spreadRadius: 0)
          ], border: Border.all(color: appTheme.borderColor)),
          child: CommonAppBarLayout(
                  isUseWidget: isUseWidget,
                  title: title,
                  widget: isUseWidget == true ? widget : Container())
              .height(Insets.i115)),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              height: Insets.i46,
              width: Insets.i46,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/image/home/user2.png')))),
          HSpace(Insets.i8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(appFonts.peterThornton),
                VSpace(Insets.i4),
                screensWidgets.ratingCounting(4.8, 127)
              ])),
          isNotHavingStatus == true
              ? Container()
              : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                      margin: EdgeInsets.only(top: Insets.i3),
                      width: Insets.i4,
                      height: Insets.i4,
                      decoration: BoxDecoration(
                          color: rideStatus == "Cancel"
                              ? appTheme.alertZone
                              : appTheme.priceClr,
                          shape: BoxShape.circle)),
                  HSpace(Insets.i5),
                  Text(rideStatus!,
                      style: AppCss.lexendMedium13.textColor(
                          rideStatus == "Cancel"
                              ? appTheme.alertZone
                              : appTheme.priceClr))
                ]).marginOnly(bottom: Insets.i15)
        ])
      ])
          .marginSymmetric(horizontal: Insets.i20)
          .marginOnly(top: MediaQuery.of(context).size.height * 0.28)
    ]));
  }
}
