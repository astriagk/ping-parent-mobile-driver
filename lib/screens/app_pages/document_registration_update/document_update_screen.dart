import 'package:taxify_driver_ui/config.dart';

class DocumentUpdateScreen extends StatelessWidget {
  const DocumentUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsUpdateProvider>(
        builder: (context, udCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: language(context, appFonts.documentRegistration),
              radius: Sizes.s0),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Column(children: [
                  _buildDocumentUploadUI(context, udCtrl)
                      .padding(horizontal: Sizes.s20)
                      .authExtension(context)
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

  Widget _buildDocumentUploadUI(
      BuildContext context, UserDetailsUpdateProvider pvr) {
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
      VSpace(Insets.i25),
    ]);
  }

  Widget _buildSingleUploadDocumentSection(
    BuildContext context,
    UserDetailsUpdateProvider pvr,
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

  Widget _buildFullWidthUploadContainer(BuildContext context,
      UserDetailsUpdateProvider pvr, String documentName) {
    return GestureDetector(
        onTap: () async => await pvr.pickImage(
              context,
              documentName: documentName,
            ),
        child: Container(
                padding: const EdgeInsets.all(5),
                height: Insets.i94.toDouble(),
                decoration: BoxDecoration(
                    color: appTheme.white,
                    borderRadius: BorderRadius.circular(AppRadius.r12)),
                child: DottedBorder(
                    color: appColor(context).appTheme.lightText,
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(AppRadius.r12),
                    child: Container(
                        alignment: Alignment.center,
                        child: pvr.documentImages[documentName] == null
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
                            : Image.file(pvr.documentImages[documentName]!,
                                fit: BoxFit.cover))))
            .width(double.infinity));
  }
}
