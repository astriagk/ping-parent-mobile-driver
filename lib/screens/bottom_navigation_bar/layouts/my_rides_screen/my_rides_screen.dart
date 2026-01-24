import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_layouts.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MyRidesProvider>(builder: (context, myRidesPvr, child) {
      return SingleChildScrollView(
          child: Column(children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              myRidesWidgets.buildTabButton(
                  language(context, appFonts.pendingRide),
                  0,
                  screenWidth,
                  myRidesPvr.selectedIndex, () {
                setState(() {});
                myRidesPvr.selectedIndex = 0;
              }),
              SizedBox(width: Insets.i10),
              myRidesWidgets.buildTabButton(
                  language(context, appFonts.completeRide),
                  1,
                  screenWidth,
                  myRidesPvr.selectedIndex, () {
                setState(() {});
                myRidesPvr.selectedIndex = 1;
              }),
              SizedBox(width: Insets.i10),
              myRidesWidgets.buildTabButton(
                  language(context, appFonts.cancelRide),
                  2,
                  screenWidth,
                  myRidesPvr.selectedIndex, () {
                setState(() {});
                myRidesPvr.selectedIndex = 2;
              })
            ]).marginSymmetric(horizontal: Insets.i20)),
        myRidesPvr.selectedIndex == 0
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appArray.userPendingRideData.length,
                itemBuilder: (context, index) {
                  final customer = appArray.userPendingRideData[index];
                  return CustomerCard(
                      pickUpAddress: customer['pickUpAddress'],
                      userName: customer['name'],
                      rating: customer['rating'],
                      reviews: customer['reviews'],
                      distance: customer['distance'],
                      amount: customer['earnings'],
                      pickupTime: customer['pickupTime'],
                      dropOffAddress: customer['droppingAddress'],
                      onTap: () => route.pushNamed(
                          context, routeName.pendingRideDetails));
                })
            : myRidesPvr.selectedIndex == 1
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: appArray.userCompleteRideData.length,
                    itemBuilder: (context, index) {
                      final user = appArray.userCompleteRideData[index];
                      return myRidesWidgets.buildCommonLayout(
                          userName: user['name'],
                          rating: user['rating'],
                          reviews: user['reviews'],
                          time: '${user['date']} at ${user['time']}',
                          price: user['price'],
                          distance: user['distance'],
                          pickUpAddress: user['pickUpAddress'],
                          droppingAddress: user['droppingAddress'],
                          onTap: () => route.pushNamed(
                              context, routeName.completedRideDetails));
                    })
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: appArray.userCancelRideData.length,
                    itemBuilder: (context, index) {
                      final user = appArray.userCompleteRideData[index];
                      return myRidesWidgets.buildCommonLayout(
                          userName: user['name'],
                          reviews: user['reviews'],
                          rating: user['rating'],
                          time: '${user['date']} at ${user['time']}',
                          price: user['price'],
                          distance: user['distance'],
                          pickUpAddress: user['pickUpAddress'],
                          droppingAddress: user['droppingAddress'],
                          onTap: () => route.pushNamed(
                              context, routeName.cancelRideDetailsScreen));
                    })
      ]));
    });
  }
}
