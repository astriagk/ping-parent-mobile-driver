import '../config.dart';

class CommonDivider extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Color? color;

  const CommonDivider({super.key, this.margin, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin ??
            EdgeInsets.only(top: Insets.i2, left: Insets.i7, right: Insets.i7),
        height: height ?? Insets.i8,
        decoration: BoxDecoration(
            border:
                Border.all(width: Insets.i1, color: color ?? appTheme.stroke)));
  }
}
