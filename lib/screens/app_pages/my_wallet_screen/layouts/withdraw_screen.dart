import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';

import '../../../../config.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBarLayout(
            title: language(context, appFonts.withdraw),
            titleWidth: MediaQuery.of(context).size.width * 0.02),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text(language(context, appFonts.bankDetails),
                    style: AppCss.lexendBold16.textColor(appTheme.primary)),
                VSpace(Insets.i15),
                CommonBgLayout(
                    child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, appFonts.accNo),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr)),
                        Text(language(context, appFonts.accNum),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, appFonts.ifsc),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr)),
                        Text(language(context, appFonts.ifscCode1),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, appFonts.bankName),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr)),
                        Text(language(context, appFonts.dbsBank),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr))
                      ]),
                  VSpace(Insets.i12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language(context, appFonts.name),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr)),
                        Text(language(context, appFonts.zainDorwart),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr))
                      ])
                ])),
                homeScreenWidget.dottedLineCommon(
                    vertical: Insets.i20, dashColor: appTheme.stroke),
                Text(language(context, appFonts.addWithdrawAmount),
                    style: AppCss.lexendBold16.textColor(appTheme.primary)),
                VSpace(Insets.i15),
                AuthCommonWidgets().textAndTextField(
                    language(context, appFonts.enterAmount),
                    language(context, appFonts.enterWithdrawAmount),
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
              text: language(context, appFonts.withdraw),
              onTap: () => route.pop(context))
        ]).marginSymmetric(vertical: Insets.i25, horizontal: Insets.i20));
  }
}
