import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWalletProvider>(builder: (context, myWalletPvr, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              title: language(context, appFonts.myWallet),
              titleWidth: MediaQuery.of(context).size.width * 0.01),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(alignment: Alignment.centerLeft, children: [
                  Image.asset('assets/image/settings/my_wallet.png',
                      width: double.infinity),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language(context, appFonts.totalBalance),
                                  style: AppCss.lexendRegular12
                                      .textColor(appTheme.walletClr)),
                              VSpace(Insets.i4),
                              Text("\$${language(context, appFonts.balance)}",
                                  style: AppCss.lexendBold16
                                      .textColor(appTheme.white))
                            ]),
                        Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Insets.i15,
                                    vertical: Insets.i12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: appTheme.yellowIcon,
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: AppRadius.r6,
                                        cornerSmoothing: AppRadius.r100)),
                                child: Text(
                                    language(context, appFonts.topUpWallet),
                                    style: AppCss.lexendSemiBold14
                                        .textColor(appTheme.primary)))
                            .inkWell(onTap: () {
                          route.pushNamed(context, routeName.topUpWalletScreen);
                        })
                      ]).paddingSymmetric(horizontal: Insets.i20)
                ]).marginSymmetric(vertical: Insets.i25),
                Row(children: [
                  Expanded(
                      child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: Insets.i15),
                              height: Insets.i38,
                              decoration: BoxDecoration(
                                  color: myWalletPvr.showEarnings
                                      ? appTheme.primary
                                      : appTheme.bgBox,
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r6,
                                      cornerSmoothing: AppRadius.r100)),
                              child: Text(
                                  language(context, appFonts.totalEarning),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.white
                                          : appTheme.textClr)))
                          .inkWell(onTap: () {
                    myWalletPvr.showEarnings = true;
                    myWalletPvr.notifyListeners();
                  })),
                  HSpace(Insets.i15),
                  Expanded(
                      child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: Insets.i15),
                              height: Insets.i38,
                              decoration: BoxDecoration(
                                  color: myWalletPvr.showEarnings
                                      ? appTheme.bgBox
                                      : appTheme.primary,
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r6,
                                      cornerSmoothing: AppRadius.r100)),
                              child: Text(
                                  language(context, appFonts.withdrawHistory),
                                  style: AppCss.lexendRegular14.textColor(
                                      myWalletPvr.showEarnings
                                          ? appTheme.textClr
                                          : appTheme.white)))
                          .inkWell(onTap: () {
                    myWalletPvr.showEarnings = false;
                    myWalletPvr.notifyListeners();
                  }))
                ]),
                Expanded(
                    child: ListView.builder(
                        itemCount: myWalletPvr.showEarnings
                            ? appArray.totalEarningTransactions.length
                            : appArray.withdrawHistory.length,
                        itemBuilder: (context, index) {
                          final transaction = myWalletPvr.showEarnings
                              ? appArray.totalEarningTransactions[index]
                              : appArray.withdrawHistory[index];
                          /*     return ListTile(
                              leading: const Icon(Icons.receipt_long_outlined),
                              title: Text(transaction['type'],
                                  style: const TextStyle(fontSize: 16)),
                              subtitle: Text(transaction['id']),
                              trailing: Text(
                                  '${transaction['isCredit'] ? '+' : '-'} \$${transaction['amount']}',
                                  style: TextStyle(
                                      color: transaction['isCredit']
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)));*/
                          return CommonBgLayout(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                Row(children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: appTheme.bgBox,
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: Insets.i6)),
                                      padding: EdgeInsets.all(Insets.i7),
                                      child:
                                          SvgPicture.asset(svgAssets.receipt)),
                                  HSpace(Insets.i10),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            language(
                                                context, transaction['type']),
                                            style: AppCss.lexendRegular12
                                                .textColor(appTheme.textClr)),
                                        VSpace(Insets.i6),
                                        Text(transaction['id'],
                                            style: AppCss.lexendRegular12
                                                .textColor(appTheme.primary))
                                      ])
                                ]),
                                Row(children: [
                                  SvgPicture.asset(transaction['isCredit']
                                      ? svgAssets.received
                                      : svgAssets.send1),
                                  Text(
                                      '\$${language(context, transaction['amount'].toString())}',
                                      style: AppCss.lexendSemiBold14.textColor(
                                          transaction['isCredit']
                                              ? appTheme.priceClr
                                              : appTheme.alertZone))
                                ])
                              ])).marginSymmetric(vertical: 6);
                        })),
                CommonButton(
                    text: language(context, appFonts.withdraw),
                    onTap: () {
                      route.pushNamed(context, routeName.withdrawScreen);
                    }).marginOnly(bottom: Insets.i20)
              ]).marginSymmetric(horizontal: Insets.i20));
    });
  }
}
