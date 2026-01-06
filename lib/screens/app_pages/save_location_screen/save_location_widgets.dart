import '../../../config.dart';

class SaveLocationWidgets {
  //save location page save address layout
  Widget saveAddressLayout(e, BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SvgPicture.asset(svgAssets.saveLocation),
      HSpace(Sizes.s3),
      Expanded(
          child: TextWidgetCommon(
              textAlign: TextAlign.start,
              text: e['address'],
              style: AppCss.lexendLight12
                  .textColor(appColor(context).appTheme.darkText)))
    ]).saveLocationExtension(context);
  }
}
