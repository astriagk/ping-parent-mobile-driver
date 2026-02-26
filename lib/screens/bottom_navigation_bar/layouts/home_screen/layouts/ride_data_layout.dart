import '../../../../../config.dart';

class RideDataLayout extends StatelessWidget {
  const RideDataLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomBarProvider, MyRidesProvider>(
        builder: (context, bottomNavPvr, myRidesPvr, child) {
      return Row(
          children: List.generate(appArray.rideData.length, (index) {
        return Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: Insets.i3),
                padding: EdgeInsets.all(Insets.i15),
                decoration: BoxDecoration(
                    color: appTheme.bgBox,
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: AppRadius.r8,
                        cornerSmoothing: Insets.i10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(appArray.rideData[index]["count"]!,
                      //     style:
                      //         AppCss.lexendBold16.textColor(appTheme.primary)),
                      // VSpace(Insets.i10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Text(appArray.rideData[index]["title"]!,
                                    overflow: TextOverflow.fade,
                                    style: AppCss.lexendRegular12
                                        .textColor(appTheme.textClr)
                                        .textHeight(1.3))),
                            SvgPicture.asset(svgAssets.arrowRight1)
                          ])
                    ])).inkWell(onTap: () {
          if (index == 0) {
            bottomNavPvr.tabChange(2);
            myRidesPvr.selectedIndex = 0;
          } else if (index == 1) {
            bottomNavPvr.tabChange(2);
            myRidesPvr.selectedIndex = 1;
          } else {
            bottomNavPvr.tabChange(2);
            myRidesPvr.selectedIndex = 2;
          }
        }));
      }));
    });
  }
}
