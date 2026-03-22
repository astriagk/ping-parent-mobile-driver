import 'package:skolo_driver/config.dart';

class CommonLocationLayout extends StatelessWidget {
  final String? pickUpAddress;
  final String? droppingAddress;
  final bool? isDottedLine, isHavingDuration;
  final int? index;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CommonLocationLayout(
      {super.key,
      this.droppingAddress,
      this.pickUpAddress,
      this.isDottedLine = true,
      this.index,
      this.isHavingDuration = false,
      this.color,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding ?? EdgeInsets.all(Insets.i15),
        decoration: BoxDecoration(
            color: color ?? appTheme.bgBox,
            borderRadius: SmoothBorderRadius(
                cornerRadius: Insets.i10, cornerSmoothing: Insets.i20)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                SvgPicture.asset(
                    height: Insets.i15, width: Insets.i15, svgAssets.location),
                DottedVerticalLine(index: index ?? 10),
                SvgPicture.asset(
                    height: Insets.i15, width: Insets.i15, svgAssets.gps)
              ]),
              HSpace(Insets.i8),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$pickUpAddress',
                              style: AppCss.lexendLight12
                                  .textColor(appTheme.primary)
                                  .textHeight(1.3)),
                          isHavingDuration == true
                              ? Text('4:36pm  |  Pick up',
                                      style: AppCss.lexendLight12
                                          .textColor(appTheme.textClr))
                                  .marginOnly(top: Insets.i2)
                              : Container()
                        ]),
                    isDottedLine == true
                        ? homeScreenWidget.dottedLineCommon(
                            vertical: Insets.i10)
                        : Divider(color: appTheme.stroke)
                            .marginSymmetric(vertical: Insets.i10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$droppingAddress",
                              style: AppCss.lexendLight12
                                  .textColor(appTheme.primary)
                                  .textHeight(1.3)),
                          isHavingDuration == true
                              ? Text('4:36pm  |  Drop off',
                                      style: AppCss.lexendLight12
                                          .textColor(appTheme.textClr))
                                  .marginOnly(top: Insets.i2)
                              : Container()
                        ])
                  ]))
            ]));
  }
}
