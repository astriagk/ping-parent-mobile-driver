import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/config/router/app_router.dart';
import 'package:skolo_driver/presentation/features/auth/providers/sign_up_provider.dart';
import 'package:skolo_driver/presentation/features/auth/widgets/index.dart';
import 'package:skolo_driver/presentation/shared/widgets/index.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    final result =
        await ref.read(signUpNotifierProvider.notifier).registerSendOtp(phone);
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
    final isSending = ref.watch(signUpNotifierProvider).isSendingOtp;

    return Scaffold(
        backgroundColor: appColor(context).appTheme.bgBox,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(onTap: () => context.pop()),
                AuthTitleSection(
                    title: language(context, appFonts.createYourAccount),
                    subtitle: language(context, appFonts.exploreYourLife),
                    isSignUp: true,
                    stepIndex: 0),
                TextWidgetCommon(
                    text: language(context, appFonts.mobileNumber),
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.darkText)),
                CountryPhoneField(
                    controller: _phoneController,
                    onCountryChanged: (dialCode) => ref
                        .read(signUpNotifierProvider.notifier)
                        .setCountryCode(dialCode)),
                CommonButton(
                    text: language(context, appFonts.signup),
                    isLoading: isSending,
                    onTap: isSending ? null : _handleRegister),
                RichTextLink(
                        text: language(context, appFonts.alreadyHaveAnAccount),
                        linkText: language(context, appFonts.signIn),
                        onTap: () => context.goNamed(AppRoute.signIn.name))
                    .padding(top: Sizes.s15, bottom: Sizes.s25),
              ])
              .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
              .authExtension(context)
              .padding(bottom: Sizes.s20)
        ])));
  }
}
