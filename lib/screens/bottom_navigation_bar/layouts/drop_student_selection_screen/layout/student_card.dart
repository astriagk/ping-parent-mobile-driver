import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:skolo_driver/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skolo_driver/api/models/drop_student_selection_model.dart';

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

  String _toTitleCase(String value) {
    return value
        .split('_')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final hasClass = student.studentClass != null &&
        student.studentClass!.trim().isNotEmpty;
    final hasGender = student.studentGender != null &&
        student.studentGender!.trim().isNotEmpty;
    final hasSchool = (student.schoolName != null &&
            student.schoolName!.trim().isNotEmpty) ||
        (student.schoolId != null && student.schoolId!.trim().isNotEmpty);
    final hasParentPhone =
        parentPhoneNumber != null && parentPhoneNumber!.trim().isNotEmpty;
    final hasParentPhoto =
        parentPhotoUrl != null && parentPhotoUrl!.trim().isNotEmpty;

    // Attendance status badge color
    Color? statusColor;
    String? statusLabel;
    if (student.attendanceStatus == 'present') {
      statusColor = appTheme.priceClr;
      statusLabel = 'Present';
    } else if (student.attendanceStatus == 'absent') {
      statusColor = appTheme.alertZone;
      statusLabel = 'Absent';
    }

    return CommonBgLayout(
      color: isSelected ? appTheme.primary.withOpacity(0.07) : appTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top: photo + student info + status badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student photo
              ClipRRect(
                borderRadius: BorderRadius.circular(Insets.i7),
                child: Container(
                  height: Insets.i50,
                  width: Insets.i50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: appTheme.borderColor),
                  ),
                  child: student.studentPhotoUrl?.trim().isNotEmpty == true
                      ? Image.network(
                          student.studentPhotoUrl!.trim(),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            imageAssets.profileImg,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(imageAssets.profileImg, fit: BoxFit.cover),
                ),
              ),
              HSpace(Insets.i10),
              // Student info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    screensWidgets.userName(student.studentName,
                        style:
                            AppCss.lexendMedium15.textColor(appTheme.primary)),
                    if (hasClass || hasGender) ...[
                      VSpace(Insets.i4),
                      Row(
                        children: [
                          if (hasClass) _InfoChip(label: student.classDisplay),
                          if (hasClass && hasGender) HSpace(Insets.i6),
                          if (hasGender)
                            _InfoChip(
                                label: _toTitleCase(student.studentGender!)),
                        ],
                      ),
                    ],
                    if (hasSchool) ...[
                      VSpace(Insets.i5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_outlined,
                              size: 12, color: appTheme.primary),
                          HSpace(Insets.i4),
                          Flexible(
                            child: Text(
                              student.schoolName ??
                                  student.schoolId ??
                                  '',
                              style: AppCss.lexendRegular13
                                  .textColor(appTheme.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Attendance status badge
              if (statusLabel != null) ...[
                HSpace(Insets.i8),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.i8, vertical: Insets.i4),
                  decoration: BoxDecoration(
                    color: statusColor!.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(Insets.i4),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppCss.lexendMedium12.textColor(statusColor),
                  ),
                ),
              ],
            ],
          ),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          // ── Bottom: parent photo + name + call + selection circle ──
          Row(
            children: [
              // Parent photo
              ClipOval(
                child: Container(
                  height: 36,
                  width: 36,
                  color: appTheme.bgBox,
                  child: hasParentPhoto
                      ? Image.network(
                          parentPhotoUrl!.trim(),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: 20,
                            color: appTheme.lightText,
                          ),
                        )
                      : Icon(Icons.person, size: 20, color: appTheme.lightText),
                ),
              ),
              HSpace(Insets.i8),
              // Parent name
              Expanded(
                child: Text(
                  parentName ?? '',
                  style: AppCss.lexendLight13
                      .textColor(appTheme.lightText)
                      .textHeight(1.3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Call button
              if (hasParentPhone) ...[
                CommonIconButton(
                  onTap: () async {
                    PermissionStatus status =
                        await Permission.phone.request();
                    if (status.isGranted) {
                      final Uri phoneUri =
                          Uri(scheme: 'tel', path: parentPhoneNumber!.trim());
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri,
                            mode: LaunchMode.externalApplication);
                      } else {
                        log('Could not open dialer');
                      }
                    } else if (status.isDenied) {
                      log('Phone permission denied');
                    } else if (status.isPermanentlyDenied) {
                      log('Phone permission permanently denied');
                      openAppSettings();
                    }
                  },
                  icon: svgAssets.call,
                  bgColor: appTheme.bgBox,
                ),
                HSpace(Insets.i10),
              ],
              // Selection circle
              Container(
                width: Insets.i26,
                height: Insets.i26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? appTheme.primary : appTheme.borderColor,
                    width: Insets.i2,
                  ),
                  color: isSelected ? appTheme.primary : appTheme.white,
                ),
                child: isSelected
                    ? Icon(Icons.check,
                        size: Insets.i14, color: appTheme.white)
                    : null,
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

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Insets.i6, vertical: Insets.i2),
      decoration: BoxDecoration(
        color: appTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Insets.i4),
      ),
      child: Text(
        label,
        style: AppCss.lexendRegular12.textColor(appTheme.primary),
      ),
    );
  }
}
