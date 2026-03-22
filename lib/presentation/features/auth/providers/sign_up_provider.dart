import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/data/datasources/remote/auth_service.dart';
import 'package:skolo_driver/presentation/features/auth/providers/sign_in_provider.dart';

class SignUpState {
  final String countryCode;
  final bool isSendingOtp;

  const SignUpState({
    this.countryCode = '+91',
    this.isSendingOtp = false,
  });

  SignUpState copyWith({String? countryCode, bool? isSendingOtp}) {
    return SignUpState(
      countryCode: countryCode ?? this.countryCode,
      isSendingOtp: isSendingOtp ?? this.isSendingOtp,
    );
  }
}

class SignUpNotifier extends AutoDisposeNotifier<SignUpState> {
  late final AuthService _authService;

  @override
  SignUpState build() {
    _authService = AuthService(ApiClient());
    return const SignUpState();
  }

  void setCountryCode(String dialCode) =>
      state = state.copyWith(countryCode: dialCode);

  Future<SendOtpResult> registerSendOtp(String phone) async {
    state = state.copyWith(isSendingOtp: true);

    SendOtpResult result;

    if (phone.isEmpty) {
      result =
          SendOtpResult(success: false, error: 'Please enter a phone number');
    } else if (phone.length < 10) {
      result = SendOtpResult(
          success: false, error: 'Phone number must be at least 10 digits');
    } else {
      try {
        final response = await _authService.registerSendOtp(phone: phone);
        if (response.success) {
          result = SendOtpResult(success: true, message: response.message);
        } else {
          result = SendOtpResult(
            success: false,
            error: response.error ?? response.message ?? 'Failed to send OTP',
          );
        }
      } catch (e) {
        result = SendOtpResult(success: false, error: 'Error: ${e.toString()}');
      }
    }

    state = state.copyWith(isSendingOtp: false);
    return result;
  }
}

final signUpNotifierProvider =
    NotifierProvider.autoDispose<SignUpNotifier, SignUpState>(
        SignUpNotifier.new);
