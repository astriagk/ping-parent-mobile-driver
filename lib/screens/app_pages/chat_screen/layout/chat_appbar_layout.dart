import '../../../../config.dart';

class ChatAppBarLayout extends StatelessWidget {
  final bool? isSvg;
  final bool? isHomeChat;
  final String? title;
  final GestureTapCallback? onTap;

  const ChatAppBarLayout(
      {super.key, this.isSvg, this.title, this.isHomeChat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              CommonIconButton(
                  icon: svgAssets.back, onTap: () => route.pop(context)),
              HSpace(Sizes.s15),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgetCommon(text: title),
                    VSpace(Sizes.s2),
                    TextWidgetCommon(
                        text: appFonts.online,
                        style: AppCss.lexendMedium12
                            .textColor(appColor(context).appTheme.online))
                  ])
            ]),
            ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: isSvg == true
                        ? CommonIconButton(icon: svgAssets.trashDark)
                            .inkWell(onTap: onTap)
                        : PopupMenuButton(
                            color: appColor(context).appTheme.white,
                            constraints: BoxConstraints(
                                minWidth: Sizes.s87, maxWidth: Sizes.s87),
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppRadius.r8))),
                            padding: const EdgeInsets.all(0),
                            iconSize: Sizes.s20,
                            offset: const Offset(5, 20),
                            icon: CommonIconButton(icon: svgAssets.more),
                            itemBuilder: (context) => [
                                  buildPopupMenuItem(
                                      list: appArray.optionList
                                          .asMap()
                                          .entries
                                          .map((e) => PopupItemRowCommon(
                                              data: e.value,
                                              index: e.key,
                                              list: appArray.optionList,
                                              onTap: () {}))
                                          .toList())
                                ]).decorated(
                            color: appColor(context).appTheme.white,
                            shape: BoxShape.circle))
                .height(Sizes.s40)
                .width(Sizes.s40)
          ]).chatAppBarExtension(context);
    });
  }
}
