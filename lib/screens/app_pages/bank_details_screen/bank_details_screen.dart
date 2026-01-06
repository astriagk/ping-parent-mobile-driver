import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/app_pages/bank_details_screen/bank_details_widgets.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailsProvider>(builder: (context, bdCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationClass.ms150, () => bdCtrl.init()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  titleWidth: MediaQuery.of(context).size.width * 0.02,
                  title: appFonts.bankDetails,
                  radius: Sizes.s0),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          BankDetailsWidgets().commonTextFieldLayout(context,
                              title: appFonts.bankName,
                              hintText: appFonts.enterBankName,
                              controller: bdCtrl.bankName),
                          BankDetailsWidgets().commonTextFieldLayout(context,
                              title: appFonts.holderName,
                              hintText: appFonts.enterHolderName,
                              controller: bdCtrl.holderName),
                          BankDetailsWidgets().commonTextFieldLayout(context,
                              title: appFonts.accountNo,
                              hintText: appFonts.enterAccountNo,
                              controller: bdCtrl.accountNo,
                              keyboardType: TextInputType.number),
                          //branch name title and dropdown layout
                          BankDetailsWidgets().branchDropDownLayout(),
                          BankDetailsWidgets().commonTextFieldLayout(context,
                              title: appFonts.ifscCode,
                              hintText: appFonts.ifscHint,
                              controller: bdCtrl.ifscCode)
                        ])
                        .padding(horizontal: Sizes.s20)
                        .authExtension(context),
                    CommonButton(
                            text: appFonts.update,
                            onTap: () => route.pop(context))
                        .padding(horizontal: Sizes.s20)
                        .marginOnly(bottom: Insets.i20)
                  ])));
    });
  }
}
