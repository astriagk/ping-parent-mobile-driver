import 'package:skolo_driver/config.dart';

class CommonBgLayout extends StatelessWidget {
  final Widget child;
  final bool? isBorder;
  final Color? color;
  final double? cornerRadius, width;
  final EdgeInsetsGeometry? padding;

  const CommonBgLayout(
      {super.key,
      required this.child,
      this.isBorder = true,
      this.color,
      this.cornerRadius,
      this.width,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: padding ?? EdgeInsets.all(Insets.i15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: appTheme.primary.withValues(alpha: 0.06),
                  offset: const Offset(0, 4),
                  blurRadius: Insets.i20,
                  blurStyle: BlurStyle.normal)
            ],
            color: color ?? appTheme.white,
            border: isBorder == true
                ? Border.all(width: 1, color: appTheme.bgBox)
                : null,
            borderRadius: SmoothBorderRadius(
                cornerRadius: cornerRadius ?? Insets.i10, cornerSmoothing: 20)),
        child: child);
  }
}
