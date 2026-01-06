import '../config.dart';

class CommonDropDownMenu extends StatelessWidget {
  final List<DropdownMenuItem<dynamic>>? itemsList; // Change type
  final String? hintText; // to dynamic
  final dynamic value;
  final ValueChanged? onChanged;
  final BorderRadiusGeometry? borderRadius;
  final Widget? underline, icon;
  final String? svgIcon;
  final bool? isSVG;

  const CommonDropDownMenu(
      {super.key,
      this.itemsList,
      this.hintText,
      this.onChanged,
      this.value,
      this.borderRadius,
      this.underline,
      this.svgIcon,
      this.isSVG,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: Container(
              alignment: Alignment.center,
              height: Insets.i55,
              padding: EdgeInsets.symmetric(horizontal: Sizes.s15),
              decoration: BoxDecoration(
                  color: appColor(context).appTheme.white,
                  borderRadius: borderRadius ??
                      SmoothBorderRadius(cornerRadius: Sizes.s8)),
              child: DropdownButton(
                  // Change type to dynamic
                  dropdownColor: appColor(context).appTheme.white,
                  isExpanded: true,
                  icon: icon ??
                      Icon(Icons.keyboard_arrow_down_outlined,
                          color: appColor(context)
                              .appTheme
                              .primary
                              .withValues(alpha: 0.5)),
                  value: value,
                  items: itemsList,
                  underline: underline ?? const SizedBox.shrink(),
                  onChanged: onChanged,
                  hint: Row(
                    children: [
                      if (isSVG == false)
                        Row(children: [
                          SvgPicture.asset("$svgIcon"),
                          HSpace(Sizes.s15)
                        ]),
                      TextWidgetCommon(
                          text: language(context, hintText),
                          style: AppCss.lexendMedium14
                              .textColor(appColor(context).appTheme.lightText))
                    ],
                  ))))
    ]);
  }
}
