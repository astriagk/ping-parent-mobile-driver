import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/data/datasources/remote/auth_service.dart';

class SignInState {
  final String countryCode;
  final String? currentPhone;
  final bool isSendingOtp;

  const SignInState({
    this.countryCode = '+91',
    this.currentPhone,
    this.isSendingOtp = false,
  });

  SignInState copyWith({
    String? countryCode,
    String? currentPhone,
    bool? isSendingOtp,
  }) {
    return SignInState(
      countryCode: countryCode ?? this.countryCode,
      currentPhone: currentPhone ?? this.currentPhone,
      isSendingOtp: isSendingOtp ?? this.isSendingOtp,
    );
  }
}

class SignInNotifier extends AutoDisposeNotifier<SignInState> {
  late final AuthService _authService;

  @override
  SignInState build() {
    _authService = AuthService(ApiClient());
    return const SignInState();
  }

  void setCountryCode(String dialCode) {
    state = state.copyWith(countryCode: dialCode);
  }

  Future<SendOtpResult> sendOtp(String phone) async {
    state = state.copyWith(isSendingOtp: true);

    SendOtpResult result;

    if (phone.isEmpty) {
      result = SendOtpResult(success: false, error: 'Please enter a phone number');
    } else if (phone.length < 10) {
      result = SendOtpResult(
          success: false, error: 'Phone number must be at least 10 digits');
    } else {
      try {
        final response = await _authService.sendOtp(phone: phone);
        if (response.success) {
          state = state.copyWith(currentPhone: phone);
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

final signInNotifierProvider =
    NotifierProvider.autoDispose<SignInNotifier, SignInState>(
        SignInNotifier.new);

class SendOtpResult {
  final bool success;
  final String? error;
  final String? message;

  SendOtpResult({required this.success, this.error, this.message});
}
