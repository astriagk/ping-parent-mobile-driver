


import '../config.dart';

menuDivider(context) {
  return PopupMenuItem(
    padding: EdgeInsets.zero,
    height: 0,
    value: '',
    child: Divider(
        height: 0,
        color: appColor(context).appTheme.darkText,
        thickness: 1),
  );
}

menuItems(String text, context, {VoidCallback? onTap}) {
  return PopupMenuItem<String>(
      onTap: onTap,
      value: text,
      enabled: true,
      child: TextWidgetCommon(text: text));
}
