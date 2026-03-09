import '../../../../../config.dart';

class SettingScreenWidgets {
  //My wallet Balance layout
  Widget myWalletLayout(context,
      {required String name, required String email}) {
    return Column(children: [
      TextWidgetCommon(
          text: name,
          style: AppCss.lexendRegular14
              .textColor(appColor(context).appTheme.darkText)),
      VSpace(Sizes.s5),
      TextWidgetCommon(
          text: email,
          style: AppCss.lexendMedium12
              .textColor(appColor(context).appTheme.lightText)),
      VSpace(Sizes.s12),
      // Column(children: [
      //   TextWidgetCommon(
      //       text: language(context, appFonts.myWalletBalance),
      //       style: AppCss.lexendRegular12.textColor(
      //           appColor(context).appTheme.darkText.withValues(alpha: .6))),
      //   VSpace(Sizes.s6),
      //   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     TextWidgetCommon(
      //         text: language(context, appFonts.amount),
      //         style: AppCss.lexendSemiBold15
      //             .textColor(appColor(context).appTheme.darkText)),
      //     HSpace(Sizes.s6),
      //     SvgPicture.asset(svgAssets.rightArrowMyWallet)
      //   ])
      // ]).settingWalletExtension(context)
    ]);
  }

//setting screen all list main title layout
  Widget mainListTitlesLayout(e, context) {
    return Column(children: [
      TextWidgetCommon(
          text: language(context, e.value['title']),
          style: AppCss.lexendRegular14.textColor(
              language(context, e.value["title"]) ==
                      language(context, appFonts.alertZone)
                  ? appColor(context).appTheme.alertZone
                  : appColor(context).appTheme.lightText)),
      VSpace(Sizes.s15)
    ]);
  }

//setting screen list icon, title,arrow layout
  Widget listIconTitleArrowLayout(e, context, a) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    e.value["title"] == language(context, appFonts.alertZone) ||
                            a.value["subTitle"] == appFonts.deleteAccount ||
                            a.value["subTitle"] == appFonts.logout
                        ? appColor(context)
                            .appTheme
                            .alertZone
                            .withValues(alpha: 0.10)
                        : appColor(context).appTheme.white,
                border: Border.all(
                    color: e.value["title"] ==
                                language(context, appFonts.alertZone) ||
                            a.value["subTitle"] == appFonts.deleteAccount ||
                            a.value["subTitle"] == appFonts.logout
                        ? appColor(context).appTheme.trans
                        : appColor(context).appTheme.stroke)),
            child: SvgPicture.asset(a.value['icon']).padding(all: Sizes.s11)),
        HSpace(Sizes.s15),
        TextWidgetCommon(
            text: a.value['subTitle'],
            style: AppCss.lexendRegular14.textColor(
                e.value["title"] == appFonts.alertZone
                    ? appColor(context).appTheme.alertZone
                    : appColor(context).appTheme.darkText))
      ]),
      e.value["title"] != language(context, appFonts.alertZone)
          ? SvgPicture.asset(svgAssets.arrow)
          : const SizedBox.shrink()
    ]);
  }

  //setting screen divider layout
  Widget settingDivider(e, context) => Divider(
          color: e.value["title"] == language(context, appFonts.alertZone)
              ? appColor(context).appTheme.alertZone.withValues(alpha: 0.20)
              : appColor(context).appTheme.stroke,
          height: 0)
      .padding(vertical: Sizes.s12);

  //setting screen profile image layout
  Widget settingProfileImage({String? photoUrl, double? topPadding}) => Align(
          alignment: Alignment.topCenter,
          child: ClipOval(
              child: SizedBox(
                  height: Sizes.s96,
                  width: Sizes.s96,
                  child: (photoUrl != null && photoUrl.isNotEmpty)
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              imageAssets.profileImg,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(imageAssets.profileImg,
                          fit: BoxFit.cover))))
      .padding(top: topPadding ?? Sizes.s30);
}
