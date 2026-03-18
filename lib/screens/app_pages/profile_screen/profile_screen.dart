import 'package:skolo_driver/screens/app_pages/profile_screen/profile_widgets.dart';

import '../../../config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Handle update profile submission
  Future<void> handleUpdateProfile(
    BuildContext context,
    UserDetailsUpdateProvider udCtrl,
  ) async {
    final success = await udCtrl.updateDriverProfile();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
              text: udCtrl.successMessage ?? 'Profile updated successfully'),
        ),
      );
      if (context.mounted) route.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
              text: udCtrl.errorMessage ?? 'Failed to update profile'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsUpdateProvider>(
        builder: (context, udCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationClass.ms150, () => udCtrl.onInit()),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: appColor(context).appTheme.white,
              appBar: CommonAppBarLayout(
                  titleWidth: MediaQuery.of(context).size.width * 0.02,
                  title: appFonts.profileSetting,
                  radius: Sizes.s20),
              body: udCtrl.isLoading
                  ? const ProfileUpdateSkeleton()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                //profile image and edit button layout
                                ProfileWidgets()
                                    .profileImageLayout(context, udCtrl),
                                Divider(
                                        color:
                                            appColor(context).appTheme.stroke,
                                        height: 0)
                                    .padding(top: Sizes.s25, bottom: Sizes.s20),
                                //common title and text-field layout
                                ProfileWidgets().commonTextField(context,
                                    title: appFonts.userName,
                                    isHavingSpace: true,
                                    vSpace: 5,
                                    hintText: appFonts.enterYourName,
                                    controller: udCtrl.nameController),
                                //common title and text-field layout - disabled (read-only)
                                ProfileWidgets().commonTextField(context,
                                    title: appFonts.mobileNumber,
                                    isHavingSpace: true,
                                    vSpace: 5,
                                    hintText: appFonts.enterYourNumber,
                                    textInputType: TextInputType.number,
                                    controller: udCtrl.phoneNumberController,
                                    readOnly: true,
                                    isDisabled: true),
                                //common title and text-field layout - disabled (read-only)
                                ProfileWidgets().commonTextField(context,
                                    title: appFonts.email,
                                    isHavingSpace: true,
                                    vSpace: 5,
                                    hintText: appFonts.enterYourEmailId,
                                    controller: udCtrl.emailController)
                              ])
                              .padding(horizontal: Sizes.s20)
                              .authExtension(context),
                          CommonButton(
                                  text: appFonts.update,
                                  isLoading: udCtrl.isUpdating,
                                  onTap: udCtrl.isUpdating
                                      ? null
                                      : () =>
                                          handleUpdateProfile(context, udCtrl))
                              .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                        ])));
    });
  }
}
