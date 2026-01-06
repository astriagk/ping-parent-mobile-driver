import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../config.dart';

class ProfileWidgets {
  //common title and text-field layout
  Widget commonTextField(context,
      {String? title,
      String? hintText,
      String? icon,
      double? vSpace,
      bool isHavingSpace = false,
      TextEditingController? controller,
      TextInputType? textInputType}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(
          text: title,
          style: AppCss.lexendMedium14
              .textColor(appColor(context).appTheme.darkText)),
      isHavingSpace == true ? VSpace(vSpace!) : Container(),
      TextFieldCommon(
              controller: controller,
              hintText: hintText,
              keyboardType: textInputType)
          .padding(top: Sizes.s8, bottom: Sizes.s20)
    ]);
  }

  //profile image and edit button layout
  Widget profileImageLayout(BuildContext context) {
    File? profileImage; // To store the selected image

    Future<void> pickImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        // Trigger a UI update to show the selected image
        (context as Element).markNeedsBuild();
      }
    }

    return Stack(children: [
      // Display the selected image or default image
      (profileImage != null
              ? Image.file(profileImage!, height: Insets.i79, width: Insets.i79)
              : Image.asset(imageAssets.profileImg,
                  height: Insets.i79, width: Insets.i79))
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
                                onTap: () {
                                  Navigator.pop(context);
                                  pickImage(ImageSource.gallery);
                                }),
                            ListTile(
                                leading: Icon(Icons.camera_alt,
                                    color: appTheme.primary),
                                title: Text(
                                    language(context, appFonts.openCamera),
                                    style: AppCss.lexendLight14
                                        .textColor(appTheme.primary)),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickImage(ImageSource.camera);
                                })
                          ])));
                });
          }).center().padding(top: Insets.i53, left: Insets.i60)
    ]);
  }
}
