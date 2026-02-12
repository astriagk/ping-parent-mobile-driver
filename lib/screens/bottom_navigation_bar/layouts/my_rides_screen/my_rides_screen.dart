import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/helper/address_util.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_layouts.dart';
import 'package:taxify_driver_ui/widgets/empty_state/empty_state_widget.dart';

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

  /// Helper function to handle assignment approval/rejection
  Future<void> _handleAssignmentAction(
    Future<bool> Function() apiCall,
    String successMsg,
    String errorMsg, {
    bool shouldNavigate = false,
  }) async {
    final success = await apiCall();
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
          text: successMsg,
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
          text: errorMsg,
        )),
      );
    }
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
                language(context, appFonts.requestedAssignments),
                0,
                screenWidth,
                myRidesPvr.selectedIndex, () {
              myRidesPvr.updateTab(0);
            }),
            SizedBox(width: Insets.i10),
            myRidesWidgets.buildTabButton(
                language(context, appFonts.completeAssignments),
                1,
                screenWidth,
                myRidesPvr.selectedIndex, () {
              myRidesPvr.updateTab(1);
            }),
            SizedBox(width: Insets.i10),
            myRidesWidgets.buildTabButton(
                language(context, appFonts.rejectedAssignments),
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
          EmptyStateWidget(
            title: appFonts.nothingHere,
            message: myRidesPvr.errorMessage!,
            buttonText: appFonts.refresh,
            onButtonTap: () => myRidesPvr.onInit(),
          )
        else if (myRidesPvr.getCurrentTabData().isEmpty)
          EmptyStateWidget(
            title: appFonts.nothingHere,
            message: language(context, appFonts.noAssignmentsFound),
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
                    assignmentId: assignment.id,
                    phoneNumber: '', // Get parent phone number here
                    showActionButtons: myRidesPvr.selectedIndex == 0,
                    onApprove: (assignmentId) => _handleAssignmentAction(
                          () => myRidesPvr.approveAssignment(assignmentId),
                          myRidesPvr.successMessage ??
                              language(context,
                                  appFonts.assignmentApprovedSuccessfully),
                          myRidesPvr.errorMessage ??
                              language(
                                  context, appFonts.failedToApproveAssignment),
                          shouldNavigate: true,
                        ),
                    onReject: (assignmentId) => _handleAssignmentAction(
                          () => myRidesPvr.rejectAssignment(assignmentId),
                          myRidesPvr.successMessage ??
                              language(context,
                                  appFonts.assignmentRejectedSuccessfully),
                          myRidesPvr.errorMessage ??
                              language(
                                  context, appFonts.failedToRejectAssignment),
                        ));
              })
      ]));
    });
  }
}
