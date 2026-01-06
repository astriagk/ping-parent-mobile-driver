import '../config.dart';

PopupMenuItem buildPopupMenuItem({list}) {
  return PopupMenuItem(
      padding:  EdgeInsets.symmetric(
          horizontal: Insets.i12, vertical: Insets.i10),
      height: 20,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: list!,
      ));
}
