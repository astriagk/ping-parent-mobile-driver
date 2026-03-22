import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/config/router/app_router.dart';
import 'package:skolo_driver/presentation/features/auth/providers/sign_in_provider.dart';
import 'package:skolo_driver/presentation/features/auth/widgets/index.dart';
import 'package:skolo_driver/presentation/shared/widgets/index.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    final result =
        await ref.read(signInNotifierProvider.notifier).sendOtp(phone);
    if (!mounted) return;
    if (result.success) {
      _phoneController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
                text: result.message ?? appFonts.otpSentSuccessfully)),
      );
      context.goNamed(AppRoute.otp.name);
    } else if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidgetCommon(text: result.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(signInNotifierProvider).isSendingOtp;

    return Scaffold(
        backgroundColor: appColor(context).appTheme.bgBox,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(svgAssets.logo,
                        height: Sizes.s30, width: Sizes.s70)
                    .center()
                    .padding(
                        top: MediaQuery.of(context).padding.top + Sizes.s15,
                        bottom: Sizes.s15),
                AuthTitleSection(
                    title: language(context, appFonts.letsYouIn),
                    subtitle: language(context, appFonts.heyYouHaveBeenMissed)),
                TextWidgetCommon(
                    text: language(context, appFonts.phoneNumber),
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.darkText)),
                CountryPhoneField(
                    controller: _phoneController,
                    onCountryChanged: (dialCode) => ref
                        .read(signInNotifierProvider.notifier)
                        .setCountryCode(dialCode)),
                CommonButton(
                    text: language(context, appFonts.getOTP),
                    isLoading: isSending,
                    onTap: isSending ? null : _handleSendOtp),
                AuthDivider().padding(vertical: Sizes.s15),
                SocialLoginButton(
                    label: appFonts.withGoogleId,
                    iconAsset: svgAssets.googleLogo),
                RichTextLink(
                        text: language(context, appFonts.newUser),
                        linkText: language(context, appFonts.signup),
                        onTap: () => context.goNamed(AppRoute.signUp.name))
                    .padding(bottom: Sizes.s25, top: Sizes.s15)
              ]).padding(horizontal: Sizes.s20).authExtension(context),
          AuthBottomImage()
        ]).height(MediaQuery.of(context).size.height));
  }
}
