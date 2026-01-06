import '../config.dart';

//common back button
class CommonIconButton1 extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? icon;
  final Color? bgColor;
  final double? height;
  final double? width;
  final double? iconHeight;
  final double? iconWidth;
  final bool? isImage;
  final String? imageIcon;

  const CommonIconButton1(
      {super.key,
      this.onTap,
      this.icon,
      this.bgColor,
      this.height,
      this.width,
      this.iconHeight,
      this.iconWidth,
      this.imageIcon,
      this.isImage});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? Sizes.s40,
        width: width ?? Sizes.s40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? appColor(context).appTheme.white),
        child: isImage == true
            ? Image.asset(
                icon!,
                fit: BoxFit.fill,
              )
            : SvgPicture.asset(icon!,
                    width: iconWidth ?? Sizes.s22,
                    height: iconHeight ?? Sizes.s22,
                    fit: BoxFit.scaleDown)
                .inkWell(onTap: onTap));
  }
}
