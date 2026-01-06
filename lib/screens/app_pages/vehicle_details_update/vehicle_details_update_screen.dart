import 'dart:developer';

import 'package:taxify_driver_ui/config.dart';

class VehicleUpdateScreen extends StatelessWidget {
  const VehicleUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailsProvider>(builder: (context, bdCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationClass.ms150, () => bdCtrl.onInit()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  title: language(context, appFonts.vehicleDetails),
                  radius: Sizes.s0,
                  titleWidth: MediaQuery.of(context).size.width * 0.02),
              body: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Column(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: Insets.i75,
                                height: Insets.i94,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/image/auth/bike.png')
                                          .marginSymmetric(
                                              horizontal: Insets.i10),
                                      VSpace(Insets.i13),
                                      Text(language(context, appFonts.bike),
                                          style: AppCss.lexendRegular13
                                              .textColor(appTheme.darkText))
                                    ])),
                            VSpace(Insets.i25),
                            AuthCommonWidgets()
                                .textAndTextField(
                                    language(context, appFonts.vehicleName),
                                    language(
                                        context, appFonts.enterVehicleName),
                                    context)
                                .padding(bottom: Sizes.s15),
                            AuthCommonWidgets()
                                .textAndTextField(
                                    language(
                                        context, appFonts.registrationDate),
                                    language(context,
                                        appFonts.enterRegistrationDate),
                                    context)
                                .padding(bottom: Sizes.s15),
                            TextWidgetCommon(
                                text: language(
                                    context, appFonts.selectVehicleType)),
                            VSpace(Sizes.s9),
                            CommonDropDownMenu(
                                    isSVG: true,
                                    value: bdCtrl.selectedVehicle,
                                    onChanged: (value) =>
                                        bdCtrl.onChange(value),
                                    hintText: language(
                                        context, appFonts.selectVehicleType),
                                    itemsList:
                                        bdCtrl.vehicleDropDownItems.map((item) {
                                      return DropdownMenuItem<dynamic>(
                                          value: item['value'],
                                          child: Text(item['label'],
                                              style: TextStyle(fontSize: 14)));
                                    }).toList())
                                .padding(bottom: Sizes.s15),
                            AuthCommonWidgets()
                                .textAndTextField(
                                    language(context, appFonts.vehicleColor),
                                    language(
                                        context, appFonts.enterVehicleColor),
                                    context)
                                .padding(bottom: Sizes.s15),
                            AuthCommonWidgets()
                                .textAndTextField(
                                    language(context, appFonts.maximumSeats),
                                    language(
                                        context, appFonts.enterMaximumSeat),
                                    context)
                                .padding(bottom: Sizes.s15)
                          ]).padding(horizontal: Insets.i20, bottom: Insets.i10)
                    ]).authExtension(context),
                    VSpace(Insets.i25),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, appFonts.selectYourRule),
                                  style: AppCss.lexendSemiBold18
                                      .textColor(appTheme.darkText))
                              .padding(bottom: Insets.i15),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: bdCtrl.rules.length,
                              itemBuilder: (context, index) {
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                              language(
                                                  context, bdCtrl.rules[index]),
                                              style: AppCss.lexendRegular14
                                                  .textColor(
                                                      appTheme.textClr))),
                                      SvgPicture.asset(bdCtrl.isChecked[index]
                                          ? svgAssets.tickSquare
                                          : svgAssets.tickSquare1)
                                    ]).inkWell(onTap: () {
                                  bdCtrl.isChecked[index] =
                                      !bdCtrl.isChecked[index];
                                  bdCtrl.notifyListeners();
                                  log("message");
                                }).padding(bottom: Insets.i15);
                              })
                        ]).padding(horizontal: Sizes.s20),
                    CommonButton(
                            text: language(context, appFonts.update),
                            onTap: () => route.pop(context))
                        .padding(horizontal: Sizes.s20)
                        .marginOnly(bottom: Insets.i20, top: Insets.i10)
                  ]))));
    });
  }
}
