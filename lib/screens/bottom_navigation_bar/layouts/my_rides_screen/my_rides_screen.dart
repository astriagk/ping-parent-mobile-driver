import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/helper/address_util.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_layouts.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyRidesProvider>().onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MyRidesProvider>(builder: (context, myRidesPvr, child) {
      return SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          width: screenWidth,
          child: SingleChildScrollView(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            myRidesWidgets.buildTabButton(
                language(context, appFonts.parentRequestedAssignments),
                0,
                screenWidth,
                myRidesPvr.selectedIndex, () {
              myRidesPvr.updateTab(0);
            }),
            SizedBox(width: Insets.i10),
            myRidesWidgets.buildTabButton(
                language(context, appFonts.completeMyAssignment),
                1,
                screenWidth,
                myRidesPvr.selectedIndex, () {
              myRidesPvr.updateTab(1);
            }),
            SizedBox(width: Insets.i10),
            myRidesWidgets.buildTabButton(
                language(context, appFonts.cancelMyAssignment),
                2,
                screenWidth,
                myRidesPvr.selectedIndex, () {
              myRidesPvr.updateTab(2);
            })
          ]).marginSymmetric(horizontal: Insets.i20)),
        ),
        if (myRidesPvr.isLoading)
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return const CustomerCardSkeleton();
              })
        else if (myRidesPvr.errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(myRidesPvr.errorMessage!),
          )
        else if (myRidesPvr.getCurrentTabData().isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No assignments found'),
          )
        else
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myRidesPvr.getCurrentTabData().length,
              itemBuilder: (context, index) {
                final assignment = myRidesPvr.getCurrentTabData()[index];
                final pickupAddress = AddressUtil.formatParentAddress(
                  addressLine1: assignment.parentAddress.addressLine1,
                  addressLine2: assignment.parentAddress.addressLine2,
                  city: assignment.parentAddress.city,
                  state: assignment.parentAddress.state,
                  pincode: assignment.parentAddress.pincode,
                );
                final dropoffAddress = AddressUtil.formatSchoolAddress(
                  address: assignment.school.address,
                  city: assignment.school.city,
                  state: assignment.school.state,
                );
                //  TODO: refer from here for data maping -
                //  D:\astria\Ping Parent\ping-parent-mobile-driver\lib\common\app_array.dart
                return CustomerCard(
                    pickUpAddress: pickupAddress,
                    userName: assignment.student.studentName,
                    rating: 4.0,
                    reviews: 10,
                    distance: '1.2KM',
                    amount: 200,
                    pickupTime: '10:00 AM',
                    dropOffAddress: dropoffAddress,
                    onTap: () =>
                        route.pushNamed(context, routeName.pendingRideDetails));
                // return myRidesPvr.selectedIndex == 0
                //     ? CustomerCard(
                //         pickUpAddress: pickupAddress,
                //         userName: assignment.student.studentName ?? '',
                //         rating: 4.0,
                //         reviews: 10,
                //         distance: '1.2KM',
                //         amount: 200,
                //         pickupTime: '10:00 AM',
                //         dropOffAddress: dropoffAddress,
                //         onTap: () => route.pushNamed(
                //             context, routeName.pendingRideDetails))
                //     : myRidesWidgets.buildCommonLayout(
                //         userName: assignment.student.studentName ?? '',
                //         rating: 4.0,
                //         reviews: 10,
                //         time: '10:00 AM',
                //         price: 200,
                //         distance: '1.2KM',
                //         pickUpAddress: pickupAddress,
                //         droppingAddress: dropoffAddress,
                //         onTap: () => myRidesPvr.selectedIndex == 1
                //             ? route.pushNamed(
                //                 context, routeName.completedRideDetails)
                //             : route.pushNamed(
                //                 context, routeName.cancelRideDetailsScreen));
              })
      ]));
    });
  }
}
