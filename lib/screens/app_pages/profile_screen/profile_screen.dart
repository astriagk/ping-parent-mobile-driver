import 'package:taxify_driver_ui/screens/app_pages/profile_screen/profile_widgets.dart';

import '../../../config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColor(context).appTheme.white,
        appBar: CommonAppBarLayout(
            titleWidth: MediaQuery.of(context).size.width * 0.02,
            title: appFonts.profileSetting,
            radius: Sizes.s20),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //profile image and edit button layout
                    ProfileWidgets().profileImageLayout(context),
                    Divider(color: appColor(context).appTheme.stroke, height: 0)
                        .padding(top: Sizes.s25, bottom: Sizes.s20),
                    //common title and text-field layout
                    ProfileWidgets().commonTextField(context,
                        title: appFonts.userName,
                        isHavingSpace: true,
                        vSpace: 5,
                        hintText: appFonts.enterYourName),
                    //common title and text-field layout
                    ProfileWidgets().commonTextField(context,
                        title: appFonts.mobileNumber,
                        isHavingSpace: true,
                        vSpace: 5,
                        hintText: appFonts.enterYourNumber,
                        textInputType: TextInputType.number),
                    //common title and text-field layout
                    ProfileWidgets().commonTextField(context,
                        title: appFonts.email,
                        isHavingSpace: true,
                        vSpace: 5,
                        hintText: appFonts.enterYourEmailId)
                  ]).padding(horizontal: Sizes.s20).authExtension(context),
              CommonButton(
                      text: appFonts.updateProfile,
                      onTap: () => route.pop(context))
                  .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
            ]));
  }
}
