import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_bg_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taxify_driver_ui/api/models/drop_student_selection_model.dart';

class StudentCard extends StatelessWidget {
  final TripStudent student;
  final String? parentName;
  final String? parentPhoneNumber;
  final String? parentPhotoUrl;
  final bool isSelected;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.parentName,
    this.parentPhoneNumber,
    this.parentPhotoUrl,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBgLayout(
      color: isSelected ? appTheme.primary.withOpacity(0.1) : appTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Student avatar - using screensWidgets pattern
                    screensWidgets.userProfileImage(student.studentPhotoUrl),
                    HSpace(Insets.i6),
                    // Student info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Student name - using screensWidgets pattern
                          screensWidgets.userName(student.studentName),
                          VSpace(Insets.i6),
                          // Class and Section
                          Text(
                            student.classDisplay,
                            style: AppCss.lexendRegular12
                                .textColor(appTheme.lightText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Selection indicator
              Container(
                width: Insets.i24,
                height: Insets.i24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? appTheme.primary : appTheme.borderColor,
                    width: Insets.i2,
                  ),
                  color: isSelected ? appTheme.primary : appTheme.white,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: Insets.i14,
                        color: appTheme.white,
                      )
                    : null,
              ),
            ],
          ),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          // Parent info and actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  parentName ?? '',
                  style: AppCss.lexendLight12
                      .textColor(appTheme.primary)
                      .textHeight(1.3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  CommonIconButton(
                    onTap: () async {
                      PermissionStatus status =
                          await Permission.phone.request();

                      if (status.isGranted) {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: parentPhoneNumber ?? '');

                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          log("Could not open dialer");
                        }
                      } else if (status.isDenied) {
                        log("Phone permission denied");
                      } else if (status.isPermanentlyDenied) {
                        log("Phone permission permanently denied");
                        openAppSettings();
                      }
                    },
                    icon: svgAssets.call,
                    bgColor: appTheme.bgBox,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .marginSymmetric(horizontal: Insets.i20, vertical: Insets.i7)
        .inkWell(onTap: onTap);
  }
}
