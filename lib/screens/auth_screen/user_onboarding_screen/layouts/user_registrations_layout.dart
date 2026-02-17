import '../../../../../config.dart';

class UserRegistrationsLayout extends StatelessWidget {
  const UserRegistrationsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(builder: (context, pvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(pvr.vehicles.length, (index) {
                  return GestureDetector(
                      onTap: () {
                        pvr.selectedIndex = index;
                        pvr.notifyListeners();
                      },
                      child: Container(
                          width: Insets.i75,
                          height: Insets.i94,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: pvr.selectedIndex == index
                                      ? Colors.black
                                      : Colors.white,
                                  width: 1)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(pvr.vehicles[index]['image'])
                                    .marginSymmetric(horizontal: Insets.i10),
                                VSpace(Insets.i13),
                                Text(
                                    language(
                                        context, pvr.vehicles[index]['name']),
                                    style: AppCss.lexendRegular13.textColor(pvr
                                                .selectedIndex ==
                                            index
                                        ? appColor(context).appTheme.darkText
                                        : appColor(context).appTheme.textClr))
                              ]))).padding(right: Insets.i12);
                }))),
        VSpace(Insets.i25),
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.userName),
            language(context, appFonts.enterUserName),
            context,
            controller: pvr.nameController),
        VSpace(Insets.i25),
        AuthCommonWidgets().textAndTextField(language(context, appFonts.email),
            language(context, appFonts.enterYourEmailId), context,
            controller: pvr.emailController),
        VSpace(Insets.i25),
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.vehicleNumber),
            language(context, appFonts.enterVehicleNumber),
            context,
            controller: pvr.vehicleNumberController),
        //title text and text filed layout
        // AuthCommonWidgets()
        //     .textAndTextField(language(context, appFonts.registrationDate),
        //         language(context, appFonts.enterRegistrationDate), context)
        //     .padding(vertical: Sizes.s15),
        //title text and text filed layout
        // TextWidgetCommon(text: language(context, appFonts.selectVehicleType)),
        // VSpace(Sizes.s9),
        // CommonDropDownMenu(
        //         isSVG: true,
        //         value: pvr.selectedVehicle,
        //         onChanged: (value) => pvr.onChange(value),
        //         hintText: language(context, appFonts.selectVehicleType),
        //         itemsList: pvr.vehicleDropDownItems.map((item) {
        //           return DropdownMenuItem<dynamic>(
        //               value: item['value'],
        //               child:
        //                   Text(item['label'], style: TextStyle(fontSize: 14)));
        //         }).toList())
        //     .padding(bottom: Sizes.s15),
        // AuthCommonWidgets().textAndTextField(
        //     language(context, appFonts.vehicleColor),
        //     language(context, appFonts.enterVehicleColor),
        //     context),

        VSpace(Insets.i25),
        //title text and text filed layout
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.maximumSeats),
            language(context, appFonts.enterMaximumSeat),
            context,
            controller: pvr.vehicleCapacityController,
            keyboardType: TextInputType.number),
        // VSpace(Insets.i25),
        // Rules Section
        // Text(language(context, appFonts.selectYourRule),
        //         style: AppCss.lexendSemiBold18.textColor(appTheme.darkText))
        //     .padding(bottom: Insets.i15),
        // ListView.builder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     padding: EdgeInsets.zero,
        //     shrinkWrap: true,
        //     itemCount: pvr.rules.length,
        //     itemBuilder: (context, index) {
        //       return Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //                 child: Text(language(context, pvr.rules[index]),
        //                     style: AppCss.lexendRegular14
        //                         .textColor(appTheme.textClr))),
        //             GestureDetector(
        //                 onTap: () {
        //                   pvr.isChecked[index] = !pvr.isChecked[index];
        //                   pvr.notifyListeners();
        //                 },
        //                 child: SvgPicture.asset(pvr.isChecked[index]
        //                     ? svgAssets.tickSquare
        //                     : svgAssets.tickSquare1))
        //           ]).padding(bottom: Insets.i15);
        //     }),
        VSpace(Insets.i30),
        CommonButton(
                text: language(context, appFonts.next),
                isLoading: pvr.isCreatingProfile,
                onTap: pvr.isCreatingProfile
                    ? null
                    : () async {
                        await pvr.handleUserRegistration(context);
                      })
            .padding(bottom: Sizes.s20)
      ]);
    });
  }
}
