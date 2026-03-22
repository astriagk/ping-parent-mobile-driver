import 'package:skolo_driver/config.dart';

/// Atom — Multi-step progress indicator for the sign-up flow.
///
/// Renders four coloured bars; bars up to and including [index] are filled.
class SignUpStepDivider extends StatelessWidget {
  final int index;

  const SignUpStepDivider({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _bar(context, index >= 0)),
        SizedBox(width: Insets.i6),
        Expanded(child: _bar(context, index >= 1)),
        SizedBox(width: Insets.i6),
        Expanded(child: _bar(context, index >= 2)),
        SizedBox(width: Insets.i6),
        Expanded(child: _bar(context, index >= 3)),
      ],
    ).marginOnly(top: Sizes.s20, bottom: Sizes.s24);
  }

  Widget _bar(BuildContext context, bool active) => Container(
        height: Insets.i4,
        decoration: BoxDecoration(
          color: active
              ? appColor(context).appTheme.darkText
              : appColor(context).appTheme.white,
          borderRadius: BorderRadius.circular(AppRadius.r6),
        ),
      );
}
