import 'package:taxify_driver_ui/config.dart';

//common back button
class CommonIconButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? icon;
  final Color? bgColor;
  final double? height, width;

  const CommonIconButton(
      {super.key,
      this.onTap,
      this.icon,
      this.bgColor,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? Sizes.s40,
        width: width ?? Sizes.s40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? appColor(context).appTheme.white),
        child: SvgPicture.asset(icon!,
                width: Sizes.s22, height: Sizes.s22, fit: BoxFit.scaleDown)
            .inkWell(onTap: onTap));
  }
}
