import 'package:taxify_driver_ui/config.dart';

class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? index;

  const DashAppBar({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, dashCtrl, child) {
      return /*dashCtrl.currentIndex == 0
          ? */
          dashCtrl.currentIndex == 3
              ? Container()
              : Container(
                  // padding: EdgeInsets.only(top: Insets.i10),
                  height: Insets.i100,
                  decoration: BoxDecoration(
                      color: appTheme.bgBox,
                      borderRadius: SmoothBorderRadius.vertical(
                          bottom: SmoothRadius(
                              cornerRadius: AppRadius.r30,
                              cornerSmoothing: Insets.i20))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dashCtrl.currentIndex == 0
                            ? SvgPicture.asset(svgAssets.logo,
                                height: Insets.i30)
                            : dashCtrl.currentIndex == 1
                                ? Row(children: [
                                    CommonIconButton(
                                        icon: svgAssets.arrow1,
                                        onTap: () {
                                          dashCtrl.currentIndex = 0;
                                        }),
                                    Text(language(context, appFonts.activeRide),
                                            style: AppCss.lexendSemiBold20
                                                .textColor(appTheme.primary))
                                        .marginOnly(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.19)
                                  ])
                                : Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text(
                                            dashCtrl.currentIndex == 3
                                                ? language(
                                                    context, appFonts.settings)
                                                : language(
                                                    context, appFonts.myRides),
                                            style: AppCss.lexendSemiBold20
                                                .textColor(appTheme.primary)),
                                        dashCtrl.currentIndex == 3
                                            ? Container()
                                            : Row(children: [
                                                CommonIconButton(
                                                    icon: svgAssets.messages,
                                                    onTap: () {
                                                      route.pushNamed(context,
                                                          routeName.chatScreen);
                                                    }),
                                                HSpace(Insets.i10),
                                                CommonIconButton(
                                                    icon:
                                                        svgAssets.notifications,
                                                    onTap: () => route.pushNamed(
                                                        context,
                                                        routeName
                                                            .emptyNotificationScreen))
                                              ])
                                      ])),
                        dashCtrl.currentIndex == 0
                            ? Row(children: [
                                Text(language(context, appFonts.onOff),
                                    style: AppCss.lexendRegular14
                                        .textColor(appTheme.primary)),
                                HSpace(Insets.i8),
                                GestureDetector(
                                    onTap: () => dashCtrl.toggleOnTap(),
                                    child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: Insets.i32,
                                        height: Insets.i20,
                                        padding: EdgeInsets.all(Insets.i4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.r50),
                                            color: dashCtrl.isToggled
                                                ? Colors.black
                                                : Colors.white,
                                            border: Border.all(
                                                color: appTheme.primary,
                                                width: Insets.i1)),
                                        child: AnimatedAlign(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            alignment: dashCtrl.isToggled
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                                width: Insets.i12,
                                                height: Insets.i12,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: dashCtrl.isToggled
                                                        ? appTheme.white
                                                        : appTheme.primary))))),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: Insets.i40,
                                        bottom: Insets.i35,
                                        left: Insets.i10,
                                        right: Insets.i10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: Insets.i1,
                                            color: appTheme.stroke))),
                                CommonIconButton(
                                    icon: svgAssets.notifications,
                                    onTap: () => route.pushNamed(context,
                                        routeName.emptyNotificationScreen))
                              ])
                            : Container()
                      ]).paddingSymmetric(horizontal: Insets.i20));
    });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(index == 0 ? Insets.i120 : Insets.i80);
}
