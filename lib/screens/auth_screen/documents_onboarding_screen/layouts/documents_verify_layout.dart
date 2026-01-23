import 'package:image_picker/image_picker.dart';

import '../../../../../config.dart';

class DocumentsVerifyLayout extends StatelessWidget {
  const DocumentsVerifyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
        builder: (context, onboardingPvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildDocumentUploadUI(context, onboardingPvr),
        VSpace(Insets.i30),
        CommonButton(
                text: language(context, appFonts.next),
                onTap: () => onboardingPvr.documentVerifyButton(context))
            .padding(bottom: Sizes.s20),
      ]);
    });
  }

  Widget _buildDocumentUploadUI(BuildContext context, OnboardingProvider pvr) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSingleUploadDocumentSection(context, pvr, appFonts.drivingLicense,
          appFonts.enterDrivingLicense, pvr.drivingLicenseController),
      VSpace(Insets.i25),
      _buildSingleUploadDocumentSection(
          context,
          pvr,
          appFonts.vehicleLicenseNumber,
          appFonts.enterVehicleLicenseNumber,
          pvr.vehicleLicenseNumberController),
      VSpace(Insets.i25),
      _buildSingleUploadDocumentSection(context, pvr, appFonts.insuranceNumber,
          appFonts.enterInsuranceNumber, pvr.insuranceNumberController),
    ]);
  }

  Widget _buildSingleUploadDocumentSection(
    BuildContext context,
    OnboardingProvider pvr,
    String title,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: language(context, title),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      _buildFullWidthUploadContainer(context, pvr, language(context, title)),
      VSpace(Insets.i12),
      AuthCommonWidgets().textAndTextField(
          language(context, title), language(context, hintText), context,
          controller: controller),
    ]);
  }

  Widget _buildDocumentSection(
    BuildContext context,
    OnboardingProvider pvr,
    String title,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: language(context, title),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      Row(children: [
        Expanded(
            child:
                _buildUploadContainer(context, pvr, language(context, title))),
        HSpace(Insets.i12),
        Expanded(
            child:
                _buildUploadContainer(context, pvr, language(context, title)))
      ]),
      VSpace(Insets.i12),
      AuthCommonWidgets().textAndTextField(
          language(context, title), language(context, hintText), context,
          controller: controller),
    ]);
  }

  Widget _buildUploadContainer(
      BuildContext context, OnboardingProvider pvr, String documentName) {
    return GestureDetector(
        onTap: () async => await pvr.pickImage(
              context,
              documentName: documentName,
            ),
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
                        child: pvr.image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SvgPicture.asset(svgAssets.import),
                                    VSpace(Insets.i3),
                                    Text(
                                        language(context, appFonts.uploadFront),
                                        style: AppCss.lexendRegular13
                                            .textColor(appTheme.textClr))
                                  ])
                            : Image.file(pvr.image!, fit: BoxFit.cover))))
            .width(double.infinity));
  }

  Widget _buildFullWidthUploadContainer(
      BuildContext context, OnboardingProvider pvr, String documentName) {
    return GestureDetector(
        onTap: () async => await pvr.pickImage(
              context,
              documentName: documentName,
            ),
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
                        child: pvr.image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    SvgPicture.asset(svgAssets.import),
                                    VSpace(Insets.i3),
                                    Text(
                                        language(context, appFonts.uploadImage),
                                        style: AppCss.lexendRegular13
                                            .textColor(appTheme.textClr))
                                  ])
                            : Image.file(pvr.image!, fit: BoxFit.cover))))
            .width(double.infinity));
  }
}
