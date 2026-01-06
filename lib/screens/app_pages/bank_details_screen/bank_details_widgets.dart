import '../../../config.dart';

class BankDetailsWidgets {
//COMMON TEXT FIELD LAYOUT
  Widget commonTextFieldLayout(context,
      {String? title,
      String? hintText,
      TextEditingController? controller,
      TextInputType? keyboardType}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextWidgetCommon(text: title, fontWeight: FontWeight.w500),
      TextFieldCommon(
              hintText: hintText,
              controller: controller,
              keyboardType: keyboardType)
          .padding(top: Sizes.s8, bottom: Sizes.s15)
    ]);
  }

//branch name title and dropdown layout
  Widget branchDropDownLayout() {
    return Consumer<BankDetailsProvider>(builder: (context, bdCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(text: appFonts.branchName),
        CommonDropDownMenu(
                isSVG: true,
                value: bdCtrl.branch,
                onChanged: (newValue) => bdCtrl.branchChange(newValue),
                hintText: appFonts.branchName,
                itemsList: bdCtrl.branchDropDownItems
                    .map((item) => DropdownMenuItem<dynamic>(
                        value: item['value'],
                        child: TextWidgetCommon(text: item['label'])))
                    .toList())
            .padding(top: Sizes.s8, bottom: Sizes.s15)
      ]);
    });
  }
}
