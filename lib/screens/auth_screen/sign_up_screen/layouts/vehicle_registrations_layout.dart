import '../../../../config.dart';

class VehicleRegistrationsLayout extends StatelessWidget {
  const VehicleRegistrationsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(signUpPvr.vehicles.length, (index) {
                  return GestureDetector(
                      onTap: () {
                        signUpPvr.selectedIndex = index;
                        signUpPvr.notifyListeners();
                      },
                      child: Container(
                          width: Insets.i75,
                          height: Insets.i94,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: signUpPvr.selectedIndex == index
                                      ? Colors.black
                                      : Colors.white,
                                  width: 1)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(signUpPvr.vehicles[index]['image'])
                                    .marginSymmetric(horizontal: Insets.i10),
                                VSpace(Insets.i13),
                                Text(
                                    language(context,
                                        signUpPvr.vehicles[index]['name']),
                                    style: AppCss.lexendRegular13.textColor(
                                        signUpPvr.selectedIndex == index
                                            ? appTheme.darkText
                                            : appTheme.textClr))
                              ]))).padding(right: Insets.i12);
                }))),
        VSpace(Insets.i25),
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.vehicleNumber),
            language(context, appFonts.enterVehicleNumber),
            context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(language(context, appFonts.registrationDate),
                language(context, appFonts.enterRegistrationDate), context)
            .padding(vertical: Sizes.s15),
        //title text and text filed layout
        TextWidgetCommon(text: language(context, appFonts.selectVehicleType)),
        VSpace(Sizes.s9),
        CommonDropDownMenu(
                isSVG: true,
                value: signUpPvr.selectedVehicle,
                onChanged: (value) => signUpPvr.onChange(value),
                hintText: language(context, appFonts.selectVehicleType),
                itemsList: signUpPvr.vehicleDropDownItems.map((item) {
                  return DropdownMenuItem<dynamic>(
                      value: item['value'],
                      child:
                          Text(item['label'], style: TextStyle(fontSize: 14)));
                }).toList())
            .padding(bottom: Sizes.s15),
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.vehicleColor),
            language(context, appFonts.enterVehicleColor),
            context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(language(context, appFonts.maximumSeats),
                language(context, appFonts.enterMaximumSeat), context)
            .padding(vertical: Sizes.s15),
        VSpace(Insets.i25),
        Text(language(context, appFonts.selectYourRule),
                style: AppCss.lexendSemiBold18.textColor(appTheme.darkText))
            .padding(bottom: Insets.i15),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: signUpPvr.rules.length,
            itemBuilder: (context, index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(language(context, signUpPvr.rules[index]),
                            style: AppCss.lexendRegular14
                                .textColor(appTheme.textClr))),
                    GestureDetector(
                        onTap: () {
                          signUpPvr.notifyListeners();
                          signUpPvr.isChecked[index] =
                              !signUpPvr.isChecked[index];
                          signUpPvr.notifyListeners();
                        },
                        child: SvgPicture.asset(signUpPvr.isChecked[index]
                            ? svgAssets.tickSquare
                            : svgAssets.tickSquare1))
                  ]).padding(bottom: Insets.i15);
            }),
        VSpace(Insets.i30),
        CommonButton(
                text: language(context, appFonts.next),
                onTap: () => signUpPvr.vehicleRegButton())
            .padding(bottom: Sizes.s20)
      ]);
    });
  }
}
