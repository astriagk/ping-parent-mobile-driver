import 'package:image_picker/image_picker.dart';

import '../../../../config.dart';

class DocumentsVerifyLayout extends StatelessWidget {
  const DocumentsVerifyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildDocumentUploadUI(context, signUpPvr),
        VSpace(Insets.i30),
        CommonButton(
                text: language(context, appFonts.next),
                onTap: () => signUpPvr.documentVerifyButton())
            .padding(bottom: Sizes.s20),
      ]);
    });
  }

  Widget _buildDocumentUploadUI(
      BuildContext context, SignUpProvider signUpPvr) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: language(context, appFonts.birthCertificate),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      GestureDetector(
          onTap: () async => await signUpPvr.pickImage(context),
          child: Container(
                  padding: const EdgeInsets.all(5),
                  height: Insets.i94,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r12)),
                  child: DottedBorder(
                      color: appColor(context).appTheme.lightText,
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(AppRadius.r12),
                      child: Container(
                          alignment: Alignment.center,
                          child: signUpPvr.image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      SvgPicture.asset(svgAssets.import),
                                      VSpace(Insets.i3),
                                      Text(language(context, appFonts.upload),
                                          style: AppCss.lexendRegular13
                                              .textColor(appTheme.textClr))
                                    ])
                              : Image.file(signUpPvr.image!,
                                  fit: BoxFit.cover))))
              .width(double.infinity)),
      VSpace(Insets.i12),
      TextWidgetCommon(
          text: language(context, appFonts.certificateOfRegistration),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      Container(
          padding: const EdgeInsets.all(5),
          height: Insets.i94,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
          child: DottedBorder(
              color: appColor(context).appTheme.lightText,
              strokeWidth: 1,
              dashPattern: const [6, 3],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(svgAssets.import),
                        VSpace(Insets.i3),
                        Text(language(context, appFonts.upload),
                            style: AppCss.lexendRegular13
                                .textColor(appTheme.textClr))
                      ])))).width(double.infinity).inkWell(
          onTap: () async => await signUpPvr.pickImage(
                context, /* source: ImageSource.camera*/
              )),
      VSpace(Insets.i12),
      TextWidgetCommon(
          text: language(context, appFonts.drivingLicense),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      Row(children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(5),
                height: Insets.i94,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: DottedBorder(
                    color: appColor(context).appTheme.lightText,
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(svgAssets.import),
                              VSpace(Insets.i3),
                              Text(language(context, appFonts.uploadFront),
                                  style: AppCss.lexendRegular13
                                      .textColor(appTheme.textClr))
                            ])))).width(double.infinity).inkWell(
                onTap: () async => await signUpPvr.pickImage(
                      context, /*source: ImageSource.camera*/
                    ))),
        HSpace(Insets.i12),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(5),
                height: Insets.i94,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: DottedBorder(
                    color: appColor(context).appTheme.lightText,
                    strokeWidth: 1,
                    // Border thickness
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(svgAssets.import),
                              VSpace(Insets.i3),
                              Text(language(context, appFonts.uploadBack),
                                  style: AppCss.lexendRegular13
                                      .textColor(appTheme.textClr))
                            ])))).width(double.infinity).inkWell(
                onTap: () async => await signUpPvr.pickImage(
                      context, /*source: ImageSource.camera*/
                    )))
      ]),
      VSpace(Insets.i12),
      TextWidgetCommon(
          text: language(context, appFonts.nationalID),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      Row(children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(5),
                height: Insets.i94,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: DottedBorder(
                    color: appColor(context).appTheme.lightText,
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(Insets.i12),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(svgAssets.import),
                              VSpace(Insets.i3),
                              Text(language(context, appFonts.uploadFront),
                                  style: AppCss.lexendRegular13
                                      .textColor(appTheme.textClr))
                            ])))).width(double.infinity)),
        HSpace(Insets.i12),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(5),
                height: Insets.i94,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: DottedBorder(
                    color: appColor(context).appTheme.lightText,
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(svgAssets.import),
                              VSpace(Insets.i3),
                              Text(language(context, appFonts.uploadBack),
                                  style: AppCss.lexendRegular13
                                      .textColor(appTheme.textClr))
                            ])))).width(double.infinity).inkWell(
                onTap: () async => await signUpPvr.pickImage(
                      context, /*source: ImageSource.camera*/
                    )))
      ]),
      VSpace(Insets.i12),
      TextWidgetCommon(
          text: language(context, appFonts.panCard),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      Container(
          padding: const EdgeInsets.all(5),
          height: Insets.i94,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
          child: DottedBorder(
              color: appColor(context).appTheme.lightText,
              strokeWidth: 1,
              // Border thickness
              dashPattern: const [6, 3],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(svgAssets.import),
                        VSpace(Insets.i3),
                        Text(language(context, appFonts.uploadImage),
                            style: AppCss.lexendRegular13
                                .textColor(appTheme.textClr))
                      ])))).width(double.infinity).inkWell(
          onTap: () async => await signUpPvr.pickImage(
                context, /* source: ImageSource.camera*/
              ))
    ]);
  }
}
