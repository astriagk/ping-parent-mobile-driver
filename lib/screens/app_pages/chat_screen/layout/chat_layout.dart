import '../../../../config.dart';

class ChatLayout extends StatelessWidget {
  final String? title;
  final AlignmentGeometry? alignment;
  final bool? isSentByMe;
  final bool? isHomeChat;

  const ChatLayout(
      {super.key,
      this.title,
      this.alignment,
      this.isSentByMe,
      this.isHomeChat});

  @override
  Widget build(BuildContext context) {
    String now = TimeOfDay.fromDateTime(DateTime.now()).format(context);
    return Row(
        mainAxisAlignment: isSentByMe == true
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isSentByMe != true
              ? CommonIconButton1(
                  height: Sizes.s35,
                  width: Sizes.s35,
                  iconHeight: Sizes.s20,
                  iconWidth: Sizes.s20,
                  isImage: isHomeChat == true ? true : false,
                  icon: isHomeChat == true
                      ? imageAssets.john
                      : svgAssets.chatIcon,
                  bgColor: appColor(context).appTheme.bgBox)
              : const SizedBox.shrink(),
          HSpace(Sizes.s12),
          Column(
                  crossAxisAlignment: isSentByMe == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                TextWidgetCommon(
                    text: title!.toString(),
                    style: AppCss.lexendMedium14.textColor(isSentByMe == true
                        ? appColor(context).appTheme.white
                        : appColor(context).appTheme.darkText)),
                VSpace(Sizes.s10),
                Row(children: [
                  if (isSentByMe == true)
                    SvgPicture.asset(svgAssets.doubleTick)
                        .paddingOnly(right: Insets.i5),
                  TextWidgetCommon(
                      text: now,
                      style: AppCss.lexendMedium12.textColor(isSentByMe == true
                          ? appColor(context).appTheme.white
                          : appColor(context).appTheme.lightText))
                ])
              ])
              .marginSymmetric(horizontal: Sizes.s15, vertical: Sizes.s15)
              .decorated(
                  color: isSentByMe == true
                      ? appColor(context).appTheme.primary
                      : appColor(context).appTheme.bgBox,
                  bRRadius: isSentByMe == true ? 0 : Insets.i20,
                  bLRadius: isSentByMe == true ? Insets.i20 : 0,
                  tLRadius: Sizes.s20,
                  tRRadius: Sizes.s20)
        ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i15);
  }
}
