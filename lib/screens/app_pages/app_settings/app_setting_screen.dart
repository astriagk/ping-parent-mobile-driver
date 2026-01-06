import 'package:taxify_driver_ui/config.dart';

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingProvider, LanguageProvider>(
        builder: (context, settingCtrl, languageCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: appFonts.appSettings,
              titleWidth: MediaQuery.of(context).size.width * 0.02),
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            ...appArray
                .appSetting(settingCtrl.isNotificationSwitch)
                .asMap()
                .entries
                .map((e) {
              return Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        CommonIconButton(icon: e.value['icon'].toString()),
                        HSpace(Sizes.s12),
                        e.key == 0
                            ? Text(language(context, e.value['title']),
                                style: AppCss.lexendRegular14.textColor(
                                    appColor(context).appTheme.darkText))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(language(context, e.value['title']),
                                        style: AppCss.lexendRegular14.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText)),
                                    VSpace(Insets.i5),
                                    Text(
                                        e.key == 1
                                            ? "${appArray.currencyList[settingCtrl.selectIndex]['title']}"
                                            : settingCtrl.capitalize(
                                                appArray.languageList[
                                                        settingCtrl.selectIndex]
                                                    ['title']),
                                        style: AppCss.lexendRegular12
                                            .textColor(appTheme.hintText))
                                  ])
                      ]).padding(vertical: Sizes.s15),
                      e.key == 0
                          ? GestureDetector(
                              onTap: () => languageCtrl.switchRTL(),
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: Insets.i35,
                                  height: Insets.i22,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Insets.i4),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.r50),
                                      color: languageCtrl.isUserRTl
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(
                                          color: languageCtrl.isUserRTl
                                              ? appTheme.trans
                                              : appTheme.stroke,
                                          width: Insets.i1)),
                                  child: AnimatedAlign(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      alignment: languageCtrl.isUserRTl
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                          width: Insets.i12,
                                          height: Insets.i12,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: languageCtrl.isUserRTl
                                                  ? appTheme.white
                                                  : appTheme.textClr)))))
                          : SvgPicture.asset(svgAssets.arrow,
                              colorFilter: ColorFilter.mode(
                                  appColor(context).appTheme.lightText, BlendMode.srcIn))
                    ]).inkWell(
                    onTap: () => //app setting screen onTap
                        settingCtrl.appSettingOnTap(e.key, context)),
                if (e.key !=
                    appArray
                            .appSetting(settingCtrl.isNotificationSwitch)
                            .length -
                        1)
                  Divider(color: appColor(context).appTheme.stroke, height: 0)
              ]);
            })
          ])
              .padding(horizontal: Sizes.s15)
              .decorated(
                  color: appColor(context).appTheme.bgBox, allRadius: Sizes.s12)
              .padding(all: Sizes.s20));
    });
  }
}
