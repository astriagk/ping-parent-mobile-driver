import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:skolo_driver/config.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final String? userName;
  final String? userImage;
  final double? rating;
  final int? reviews;
  final String? distance;
  final double? amount;
  final String? pickupTime;
  final String? pickUpAddress;
  final String? dropOffAddress;
  final VoidCallback? onTap;
  final bool showActionButtons;
  final String? assignmentId;
  final String? phoneNumber;
  final Function(String)? onApprove;
  final Function(String)? onReject;
  final bool isActionLoading;
  // Additional student/assignment info
  final String? schoolName;
  final String? classSection;
  final String? gender;
  final String? assignmentStatus;
  final DateTime? assignedDate;
  final String? parentName;
  final String? parentPhotoUrl;

  const CustomerCard(
      {super.key,
      this.userName,
      this.userImage,
      this.rating,
      this.reviews,
      this.distance,
      this.amount,
      this.pickupTime,
      this.pickUpAddress,
      this.dropOffAddress,
      this.onTap,
      this.showActionButtons = false,
      this.assignmentId,
      this.phoneNumber,
      this.onApprove,
      this.onReject,
      this.isActionLoading = false,
      this.schoolName,
      this.classSection,
      this.gender,
      this.assignmentStatus,
      this.assignedDate,
      this.parentName,
      this.parentPhotoUrl});

  /// Converts snake_case or lowercase to Title Case
  /// e.g. "parent_requested" → "Parent Requested", "male" → "Male"
  String _toTitleCase(String value) {
    return value
        .split('_')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone =
        phoneNumber != null && phoneNumber!.trim().isNotEmpty;
    final hasClass =
        classSection != null && classSection!.trim().isNotEmpty;
    final hasGender = gender != null && gender!.trim().isNotEmpty;
    final hasSchool =
        schoolName != null && schoolName!.trim().isNotEmpty;
    final hasDistance =
        distance != null && distance!.trim().isNotEmpty;

    return CommonBgLayout(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          // ── Header: photo + info + status ──
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student photo
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Insets.i7),
                          child: Container(
                            height: Insets.i50,
                            width: Insets.i50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: appTheme.borderColor)),
                            child: (userImage?.trim().isNotEmpty == true)
                                ? Image.network(
                                    userImage!.trim(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Image.asset(imageAssets.profileImg,
                                            fit: BoxFit.cover),
                                  )
                                : Image.asset(imageAssets.profileImg,
                                    fit: BoxFit.cover),
                          ),
                        ),
                        HSpace(Insets.i10),
                        // Name + class/gender + school
                        Expanded(
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                screensWidgets.userName(userName,
                                    style: AppCss.lexendMedium15
                                        .textColor(appTheme.primary)),
                                if (hasClass || hasGender) ...[
                                  VSpace(Insets.i4),
                                  Row(children: [
                                    if (hasClass)
                                      _InfoChip(label: classSection!),
                                    if (hasClass && hasGender)
                                      HSpace(Insets.i6),
                                    if (hasGender)
                                      _InfoChip(label: _toTitleCase(gender!)),
                                  ]),
                                ],
                                if (hasSchool) ...[
                                  VSpace(Insets.i5),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.school_outlined,
                                            size: 12,
                                            color: appTheme.primary),
                                        HSpace(Insets.i4),
                                        Flexible(
                                          child: Text(schoolName!,
                                              style: AppCss.lexendRegular13
                                                  .textColor(appTheme.primary),
                                              overflow:
                                                  TextOverflow.ellipsis),
                                        ),
                                      ]),
                                ],
                              ]),
                        ),
                      ]),
                ),
                // Distance badge
                if (hasDistance) ...[
                  HSpace(Insets.i8),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.i8, vertical: Insets.i4),
                    decoration: BoxDecoration(
                        color: appTheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Insets.i4)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      SvgPicture.asset(svgAssets.routing, height: 12),
                      HSpace(Insets.i4),
                      Text(distance!,
                          style: AppCss.lexendMedium13
                              .textColor(appTheme.primary)),
                    ]),
                  ),
                ],
              ]),
          VSpace(Insets.i15),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          // ── Middle row: parent name + call ──
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            if (parentName != null && parentName!.trim().isNotEmpty)
              Expanded(
                child: Row(children: [
                  ClipOval(
                    child: Container(
                      height: 36,
                      width: 36,
                      color: appTheme.bgBox,
                      child: (parentPhotoUrl?.trim().isNotEmpty == true)
                          ? Image.network(
                              parentPhotoUrl!.trim(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 20,
                                color: appTheme.lightText,
                              ),
                            )
                          : Icon(Icons.person,
                              size: 20, color: appTheme.lightText),
                    ),
                  ),
                  HSpace(Insets.i8),
                  Flexible(
                    child: Text(parentName!,
                        style: AppCss.lexendLight14
                            .textColor(appTheme.lightText)
                            .textHeight(1.3),
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
              )
            else
              const SizedBox.shrink(),
            if (hasPhone)
              CommonIconButton(
                  onTap: () async {
                    PermissionStatus status =
                        await Permission.phone.request();
                    if (status.isGranted) {
                      final Uri phoneUri = Uri(
                          scheme: 'tel', path: phoneNumber!.trim());
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
                  },
                  icon: svgAssets.call,
                  bgColor: appTheme.bgBox),
          ]),
          VSpace(Insets.i15),
          CommonLocationLayout(
              pickUpAddress: pickUpAddress,
              droppingAddress: dropOffAddress),
          if (showActionButtons)
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                      style: AppCss.lexendRegular14
                          .textColor(appTheme.textClr),
                      color: appColor(context).appTheme.bgBox,
                      onTap: isActionLoading
                          ? null
                          : () => onReject?.call(assignmentId!),
                      isLoading: isActionLoading,
                      text: appFonts.reject),
                ),
                SizedBox(width: Insets.i10),
                Expanded(
                  child: CommonButton(
                      style: AppCss.lexendRegular15
                          .textColor(appTheme.white),
                      onTap: isActionLoading
                          ? null
                          : () => onApprove?.call(assignmentId!),
                      isLoading: isActionLoading,
                      text: appFonts.approve),
                ),
              ],
            ).marginOnly(top: Insets.i15)
        ]))
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
          color: appTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Insets.i4)),
      child: Text(label,
          style: AppCss.lexendRegular13.textColor(appTheme.primary)),
    );
  }
}
