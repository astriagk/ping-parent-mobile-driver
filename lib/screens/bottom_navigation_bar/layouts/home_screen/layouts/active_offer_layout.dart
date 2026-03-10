import 'package:skolo_driver/config.dart';

class ActiveOfferLayout extends StatelessWidget {
  const ActiveOfferLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homePvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        appArray.offers.isEmpty
            ? Container()
            : Text(language(context, appFonts.activeOffer),
                style: AppCss.lexendBold16.textColor(appTheme.primary)),
        VSpace(Insets.i12),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: appArray.offers.length,
            itemBuilder: (context, index) {
              final offer = appArray.offers[index];
              return OfferCard(
                      editOnTap: () => homePvr.editOnTap(context),
                      deleteOnTap: () => homePvr.deleteOnTap(index),
                      name: language(context, offer['name']),
                      discountText: language(context, offer['discountText']),
                      carType: language(context, offer['carType']),
                      peopleCount: offer['peopleCount'],
                      validTill: language(context, offer['validTill']),
                      isToggled: offer['isToggled'],
                      onToggle: () => homePvr.activeOfferToggle(offer))
                  .marginOnly(bottom: Insets.i15);
            })
      ]).marginSymmetric(horizontal: Insets.i20);
    });
  }
}
