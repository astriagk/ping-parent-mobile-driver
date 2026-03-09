import '../../../config.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidgets {
  //common title and text-field layout
  Widget commonTextField(context,
      {String? title,
      String? hintText,
      String? icon,
      double? vSpace,
      bool isHavingSpace = false,
      TextEditingController? controller,
      TextInputType? textInputType,
      bool readOnly = false,
      bool isDisabled = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: title,
          style: AppCss.lexendMedium14
              .textColor(appColor(context).appTheme.darkText)),
      isHavingSpace == true ? VSpace(vSpace!) : Container(),
      Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: TextFieldCommon(
                controller: controller,
                hintText: hintText,
                keyboardType: textInputType,
                readOnly: readOnly,
                color: isDisabled
                    ? appColor(context).appTheme.lightText.withOpacity(0.15)
                    : null)
            .padding(top: Sizes.s8, bottom: Sizes.s20),
      )
    ]);
  }

  //profile image and edit button layout
  Widget profileImageLayout(
      BuildContext context, UserDetailsUpdateProvider udCtrl) {
    final String photoUrl = udCtrl.originalPhotoUrl;
    return Stack(children: [
      // Display the selected image or default image
      ClipOval(
              child: SizedBox(
                  height: Insets.i79,
                  width: Insets.i79,
                  child: udCtrl.image != null
                      ? Image.file(udCtrl.image!, fit: BoxFit.cover)
                      : (photoUrl.isNotEmpty
                          ? Image.network(photoUrl, fit: BoxFit.cover)
                          : Image.asset(imageAssets.profileImg,
                              fit: BoxFit.cover))))
          .center(),
      CommonIconButton(
          height: Insets.i30,
          bgColor: Colors.white,
          icon: svgAssets.profileEdit,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Container(
                          padding: EdgeInsets.all(16.0),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      language(
                                          context, appFonts.addProfilePhoto),
                                      style: AppCss.lexendMedium16
                                          .textColor(appTheme.primary)),
                                  CommonIconButton(
                                      icon: svgAssets.close,
                                      onTap: () => Navigator.pop(context))
                                ]),
                            SizedBox(height: Insets.i20),
                            ListTile(
                                leading: Icon(Icons.photo_library,
                                    color: appTheme.primary),
                                title: Text(
                                    language(
                                        context, appFonts.selectFromGallery),
                                    style: AppCss.lexendLight14
                                        .textColor(appTheme.primary)),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await udCtrl.pickImageFromSource(
                                      ImageSource.gallery,
                                      documentName: 'default');
                                }),
                            ListTile(
                                leading: Icon(Icons.camera_alt,
                                    color: appTheme.primary),
                                title: Text(
                                    language(context, appFonts.openCamera),
                                    style: AppCss.lexendLight14
                                        .textColor(appTheme.primary)),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await udCtrl.pickImageFromSource(
                                      ImageSource.camera,
                                      documentName: 'default');
                                })
                          ])));
                });
          }).center().padding(top: Insets.i53, left: Insets.i60)
    ]);
  }
}
