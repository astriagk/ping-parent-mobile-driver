import '../../../../config.dart';

class AppSettingScreenWidget {
  //custom radio button layout
  Widget customRadioContainer({dynamic onTap, e}) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return InkWell(
          radius: 0,
          onTap: onTap,
          child: settingCtrl.selectIndex == e.key
              ? Container(
                  width: Sizes.s20,
                  height: Sizes.s20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.12)),
                  child: Icon(Icons.circle,
                      color: appColor(context).appTheme.primary,
                      size: Sizes.s13))
              : Container(
                  width: Sizes.s20,
                  height: Sizes.s20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: appColor(context).appTheme.stroke))));
    });
  }

  //draggable title layout
  Widget draggableTitleLayout(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextWidgetCommon(
          text: appFonts.changeCurrency,
          fontSize: Sizes.s18,
          fontWeight: FontWeight.w500),
      SvgPicture.asset(svgAssets.close).inkWell(onTap: () => route.pop(context))
    ]);
  }

//draggable list title and icon layout
  Widget draggableListTitleIconLayout(e, isSvg, index, context, setState) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          isSvg == true
              ? SvgPicture.asset(e.value['icon'])
                  .padding(horizontal: Sizes.s7, vertical: Sizes.s10)
              : SizedBox(
                  height: Sizes.s40,
                  width: Sizes.s40,
                  child: Image.asset(e.value['icon'])),
          HSpace(Sizes.s20),
          TextWidgetCommon(text: e.value['title'])
        ]),
        //custom radio button layout
        AppSettingScreenWidget().customRadioContainer(
            onTap: () {
              settingCtrl.commonOnTap(index, e, context);
              setState;
            },
            e: e)
      ]).padding(vertical: Sizes.s15);
    });
  }
}
