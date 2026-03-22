import 'package:skolo_driver/config.dart';

/// Molecule — Back button + app logo row shown at the top of auth screens.
class AuthHeader extends StatelessWidget {
  final GestureTapCallback? onTap;

  const AuthHeader({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonIconButton(
                onTap: onTap ?? () => route.pop(context), icon: svgAssets.back)
            .marginOnly(right: MediaQuery.of(context).size.width * 0.2),
        SvgPicture.asset(svgAssets.logo, height: Sizes.s30, width: Sizes.s70),
        Container(),
      ],
    ).padding(
        top: MediaQuery.of(context).padding.top + Sizes.s15, bottom: Sizes.s5);
  }
}
