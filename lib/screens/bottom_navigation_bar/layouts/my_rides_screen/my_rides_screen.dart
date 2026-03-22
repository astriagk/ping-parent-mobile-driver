import 'package:latlong2/latlong.dart' as ll;
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/core/utils/address_util.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_layouts.dart';
import 'package:skolo_driver/core/utils/map_utils.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen>
    with WidgetsBindingObserver {
  bool _wasInBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    }
    if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      if (mounted) {
        context.read<MyRidesProvider>().onInit();
      }
    }
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
                final classSection = [
                  assignment.student.classLevel,
                  assignment.student.section
                ].where((s) => s.trim().isNotEmpty).join(' - ');

                final distanceKm = MapUtils.calculateDistance(
                  ll.LatLng(assignment.parentAddress.latitude,
                      assignment.parentAddress.longitude),
                  ll.LatLng(assignment.school.latitude,
                      assignment.school.longitude),
                );
                final distanceText = MapUtils.formatDistance(distanceKm);

                return CustomerCard(
                    pickUpAddress: pickupAddress,
                    userName: assignment.student.studentName,
                    userImage: assignment.student.photoUrl,
                    dropOffAddress: dropoffAddress,
                    assignmentId: assignment.id,
                    schoolName: assignment.school.schoolName,
                    classSection: classSection.isNotEmpty ? classSection : null,
                    gender: assignment.student.gender.isNotEmpty
                        ? assignment.student.gender
                        : null,
                    assignmentStatus: assignment.assignmentStatus,
                    assignedDate: assignment.assignedDate,
                    distance: distanceText,
                    parentName: (assignment.parent?.name.isNotEmpty == true)
                        ? assignment.parent!.name
                        : null,
                    phoneNumber:
                        (assignment.parent?.phoneNumber.isNotEmpty == true)
                            ? assignment.parent!.phoneNumber
                            : null,
                    showActionButtons: myRidesPvr.selectedIndex == 0,
                    isActionLoading:
                        myRidesPvr.actionLoadingId == assignment.id,
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
