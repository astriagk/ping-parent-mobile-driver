import 'package:taxify_driver_ui/config.dart';

class UserUpdateScreen extends StatelessWidget {
  const UserUpdateScreen({super.key});

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
              appBar: CommonAppBarLayout(
                  title: language(context, appFonts.vehicleDetails),
                  radius: Sizes.s0,
                  titleWidth: MediaQuery.of(context).size.width * 0.02),
              body: udCtrl.isLoading
                  ? const UserDetailsUpdateSkeleton()
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: List.generate(
                                              udCtrl.vehicles.length, (index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  udCtrl.selectedIndex = index;
                                                  udCtrl.notifyListeners();
                                                },
                                                child: Container(
                                                    width: Insets.i75,
                                                    height: Insets.i94,
                                                    decoration: BoxDecoration(
                                                        color: appTheme.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12.0),
                                                        border: Border.all(
                                                            color: udCtrl
                                                                        .selectedIndex ==
                                                                    index
                                                                ? appTheme
                                                                    .primary
                                                                : appTheme
                                                                    .borderColor,
                                                            width: 1)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                                  udCtrl.vehicles[
                                                                          index]
                                                                      ['image'])
                                                              .marginSymmetric(
                                                                  horizontal:
                                                                      Insets
                                                                          .i10),
                                                          VSpace(Insets.i13),
                                                          Text(
                                                              udCtrl.vehicles[
                                                                      index]
                                                                      ['name']
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              style: AppCss
                                                                  .lexendRegular13
                                                                  .textColor(udCtrl
                                                                              .selectedIndex ==
                                                                          index
                                                                      ? appTheme
                                                                          .darkText
                                                                      : appTheme
                                                                          .textClr))
                                                        ]))).padding(
                                                right: Insets.i12);
                                          }))),
                                  VSpace(Insets.i25),
                                  AuthCommonWidgets().textAndTextField(
                                      language(context, appFonts.userName),
                                      language(context, appFonts.enterUserName),
                                      context,
                                      controller: udCtrl.nameController),
                                  VSpace(Insets.i25),
                                  AuthCommonWidgets().textAndTextField(
                                      language(context, appFonts.email),
                                      language(
                                          context, appFonts.enterYourEmailId),
                                      context,
                                      controller: udCtrl.emailController),
                                  VSpace(Insets.i25),
                                  AuthCommonWidgets().textAndTextField(
                                      language(context, appFonts.vehicleNumber),
                                      language(
                                          context, appFonts.enterVehicleNumber),
                                      context,
                                      controller:
                                          udCtrl.vehicleNumberController),
                                  VSpace(Insets.i25),
                                  AuthCommonWidgets().textAndTextField(
                                      language(context, appFonts.maximumSeats),
                                      language(
                                          context, appFonts.enterMaximumSeat),
                                      context,
                                      controller:
                                          udCtrl.vehicleCapacityController,
                                      keyboardType: TextInputType.number)
                                ]).padding(
                                horizontal: Insets.i20, bottom: Insets.i10)
                          ]).authExtension(context),
                          CommonButton(
                                  text: language(context, appFonts.update),
                                  isLoading: udCtrl.isUpdating,
                                  onTap: udCtrl.isUpdating
                                      ? null
                                      : () =>
                                          handleUpdateProfile(context, udCtrl))
                              .padding(horizontal: Sizes.s20)
                              .marginOnly(bottom: Insets.i20, top: Insets.i10)
                        ]))));
    });
  }
}
