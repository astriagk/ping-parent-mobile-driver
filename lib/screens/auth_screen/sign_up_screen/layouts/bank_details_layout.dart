import '../../../../config.dart';

class BankDetailsLayout extends StatelessWidget {
  const BankDetailsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.holderName),
            language(context, appFonts.enterHolderName),
            context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(language(context, appFonts.accountNumber),
                language(context, appFonts.enterAccountNumber), context)
            .padding(vertical: Sizes.s15),
        //title text and text filed layout
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.ifscCode),
            language(context, appFonts.enterIfscCode),
            context),
        //title text and text filed layout
        AuthCommonWidgets()
            .textAndTextField(language(context, appFonts.bankName),
                language(context, appFonts.enterBankName), context)
            .padding(vertical: Sizes.s15),
        //title text and text filed layout
        AuthCommonWidgets().textAndTextField(
            language(context, appFonts.branchName),
            language(context, appFonts.enterBranchName),
            context),
        VSpace(Insets.i30),
        CommonButton(
                text: language(context, appFonts.next),
                onTap: () => signUpPvr.bankDetails(context))
            .padding(bottom: Sizes.s20),
      ]);
    });
  }
}
