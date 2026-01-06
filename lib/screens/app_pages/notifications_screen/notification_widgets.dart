import '../../../config.dart';

class NotificationWidgets {
// title and subtitle layout
  Widget titleSubtitle(e, context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: e['title'],
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.darkText)),
      VSpace(Sizes.s5),
      TextWidgetCommon(
          text: e['subtitle'],
          style: AppCss.lexendLight12
              .textColor(appColor(context).appTheme.lightText)
              .textHeight(1.2))
    ]));
  }

  //notifications_screen icon layout
  Widget iconLayout(e, context) {
    return Container(
        height: Sizes.s32,
        width: Sizes.s32,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: e['isRead']
                ? appColor(context).appTheme.bgBox
                : appColor(context).appTheme.white),
        child: SvgPicture.asset(e['icon']).padding(all: Sizes.s7));
  }
}
