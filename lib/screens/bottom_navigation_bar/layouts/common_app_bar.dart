import 'package:skolo_driver/config.dart';

class DashAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? index;

  const DashAppBar({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, dashCtrl, child) {
      return AppBar(
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          titleSpacing: 0,
          backgroundColor: appColor(context).appTheme.bgBox,
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  bottomRight:
                      SmoothRadius(cornerRadius: Sizes.s20, cornerSmoothing: 1),
                  bottomLeft: SmoothRadius(
                      cornerRadius: Sizes.s20, cornerSmoothing: 1))),
          flexibleSpace:
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            _DashHeaderContent(
                currentIndex: dashCtrl.currentTab,
                onToggle: () => dashCtrl.toggleAvailability(),
                isToggled: dashCtrl.isAvailable,
                onIndexChange: (index) {
                  dashCtrl.currentTab = index;
                })
          ]).padding(vertical: Sizes.s30));
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(Insets.i90);
}

class _DashHeaderContent extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onToggle;
  final bool isToggled;
  final Function(int) onIndexChange;

  const _DashHeaderContent({
    required this.currentIndex,
    required this.onToggle,
    required this.isToggled,
    required this.onIndexChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftContent(context),
          _buildRightContent(context),
        ]).padding(horizontal: Sizes.s20);
  }

  Widget _buildLeftContent(BuildContext context) {
    switch (currentIndex) {
      case 0:
        return SvgPicture.asset(svgAssets.logo, height: Insets.i30);
      case 1:
        return Text(language(context, appFonts.activeRide),
                style: AppCss.lexendSemiBold20
                    .textColor(appColor(context).appTheme.primary))
            .marginOnly(left: Insets.i25);
      case 2:
      case 3:
      default:
        return Text(
                currentIndex == 3
                    ? language(context, appFonts.settings)
                    : language(context, appFonts.myAssignments),
                style: AppCss.lexendSemiBold20
                    .textColor(appColor(context).appTheme.primary))
            .marginOnly(left: Insets.i25);
    }
  }

  Widget _buildRightContent(BuildContext context) {
    switch (currentIndex) {
      case 0:
        return Row(children: [
          Text(language(context, appFonts.onOff),
              style: AppCss.lexendRegular14
                  .textColor(appColor(context).appTheme.primary)),
          HSpace(Insets.i8),
          GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: Insets.i32,
                  height: Insets.i20,
                  padding: EdgeInsets.all(Insets.i4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                      color: isToggled ? Colors.black : Colors.white,
                      border: Border.all(
                          color: appColor(context).appTheme.primary,
                          width: Insets.i1)),
                  child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: isToggled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          width: Insets.i12,
                          height: Insets.i12,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToggled
                                  ? appColor(context).appTheme.white
                                  : appColor(context).appTheme.primary))))),
          // Container(
          //     margin: EdgeInsets.symmetric(horizontal: Insets.i10),
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //             width: Insets.i1,
          //             color: appColor(context).appTheme.stroke))),
          // CommonIconButton(
          //     icon: svgAssets.notifications,
          //     onTap: () =>
          //         route.pushNamed(context, routeName.emptyNotificationScreen))
        ]);
      case 1:
      case 2:
      case 3:
      default:
        return Row(children: [
          // CommonIconButton(
          //     icon: svgAssets.messages,
          //     onTap: () {
          //       route.pushNamed(context, routeName.chatScreen);
          //     }),
          // HSpace(Insets.i10),
          // CommonIconButton(
          //     icon: svgAssets.notifications,
          //     onTap: () =>
          //         route.pushNamed(context, routeName.emptyNotificationScreen))
        ]);
    }
  }
}
