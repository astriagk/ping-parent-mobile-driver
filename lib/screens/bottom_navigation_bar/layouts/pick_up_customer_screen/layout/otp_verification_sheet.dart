import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/config/app_constants.dart';
import 'package:taxify_driver_ui/helper/location_service.dart';
import 'package:taxify_driver_ui/provider/bottom_bar_provider/pick_up_customer_provider.dart';
import 'package:taxify_driver_ui/widgets/screens_widgets/screens_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class OtpVerificationSheet extends StatefulWidget {
  final GestureTapCallback? onTap;
  final RouteWaypoint? waypoint;
  final VoidCallback? onEndTrip;
  final String? tripId;
  final PickUpCustomerProvider? pickUpProvider;
  final void Function(List<String> presentStudentIds)? onPickupSuccess;
  final VoidCallback? onAllAbsent;

  /// Whether this is the first waypoint interaction (no students picked up yet)
  final bool isFirstWaypointInteraction;

  const OtpVerificationSheet({
    super.key,
    this.onTap,
    this.waypoint,
    this.onEndTrip,
    this.tripId,
    this.pickUpProvider,
    this.onPickupSuccess,
    this.onAllAbsent,
    this.isFirstWaypointInteraction = false,
  });

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isMarkingAbsent = false;
  String? _errorMessage;

  // Map to track student presence status (studentId -> isPresent)
  Map<String, bool> _studentPresence = {};

  @override
  void initState() {
    super.initState();
    _initializeStudentPresence();
  }

  void _initializeStudentPresence() {
    if (widget.waypoint != null) {
      _studentPresence = {}; // Clear existing map
      for (final studentId in widget.waypoint!.studentIds) {
        _studentPresence[studentId] = true; // Default to present
      }
    }
  }

  @override
  void didUpdateWidget(covariant OtpVerificationSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize when waypoint changes
    if (oldWidget.waypoint != widget.waypoint) {
      _initializeStudentPresence();
      _otpController.clear();
      _errorMessage = null;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndPickupStudent() async {
    if (widget.tripId == null ||
        widget.waypoint == null ||
        widget.pickUpProvider == null) {
      setState(() {
        _errorMessage = 'Missing trip information';
      });
      return;
    }

    // Separate present and absent students based on toggle state
    final presentStudentIds = <String>[];
    final absentStudentIds = <String>[];

    for (final entry in _studentPresence.entries) {
      if (entry.value) {
        presentStudentIds.add(entry.key);
      } else {
        absentStudentIds.add(entry.key);
      }
    }

    // If there are present students, OTP is required
    if (presentStudentIds.isNotEmpty && _otpController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter OTP for present students';
      });
      return;
    }

    // Get parent ID from waypoint
    final parentId = widget.waypoint!.studentParentId;
    if (parentId.isEmpty) {
      setState(() {
        _errorMessage = 'Missing parent information';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // If there are present students, verify OTP first
      if (presentStudentIds.isNotEmpty) {
        final verifiedStudentIds =
            await widget.pickUpProvider!.verifyDailyQrOtp(
          parentId: parentId,
          tripId: widget.tripId!,
          otpCode: _otpController.text,
        );

        if (verifiedStudentIds == null || verifiedStudentIds.isEmpty) {
          setState(() {
            _isLoading = false;
            _errorMessage =
                widget.pickUpProvider!.errorMessage ?? 'Invalid OTP';
          });
          return;
        }
      }

      // Get current location
      final currentLocation = await LocationService.getCurrentLocation();
      if (currentLocation == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to get current location';
        });
        return;
      }

      // Call pickup point API
      final response = await widget.pickUpProvider!.processPickupPoint(
        tripId: widget.tripId!,
        studentIds: presentStudentIds,
        absentStudentIds: absentStudentIds,
        otpCode: presentStudentIds.isNotEmpty ? _otpController.text : null,
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      );

      setState(() {
        _isLoading = false;
      });

      if (response != null && response.success) {
        // Notify parent about picked up students
        widget.onPickupSuccess?.call(presentStudentIds);
        // Call the success callback
        widget.onTap?.call();
      } else {
        setState(() {
          _errorMessage = widget.pickUpProvider!.errorMessage ??
              'Failed to process stop action';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  /// Mark all students at this waypoint as absent and move to next
  Future<void> _markAllStudentsAbsent() async {
    if (widget.tripId == null ||
        widget.waypoint == null ||
        widget.pickUpProvider == null) {
      setState(() {
        _errorMessage = 'Missing trip information';
      });
      return;
    }

    // All students at this waypoint are absent
    final absentStudentIds = widget.waypoint!.studentIds.toList();

    if (absentStudentIds.isEmpty) {
      setState(() {
        _errorMessage = 'No students at this waypoint';
      });
      return;
    }

    setState(() {
      _isMarkingAbsent = true;
      _errorMessage = null;
    });

    try {
      // Get current location
      final currentLocation = await LocationService.getCurrentLocation();
      if (currentLocation == null) {
        setState(() {
          _isMarkingAbsent = false;
          _errorMessage = 'Unable to get current location';
        });
        return;
      }

      // Call pickup point API with all students as absent (no present students)
      final response = await widget.pickUpProvider!.processPickupPoint(
        tripId: widget.tripId!,
        studentIds: [], // No present students
        absentStudentIds: absentStudentIds,
        otpCode: null, // No OTP needed when all absent
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      );

      setState(() {
        _isMarkingAbsent = false;
      });

      if (response != null && response.success) {
        // Update trip status to in_progress if this is the first waypoint interaction
        if (widget.isFirstWaypointInteraction &&
            widget.pickUpProvider?.optimizedRoute != null) {
          final routeId = widget.pickUpProvider!.optimizedRoute!.id;
          await widget.pickUpProvider!.updateTripStatus(
            tripId: routeId,
            tripStatus: TripStatus.inProgress.value,
          );
        }
        // Call the all absent callback to move to next waypoint
        widget.onAllAbsent?.call();
      } else {
        setState(() {
          _errorMessage = widget.pickUpProvider!.errorMessage ??
              'Failed to mark students as absent';
        });
      }
    } catch (e) {
      setState(() {
        _isMarkingAbsent = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.nextRide),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset('assets/image/home/car.png', height: 25)
              ]),
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              Row(children: [
                // TODO: Replace with dummy image if null
                CircleAvatar(
                    backgroundImage: widget.waypoint?.studentImage != null
                        ? NetworkImage(widget.waypoint!.studentImage!)
                        : AssetImage('assets/image/home/user2.png')
                            as ImageProvider,
                    radius: 20),
                SizedBox(width: Insets.i8),
                Expanded(
                  child: Text(
                      widget.waypoint?.studentParentId ==
                              AppConstants.schoolLocationType
                          ? widget.waypoint?.studentNames.firstOrNull ??
                              'School'
                          : widget.waypoint?.parentName ?? '',
                      style:
                          AppCss.lexendRegular14.textColor(appTheme.primary)),
                ),
                // TODO: Enable chat functionality once we are ready
                // CommonIconButton(
                //     onTap: () => route.pushNamed(context, routeName.chatScreen),
                //     icon: svgAssets.message,
                //     bgColor: appTheme.bgBox),
                // SizedBox(width: Insets.i12),
                if (widget.waypoint?.studentParentId !=
                    AppConstants.schoolLocationType)
                  CommonIconButton(
                      bgColor: appTheme.bgBox,
                      icon: svgAssets.call,
                      onTap: () async {
                        // Request phone permission
                        PermissionStatus status =
                            await Permission.phone.request();

                        if (status.isGranted) {
                          final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: widget.waypoint?.parentPhoneNumber ?? '');

                          // Try to launch the dialer
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            log("Could not open dialer");
                          }
                        } else if (status.isDenied) {
                          log("Phone permission denied");
                        } else if (status.isPermanentlyDenied) {
                          log("Phone permission permanently denied, open app settings.");
                          openAppSettings();
                        }
                      })
              ]),
              // Student list with presence toggles
              if (widget.waypoint?.studentParentId !=
                      AppConstants.schoolLocationType &&
                  widget.waypoint != null &&
                  widget.waypoint!.studentIds.isNotEmpty) ...[
                VSpace(Insets.i12),
                ...List.generate(widget.waypoint!.studentIds.length, (index) {
                  final studentId = widget.waypoint!.studentIds[index];
                  final studentName =
                      index < widget.waypoint!.studentNames.length
                          ? widget.waypoint!.studentNames[index]
                          : 'Student ${index + 1}';
                  final isPresent = _studentPresence[studentId] ?? true;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: Insets.i4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          studentName,
                          style: AppCss.lexendRegular12
                              .textColor(appTheme.textClr),
                        ),
                        Row(
                          children: [
                            Text(
                              isPresent ? 'Present' : 'Absent',
                              style: AppCss.lexendRegular12.textColor(
                                isPresent
                                    ? appTheme.primary
                                    : appTheme.alertZone,
                              ),
                            ),
                            SizedBox(width: Insets.i8),
                            ScreensWidgets().customToggle(
                              isToggled: isPresent,
                              onToggle: () {
                                setState(() {
                                  _studentPresence[studentId] = !isPresent;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
              VSpace(Insets.i15),
              Divider(color: appTheme.stroke, height: 0),
              VSpace(Insets.i15),
              if (widget.waypoint?.studentParentId ==
                  AppConstants.schoolLocationType)
                CommonButton(
                    text: language(context, appFonts.completeRide),
                    onTap: widget.onTap)
              else
                Column(mainAxisSize: MainAxisSize.min, children: [
                  AuthCommonWidgets().textAndTextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      language(context, appFonts.oTPVerification),
                      language(context, appFonts.enterOtp),
                      context,
                      controller: _otpController,
                      fieldBgColor: appTheme.bgBox),
                  if (_errorMessage != null) ...[
                    VSpace(Insets.i8),
                    Text(
                      _errorMessage!,
                      style:
                          AppCss.lexendRegular12.textColor(appTheme.alertZone),
                    ),
                  ],
                  VSpace(Insets.i25),
                  Row(children: [
                    SizedBox(
                      width: 80,
                      child: CommonButton(
                        text: language(context, appFonts.absent),
                        color: appTheme.yellowIcon,
                        onTap: _markAllStudentsAbsent,
                        isLoading: _isMarkingAbsent,
                      ),
                    ),
                    SizedBox(width: Insets.i12),
                    Expanded(
                      child: CommonButton(
                        text: language(context, appFonts.verifyOTP),
                        onTap: _verifyAndPickupStudent,
                        isLoading: _isLoading,
                      ),
                    ),
                  ])
                ])
            ]));
  }
}
