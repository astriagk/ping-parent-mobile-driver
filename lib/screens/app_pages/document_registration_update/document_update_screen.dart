import 'package:skolo_driver/config.dart';

class DocumentUpdateScreen extends StatelessWidget {
  const DocumentUpdateScreen({super.key});

  /// Handle update documents submission
  Future<void> handleUpdateDocuments(
    BuildContext context,
    DocumentUpdateProvider docCtrl,
  ) async {
    final success = await docCtrl.updateDriverDocuments();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
              text: docCtrl.successMessage ?? 'Documents updated successfully'),
        ),
      );
      if (context.mounted) route.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
              text: docCtrl.errorMessage ?? 'Failed to update documents'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentUpdateProvider>(builder: (context, docCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationClass.ms150, () => docCtrl.onInit()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  title: language(context, appFonts.documentRegistration),
                  radius: Sizes.s0),
              body: docCtrl.isLoading
                  ? const DocumentUpdateSkeleton()
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(children: [
                            _buildDocumentUploadUI(context, docCtrl)
                                .padding(horizontal: Sizes.s20)
                                .authExtension(context)
                          ]),
                          VSpace(Insets.i30),
                          CommonButton(
                                  text: language(context, appFonts.update),
                                  isLoading: docCtrl.isUpdating,
                                  onTap: docCtrl.isUpdating
                                      ? null
                                      : () => handleUpdateDocuments(
                                          context, docCtrl))
                              .padding(horizontal: Sizes.s20)
                              .marginOnly(bottom: Insets.i20)
                        ]))));
    });
  }

  Widget _buildDocumentUploadUI(
      BuildContext context, DocumentUpdateProvider pvr) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSingleUploadDocumentSection(
          context,
          pvr,
          appFonts.drivingLicense,
          appFonts.enterDrivingLicense,
          pvr.drivingLicenseController,
          pvr.drivingLicensePhotoUrl),
      VSpace(Insets.i25),
      _buildSingleUploadDocumentSection(
          context,
          pvr,
          appFonts.vehicleLicenseNumber,
          appFonts.enterVehicleLicenseNumber,
          pvr.vehicleLicenseNumberController,
          pvr.vehicleLicensePhotoUrl),
      VSpace(Insets.i25),
      _buildSingleUploadDocumentSection(
          context,
          pvr,
          appFonts.insuranceNumber,
          appFonts.enterInsuranceNumber,
          pvr.insuranceNumberController,
          pvr.insurancePhotoUrl),
      VSpace(Insets.i25),
    ]);
  }

  Widget _buildSingleUploadDocumentSection(
    BuildContext context,
    DocumentUpdateProvider pvr,
    String titleKey,
    String hintText,
    TextEditingController controller,
    String? photoUrl,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: language(context, titleKey),
          style: AppCss.lexendMedium14.textColor(appTheme.darkText)),
      VSpace(Insets.i10),
      _buildFullWidthUploadContainer(context, pvr, titleKey, photoUrl),
      VSpace(Insets.i12),
      AuthCommonWidgets().textAndTextField(
          language(context, titleKey), language(context, hintText), context,
          controller: controller),
    ]);
  }

  Widget _buildFullWidthUploadContainer(BuildContext context,
      DocumentUpdateProvider pvr, String documentName, String? photoUrl) {
    final hasLocalImage = pvr.documentImages[documentName] != null;
    final hasNetworkImage = photoUrl != null && photoUrl.isNotEmpty;
    final showEditIcon = hasLocalImage || hasNetworkImage;

    return GestureDetector(
        onTap: () async => await pvr.pickImage(
              context,
              documentName: documentName,
            ),
        child: Stack(children: [
          Container(
                  padding: const EdgeInsets.all(5),
                  height: Insets.i180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appTheme.white,
                      borderRadius: BorderRadius.circular(AppRadius.r12)),
                  child: DottedBorder(
                      color: appColor(context).appTheme.lightText,
                      strokeWidth: 1,
                      dashPattern: const [6, 3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(AppRadius.r12),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          child: hasLocalImage
                              ? Image.file(pvr.documentImages[documentName]!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity)
                              : hasNetworkImage
                                  ? Image.network(photoUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity)
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(svgAssets.import),
                                            VSpace(Insets.i3),
                                            Text(
                                                language(context,
                                                    appFonts.uploadImage),
                                                style: AppCss.lexendRegular13
                                                    .textColor(
                                                        appTheme.textClr))
                                          ])))))
              .width(double.infinity),
          if (showEditIcon)
            Positioned(
                top: 8,
                right: 8,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: appTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: appTheme.darkText.withValues(alpha: 0.26),
                              blurRadius: 4,
                              offset: const Offset(0, 1))
                        ]),
                    child: Icon(Icons.edit,
                        size: Sizes.s16, color: appTheme.darkText)))
        ]));
  }
}
