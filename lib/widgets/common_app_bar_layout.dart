import 'package:skolo_driver/config.dart';

class CommonAppBarLayout extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final double? radius;
  final double? titleWidth;
  final bool? icon;
  final bool? isSetting;
  final bool? isUseWidget;
  final GestureTapCallback? onTap;
  final Widget? widget;

  const CommonAppBarLayout(
      {super.key,
      this.title,
      this.radius,
      this.icon,
      this.isSetting = false,
      this.onTap,
      this.widget,
      this.isUseWidget = false,
      this.titleWidth});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: const SizedBox.shrink(),
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.only(
                bottomRight: SmoothRadius(
                    cornerRadius: radius ?? Sizes.s20, cornerSmoothing: 1),
                bottomLeft: SmoothRadius(
                    cornerRadius: radius ?? Sizes.s20, cornerSmoothing: 1))),
        titleSpacing: 0,
        leadingWidth: 0,
        backgroundColor: appColor(context).appTheme.bgBox,
        flexibleSpace:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
              mainAxisAlignment: isSetting == true
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                isSetting == true
                    ? Container()
                    : CommonIconButton(
                        icon: svgAssets.back, onTap: () => route.pop(context)),
                Expanded(
                    child: isSetting != true
                        ? TextWidgetCommon(
                                text: title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: AppCss.lexendSemiBold20.textColor(
                                    appColor(context).appTheme.darkText))
                            .marginOnly(
                                left: isUseWidget == true
                                    ? Insets.i25
                                    : titleWidth ?? Insets.i25)
                        : Row(children: [
                            TextWidgetCommon(
                                    text: title,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppCss.lexendSemiBold20.textColor(
                                        appColor(context).appTheme.darkText))
                                .marginOnly(
                                    left: isUseWidget == true
                                        ? Insets.i25
                                        : titleWidth ?? Insets.i25)
                          ])),
                icon == true
                    ? CommonIconButton(icon: svgAssets.add)
                        .inkWell(onTap: onTap)
                    : Container().paddingDirectional(horizontal: Sizes.s20),
                isUseWidget == true ? widget! : Container()
              ]).padding(horizontal: Sizes.s20)
        ]).padding(vertical: Sizes.s30));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Insets.i90);
}
