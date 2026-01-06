import '../../config.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<String> images = [
    imageAssets.onBoarding,
    imageAssets.onBoarding1,
    imageAssets.onBoarding2
  ];
  final List<String> titles = [
    appFonts.trackingRealtime,
    appFonts.earnMoney,
    appFonts.becomeTaxify
  ];

  onboardingOnTap(context) {
    if (currentIndex < images.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      route.pushReplacementNamed(context, routeName.signInScreen);
    }
  }

  onPageChanged(index) {
    notifyListeners();
    currentIndex = index;
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }
}
