import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/helper/location_service.dart';

class CommonMapHeader extends StatelessWidget {
  final RouteWaypoint? waypoint;
  final int waypointIndex;
  final int totalWaypoints;
  final VoidCallback? onBack;

  const CommonMapHeader({
    super.key,
    this.waypoint,
    required this.waypointIndex,
    required this.totalWaypoints,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: appColor(context).appTheme.bgBox,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            bottomRight:
                SmoothRadius(cornerRadius: Sizes.s20, cornerSmoothing: 1),
            bottomLeft:
                SmoothRadius(cornerRadius: Sizes.s20, cornerSmoothing: 1),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.i20,
            vertical: Insets.i12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              CommonIconButton(
                icon: svgAssets.back,
                bgColor: appColor(context).appTheme.white,
                onTap: onBack ?? () => route.pop(context),
              ),
              HSpace(Insets.i10),
              // Waypoint info and stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Waypoint progress
                    Text(
                      'Stop ${waypointIndex + 1} of $totalWaypoints',
                      style: AppCss.lexendSemiBold16
                          .textColor(appColor(context).appTheme.primary),
                    ),
                    VSpace(Insets.i2),
                    // Address
                    Text(
                      waypoint?.address ?? 'Unknown Location',
                      style: AppCss.lexendRegular12
                          .textColor(appColor(context).appTheme.lightText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    VSpace(Insets.i8),
                    // Distance, Duration, ETA - compact row
                    Row(
                      children: [
                        _CompactInfoChip(
                          icon: svgAssets.distance,
                          value: LocationService.formatDistance(
                              waypoint?.distanceFromPrevious),
                        ),
                        HSpace(Insets.i8),
                        _CompactInfoChip(
                          icon: svgAssets.duration,
                          value: LocationService.formatDuration(
                              waypoint?.durationFromPrevious),
                        ),
                        HSpace(Insets.i8),
                        _CompactInfoChip(
                          icon: svgAssets.eta,
                          value: LocationService.formatETA(
                              waypoint?.estimatedArrivalTime),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact info chip showing icon + value inline
class _CompactInfoChip extends StatelessWidget {
  final String icon;
  final String value;

  const _CompactInfoChip({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.i8,
        vertical: Insets.i4,
      ),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 14,
            colorFilter: ColorFilter.mode(
              appColor(context).appTheme.primary,
              BlendMode.srcIn,
            ),
          ),
          HSpace(Insets.i4),
          Text(
            value,
            style: AppCss.lexendMedium12
                .textColor(appColor(context).appTheme.primary),
          ),
        ],
      ),
    );
  }
}
