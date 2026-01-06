import 'package:taxify_driver_ui/config.dart';

class SplashProvider extends ChangeNotifier {
  onInit(context) {
    Future.delayed(DurationClass.s1)
        .then((value) => route.pushNamed(context, routeName.signInScreen));
  }
}
