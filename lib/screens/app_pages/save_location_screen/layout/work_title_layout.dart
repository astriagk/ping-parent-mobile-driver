import '../../../../config.dart';

//ICON WORK OR HOME EDIT AND DELETE LAYOUT
class WorkTitleLayout extends StatelessWidget {
  final dynamic e;

  const WorkTitleLayout({super.key, this.e});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        CommonIconButton(icon: e['icon']),
        HSpace(Sizes.s10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidgetCommon(
                  text: e['title'],
                  style: AppCss.lexendRegular14
                      .textColor(appColor(context).appTheme.darkText)),
              TextWidgetCommon(
                  text: language(context, appFonts.mobNo1),
                  style: TextStyle(
                      color: appColor(context).appTheme.lightText,
                      fontSize: Sizes.s12,
                      fontFamily: GoogleFonts.lexend().fontFamily,
                      fontWeight: FontWeight.w300))
            ])
      ]),
      Row(children: [
        SvgPicture.asset(svgAssets.edit),
        VerticalDivider(color: appColor(context).appTheme.stroke, width: 0)
            .padding(vertical: Sizes.s8, horizontal: Sizes.s10),
        SvgPicture.asset(svgAssets.trashRed)
      ])
    ]).padding(all: Sizes.s15));
  }
}
