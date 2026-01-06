import 'package:taxify_driver_ui/config.dart';

class DocumentUpdateScreen extends StatelessWidget {
  const DocumentUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailsProvider>(builder: (context, bdCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: language(context, appFonts.documentRegistration),
              radius: Sizes.s0),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Column(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidgetCommon(
                            text: language(context, appFonts.birthCertificate),
                            style: AppCss.lexendMedium14
                                .textColor(appTheme.darkText)),
                        VSpace(Insets.i10),
                        Container(
                            padding: EdgeInsets.all(Insets.i5),
                            height: Insets.i94,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Insets.i12)),
                            child: DottedBorder(
                                color: appColor(context).appTheme.lightText,
                                strokeWidth: 1,
                                dashPattern: const [6, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Insets.i12),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(svgAssets.import),
                                          VSpace(Insets.i3),
                                          Text(
                                              language(
                                                  context, appFonts.upload),
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.textClr))
                                        ])))).width(double.infinity),
                        VSpace(Insets.i12),
                        TextWidgetCommon(
                            text: language(
                                context, appFonts.certificateOfRegistration),
                            style: AppCss.lexendMedium14
                                .textColor(appTheme.darkText)),
                        VSpace(Insets.i10),
                        Container(
                            padding: EdgeInsets.all(Insets.i5),
                            height: Insets.i94,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Insets.i12)),
                            child: DottedBorder(
                                color: appColor(context).appTheme.lightText,
                                strokeWidth: 1,
                                dashPattern: const [6, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Insets.i12),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(svgAssets.import),
                                          VSpace(Insets.i3),
                                          Text(
                                              language(
                                                  context, appFonts.upload),
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.textClr))
                                        ])))).width(double.infinity),
                        VSpace(Insets.i12),
                        TextWidgetCommon(
                            text: language(context, appFonts.drivingLicense),
                            style: AppCss.lexendMedium14
                                .textColor(appTheme.darkText)),
                        VSpace(Insets.i10),
                        Container(
                            padding: EdgeInsets.all(Insets.i5),
                            height: Insets.i94,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Insets.i12)),
                            child: DottedBorder(
                                color: appColor(context).appTheme.lightText,
                                strokeWidth: 1,
                                dashPattern: const [6, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Insets.i12),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(svgAssets.import),
                                          VSpace(Insets.i3),
                                          Text(
                                              language(
                                                  context, appFonts.upload),
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.textClr))
                                        ])))).width(double.infinity),
                        VSpace(Insets.i12),
                        TextWidgetCommon(
                            text: language(context, appFonts.nationalID),
                            style: AppCss.lexendMedium14
                                .textColor(appTheme.darkText)),
                        VSpace(Insets.i10),
                        Container(
                            padding: const EdgeInsets.all(5),
                            height: Insets.i94,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Insets.i12)),
                            child: DottedBorder(
                                color: appColor(context).appTheme.lightText,
                                strokeWidth: 1,
                                dashPattern: const [6, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Insets.i12),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(svgAssets.import),
                                          VSpace(Insets.i3),
                                          Text(
                                              language(
                                                  context, appFonts.upload),
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.textClr))
                                        ])))).width(double.infinity),
                        VSpace(Insets.i12),
                        TextWidgetCommon(
                            text: language(context, appFonts.panCard),
                            style: AppCss.lexendMedium14
                                .textColor(appTheme.darkText)),
                        VSpace(Insets.i10),
                        Container(
                            padding: EdgeInsets.all(Insets.i5),
                            height: Insets.i94,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Insets.i12)),
                            child: DottedBorder(
                                color: appColor(context).appTheme.lightText,
                                strokeWidth: 1,
                                dashPattern: const [6, 3],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Insets.i12),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(svgAssets.import),
                                          VSpace(Insets.i3),
                                          Text(
                                              language(
                                                  context, appFonts.upload),
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.textClr))
                                        ])))).width(double.infinity),
                        VSpace(Insets.i12)
                      ]).padding(horizontal: Sizes.s20).authExtension(context)
                ]),
                VSpace(Insets.i30),
                CommonButton(
                        text: language(context, appFonts.update),
                        onTap: () => route.pop(context))
                    .padding(horizontal: Sizes.s20)
                    .marginOnly(bottom: Insets.i20)
              ])));
    });
  }
}
