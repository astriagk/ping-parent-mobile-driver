import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/presentation/features/auth/widgets/sign_up_step_divider.dart';

/// Molecule — Title + subtitle block shown at the top of auth screens.
///
/// When [isSignUp] is true, renders a [SignUpStepDivider] above the text
/// instead of the success gif.
class AuthTitleSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSignUp;
  final int stepIndex;

  const AuthTitleSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSignUp = false,
    this.stepIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isSignUp
            ? SignUpStepDivider(index: stepIndex)
            : Image.asset(gifAssets.successGif,
                    height: Sizes.s10, width: Sizes.s50, fit: BoxFit.fill)
                .marginOnly(top: Sizes.s30, bottom: Sizes.s6),
        TextWidgetCommon(
            text: title,
            style: AppCss.lexendMedium22
                .textColor(appColor(context).appTheme.darkText)),
        TextWidgetCommon(
                text: subtitle,
                style: AppCss.lexendRegular13
                    .textColor(appColor(context).appTheme.lightText))
            .padding(top: Sizes.s8, bottom: Sizes.s30),
      ],
    );
  }
}
