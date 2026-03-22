import 'package:skolo_driver/config.dart';

class TopUpWalletScreen extends StatelessWidget {
  const TopUpWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, settingPvr, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: language(context, appFonts.topUpWallet),
              titleWidth: MediaQuery.of(context).size.width * 0.02),
          body: Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Text(language(context, appFonts.selectMethod),
                      style: AppCss.lexendBold16.textColor(appTheme.primary)),
                  VSpace(Insets.i15),
                  ...List.generate(appArray.paymentMethods.length, (index) {
                    return Column(children: [
                      CommonBgLayout(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(children: [
                              SvgPicture.asset(
                                  appArray.paymentMethods[index]['icon']!),
                              CommonDivider(
                                  height: Insets.i20,
                                  margin: EdgeInsets.only(
                                      left:
                                          index == 0 ? Insets.i20 : Insets.i15,
                                      right: Insets.i15)),
                              Text(
                                  language(context,
                                      appArray.paymentMethods[index]['name']!),
                                  style: AppCss.lexendRegular14
                                      .textColor(appTheme.primary))
                            ]),
                            GestureDetector(
                                onTap: () {
                                  settingPvr.selectedIndex = index;
                                  settingPvr.notifyListeners();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: appTheme.stroke),
                                        shape: BoxShape.circle,
                                        color: settingPvr.selectedIndex == index
                                            ? appTheme.stroke
                                            : appTheme.trans),
                                    child: Container(
                                        height: Insets.i10,
                                        width: Insets.i10,
                                        margin: EdgeInsets.all(Insets.i5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: settingPvr.selectedIndex ==
                                                    index
                                                ? appTheme.primary
                                                : appTheme.trans))))
                          ])).inkWell(onTap: () {
                        settingPvr.selectedIndex = index;
                        settingPvr.notifyListeners();
                      }),
                      VSpace(Insets.i12)
                    ]);
                  }),
                  homeScreenWidget.dottedLineCommon(
                      vertical: Insets.i20, dashColor: appTheme.stroke),
                  Text(language(context, appFonts.addTopUpBalance),
                      style: AppCss.lexendBold16.textColor(appTheme.primary)),
                  VSpace(Insets.i15),
                  AuthCommonWidgets().textAndTextField(
                      language(context, appFonts.enterAmount),
                      language(context, appFonts.enterTopUpAmount),
                      context,
                      titleColor: appTheme.textClr,
                      fieldBgColor: appTheme.bgBox,
                      prefixIcon: SvgPicture.asset(svgAssets.dollarCircle)
                          .padding(vertical: Insets.i15),
                      style: AppCss.lexendRegular14
                          .textColor(appColor(context).appTheme.hintText),
                      keyboardType: TextInputType.number)
                ]))),
            CommonButton(
                text: language(context, appFonts.addBalance),
                onTap: () => route.pop(context))
          ]).marginSymmetric(vertical: Insets.i25, horizontal: Insets.i20));
    });
  }
}
