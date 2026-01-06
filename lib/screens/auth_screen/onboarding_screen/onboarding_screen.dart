import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
        builder: (context1, onBoardingPvr, child) {
      return Scaffold(
          backgroundColor: appColor(context).appTheme.onBoardingBg,
          body: Column(children: [
            Expanded(
                child: PageView.builder(
                    controller: onBoardingPvr.pageController,
                    itemCount: onBoardingPvr.images.length,
                    onPageChanged: (index) =>
                        onBoardingPvr.onPageChanged(index),
                    itemBuilder: (context, index) {
                      return Image.asset(onBoardingPvr.images[index],
                          width: double.infinity, fit: BoxFit.cover);
                    })),
            Container(
                padding: EdgeInsets.all(Insets.i20),
                margin: EdgeInsets.only(
                    left: Insets.i20, top: Insets.i30, right: Insets.i20),
                decoration: BoxDecoration(
                    color: appColor(context).appTheme.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(children: [
                  Text(
                          language(context,
                              onBoardingPvr.titles[onBoardingPvr.currentIndex]),
                          style: AppCss.lexendMedium20
                              .textColor(appColor(context).appTheme.onCtrClr))
                      .padding(bottom: Insets.i10),
                  Text(language(context, appFonts.simplyTouch),
                          textAlign: TextAlign.center,
                          style: AppCss.lexendRegular16
                              .textColor(
                                  appColor(context).appTheme.descrTextClr)
                              .textHeight(1.4))
                      .padding(bottom: Insets.i20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothPageIndicator(
                            controller: onBoardingPvr.pageController,
                            count: onBoardingPvr.images.length,
                            effect: ExpandingDotsEffect(
                                dotHeight: 6,
                                dotWidth: 6,
                                spacing: 3,
                                activeDotColor:
                                    appColor(context).appTheme.primary,
                                // Customize dot colors
                                dotColor: Colors.grey)),
                        Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appColor(context).appTheme.primary),
                                child: SvgPicture.asset(svgAssets.arrowRight)
                                    .paddingAll(12))
                            .inkWell(
                                onTap: () =>
                                    onBoardingPvr.onboardingOnTap(context))
                      ])
                ]))
          ]));
    });
  }
}
