import '../../../../config.dart';
import 'layouts/setting_list_layout.dart';
import 'layouts/setting_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, settingCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => settingCtrl.init()),
          child: Stack(children: [
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(imageAssets.rectangle,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill)),
            CommonAppBarLayout(
                isSetting: true, title: language(context, appFonts.settings)),
            Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: ShapeDecoration(
                        color: appColor(context).appTheme.white,
                        shape: SmoothRectangleBorder(
                            side: const BorderSide(color: Color(0xFFF5F6F7)),
                            borderRadius: SmoothBorderRadius.only(
                                topLeft: SmoothRadius(
                                    cornerRadius: Sizes.s20,
                                    cornerSmoothing: 1),
                                topRight: SmoothRadius(
                                    cornerRadius: Sizes.s20,
                                    cornerSmoothing: 1)))),
                    child: Column(children: [
                      //My wallet Balance layout
                      SettingScreenWidgets().myWalletLayout(context),
                      //setting screen all data list layout
                      const SettingListLayout()
                    ]).padding(
                        top: Sizes.s46,
                        horizontal: Sizes.s20,
                        bottom: Sizes.s50))
                .marginOnly(top: MediaQuery.of(context).size.height * 0.20),
            SettingScreenWidgets()
                .settingProfileImage(MediaQuery.of(context).size.height * 0.15)
          ]));
    });
  }
}
