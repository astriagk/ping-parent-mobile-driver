import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/settings_screen/layouts/setting_widgets.dart';

//setting screen all data list layout
class SettingListLayout extends StatelessWidget {
  const SettingListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return Column(children: [
        ...appArray.settings.asMap().entries.map((e) {
          List data = e.value['data'];
          return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                //setting screen all list main title layout
                SettingScreenWidgets().mainListTitlesLayout(e, context),
                ...data.asMap().entries.map((a) {
                  return Column(children: [
                    //setting screen list icon, title,arrow layout
                    SettingScreenWidgets()
                        .listIconTitleArrowLayout(e, context, a),
                    if (a.key != data.length - 1)
                      //setting screen divider layout
                      SettingScreenWidgets().settingDivider(e, context)
                  ]).inkWell(
                      onTap: () =>
                          settingCtrl.settingsOnTap(e.value, a.value, context));
                })
              ])
              .width(MediaQuery.of(context).size.width)
              .padding(all: Sizes.s15)
              .decorated(
                  color: language(context, e.value["title"]) ==
                          language(context, appFonts.alertZone)
                      ? appColor(context)
                          .appTheme
                          .alertZone
                          .withValues(alpha: 0.10)
                      : appColor(context).appTheme.bgBox,
                  allRadius: Sizes.s12)
              .padding(bottom: Sizes.s20);
        })
      ]);
    });
  }
}
