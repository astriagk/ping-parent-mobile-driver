import 'package:taxify_driver_ui/config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homePvr, child) {
      return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          VSpace(Insets.i16),
          Stack(alignment: Alignment.centerLeft, children: [
            Image.asset(imageAssets.homeWallet),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(language(context, appFonts.totalEarning),
                  style: AppCss.lexendRegular12.textColor(appTheme.walletClr)),
              VSpace(Insets.i4),
              Text("\$${language(context, appFonts.balance)}",
                  style: AppCss.lexendBold16.textColor(appTheme.white))
            ]).paddingOnly(left: Insets.i15)
          ]),
          VSpace(Insets.i16),
          const RideDataLayout()
        ]).marginSymmetric(horizontal: Insets.i20),
        const UpcomingRidesList(),
        const ActiveOfferLayout()
      ]));
    });
  }
}
