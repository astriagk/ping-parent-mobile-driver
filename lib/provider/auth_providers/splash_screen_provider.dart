import 'package:skolo_driver/config.dart';
import '../../api/services/storage_service.dart';

class SplashProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  onInit(context) {
    Future.delayed(DurationClass.s1)
        .then((value) => _checkAuthAndNavigate(context));
  }

  /// Check if user has valid token and navigate accordingly
  Future<void> _checkAuthAndNavigate(BuildContext context) async {
    try {
      final hasToken = await _storageService.hasValidSession();

      if (hasToken && context.mounted) {
        // User has valid token, navigate to dashboard
        route.pushNamed(context, routeName.commonBottomBar);
      } else if (context.mounted) {
        // No token, navigate to sign in
        route.pushNamed(context, routeName.signInScreen);
      }
    } catch (e) {
      // On error, navigate to sign in
      if (context.mounted) {
        route.pushNamed(context, routeName.signInScreen);
      }
    }
  }
}
