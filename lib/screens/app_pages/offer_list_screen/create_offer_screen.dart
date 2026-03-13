import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/widgets/common_bg_layout.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferListProvider>(builder: (context, promoCtrl, child) {
      return SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
            Container(
                padding: EdgeInsets.only(
                    bottom: Sizes.s20,
                    top: Sizes.s25,
                    right: Sizes.s20,
                    left: Sizes.s20),
                decoration: BoxDecoration(
                    color: appTheme.bgBox,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonIconButton(
                                icon: svgAssets.back,
                                onTap: () => route.pop(context)),
                            // HSpace(MediaQuery.of(context).size.width * 0.19),
                            Text(language(context, appFonts.createOffer),
                                textAlign: TextAlign.center,
                                style: AppCss.lexendSemiBold20.textColor(
                                    appColor(context).appTheme.darkText)),
                            CommonIconButton(
                                bgColor:
                                    appTheme.alertZone.withValues(alpha: .1),
                                icon: svgAssets.bin,
                                onTap: () => route.pop(context)),
                          ]),
                      VSpace(Insets.i35),
                      AuthCommonWidgets()
                          .textAndTextField(
                              language(context, appFonts.vehicleType),
                              language(context, appFonts.enterVehicleType),
                              context)
                          .padding(bottom: Sizes.s20),
                      AuthCommonWidgets()
                          .textAndTextField(
                              language(context, appFonts.discount),
                              language(context, appFonts.enterDiscount),
                              context)
                          .padding(bottom: Sizes.s20),
                      Row(children: [
                        Expanded(
                            child: AuthCommonWidgets().textAndTextField(
                                language(context, appFonts.startDate),
                                language(context, appFonts.startDate),
                                context)),
                        HSpace(Insets.i15),
                        Expanded(
                            child: AuthCommonWidgets().textAndTextField(
                                language(context, appFonts.endDate),
                                language(context, appFonts.endDate),
                                context))
                      ]).padding(bottom: Sizes.s20),
                      /* ContainerCommon(
                            title: language(context, appFonts.availableSeats),
                            height: Insets.i54,
                            suffixIcon: SvgPicture.asset(svgAssets.arrowDown),
                            hintText:
                                language(context, appFonts.selectAvailableSeats),
                            borderRadius: BorderRadius.circular(6)),*/
                      TextWidgetCommon(
                          text: language(context, appFonts.availableSeats)),
                      VSpace(Sizes.s9),
                      CommonDropDownMenu(
                              icon: SvgPicture.asset(svgAssets.arrowDown),
                              isSVG: true,
                              value: promoCtrl.selectedSeats,
                              onChanged: (value) => promoCtrl.onChange(value),
                              hintText: language(
                                  context, appFonts.selectAvailableSeats),
                              itemsList:
                                  promoCtrl.vehicleDropDownItems.map((item) {
                                return DropdownMenuItem<dynamic>(
                                    value: item['value'],
                                    child: Text(item['label'],
                                        style: TextStyle(fontSize: 14)));
                              }).toList())
                          .padding(bottom: Sizes.s20),
                      TextWidgetCommon(
                          text: language(context, appFonts.availableArea)),
                      VSpace(Sizes.s9),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                flex: 2,
                                child: TextFieldCommon(
                                        hintText: language(context,
                                            appFonts.enterAvailableArea),
                                        color:
                                            appColor(context).appTheme.screenBg)
                                    .padding(bottom: Sizes.s15)),
                            HSpace(Insets.i10),
                            Expanded(
                                child: CommonDropDownMenu(
                                        isSVG: true,
                                        icon: SvgPicture.asset(
                                            svgAssets.arrowDown),
                                        value: promoCtrl.selectedArea,
                                        onChanged: (value) =>
                                            promoCtrl.onChangeArea(value),
                                        hintText:
                                            language(context, appFonts.km1),
                                        itemsList: promoCtrl.area.map((item) {
                                          return DropdownMenuItem<dynamic>(
                                              value: item['value'],
                                              child: Text(item['label'],
                                                  style:
                                                      TextStyle(fontSize: 14)));
                                        }).toList())
                                    .padding(bottom: Sizes.s15))
                          ]),
                      DottedLine(dashColor: appTheme.stroke)
                          .paddingOnly(bottom: Insets.i15),
                      CommonBgLayout(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      language(
                                          context, appFonts.offerActiveStatus),
                                      style: AppCss.lexendRegular13
                                          .textColor(appTheme.primary)),
                                  GestureDetector(
                                      onTap: () => promoCtrl.activeStatusTap(),
                                      child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: Insets.i35,
                                          height: Insets.i22,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Insets.i4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadius.r50),
                                              color: promoCtrl.isOfferActive
                                                  ? Colors.black
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: promoCtrl.isOfferActive
                                                      ? appTheme.trans
                                                      : appTheme.stroke,
                                                  width: Insets.i1)),
                                          child: AnimatedAlign(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              alignment: promoCtrl.isOfferActive
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Container(
                                                  width: Insets.i12,
                                                  height: Insets.i12,
                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: promoCtrl.isOfferActive ? appTheme.white : appTheme.textClr)))))
                                ]),
                            VSpace(Insets.i8),
                            Text(
                                textAlign: TextAlign.start,
                                language(context, appFonts.youCanDeactivate),
                                style: AppCss.lexendLight12
                                    .textColor(appTheme.textClr),
                                overflow: TextOverflow.fade)
                          ]))
                    ])),
            CommonButton(
                onTap: () => route.pop(context),
                text: language(context, appFonts.createOffer),
                margin: EdgeInsets.only(
                    left: Insets.i20, right: Insets.i20, top: Insets.i75))
          ]))));
    });
  }
}
