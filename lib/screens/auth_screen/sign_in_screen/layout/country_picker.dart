import '../../../../config.dart';

class CountryPickerLayout extends StatelessWidget {
  final Color? textFiledColor;
  final TextEditingController? controller;

  const CountryPickerLayout({super.key, this.controller, this.textFiledColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(builder: (context, value, child) {
      return Row(children: [
        CountryListPickCustom(
                appBar: AppBar(
                    centerTitle: true,
                    title: TextWidgetCommon(
                        text: language(context, appFonts.selectCountry),
                        style: AppCss.lexendMedium20
                            .textColor(appColor(context).appTheme.white)),
                    elevation: 0,
                    backgroundColor: appColor(context).appTheme.primary),
                theme: CountryTheme(
                    searchHintText: 'Search Here',
                    isShowFlag: false,
                    isShowTitle: false,
                    isShowCode: true,
                    isDownIcon: true,
                    lastPickText:
                        language(context, appFonts.lastSelectedCountry),
                    showEnglishName: true,
                    searchText:
                        language(context, appFonts.searchByCountryNameOrCode),
                    alphabetTextColor: appColor(context).appTheme.darkText,
                    labelColor: appColor(context).appTheme.lightText,
                    alphabetSelectedBackgroundColor: appColor(context).appTheme.primary),
                initialSelection: '+91',
                onChanged: (CountryCodeCustom? code) {
                  value.countryCode = code!.dialCode!;
                  value.onCountryCode(value.countryCode);
                },
                useUiOverlay: false,
                useSafeArea: true)
            .padding(all: 0, vertical: Sizes.s6)
            .decorated(
                allRadius: Sizes.s8,
                color: textFiledColor ?? appColor(context).appTheme.screenBg),
        HSpace(Sizes.s8),
        TextFieldCommon(
                controller: controller,
                hintText: language(context, appFonts.enterYourNumber),
                color: textFiledColor ?? appColor(context).appTheme.white,
                keyboardType: TextInputType.number)
            .decorated(
                allRadius: Sizes.s8,
                color: appColor(context).appTheme.screenBg,
                boxShadow: [
              BoxShadow(
                  color: appColor(context)
                      .appTheme
                      .primary
                      .withValues(alpha: 0.03),
                  blurRadius: 20,
                  spreadRadius: 7)
            ]).expanded(flex: 4)
      ]).padding(top: Sizes.s9, bottom: Sizes.s60);
    });
  }
}
