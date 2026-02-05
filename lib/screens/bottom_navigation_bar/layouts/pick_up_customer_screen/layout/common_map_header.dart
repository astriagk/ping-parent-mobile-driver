import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/helper/location_service.dart';

class CommonMapHeader extends StatelessWidget {
  final RouteWaypoint? waypoint;
  final int waypointIndex;
  final int totalWaypoints;

  const CommonMapHeader({
    super.key,
    this.waypoint,
    required this.waypointIndex,
    required this.totalWaypoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white,
        boxShadow: [
          BoxShadow(
            color: appTheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Insets.i16,
        vertical: Insets.i12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waypoint progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waypoint ${waypointIndex + 1} of $totalWaypoints',
                style: AppCss.lexendRegular12.textColor(appTheme.primary),
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.i8,
                    vertical: Insets.i4,
                  ),
                  decoration: BoxDecoration(
                    color: appTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    waypoint?.address ?? 'Unknown Location',
                    style: AppCss.lexendRegular12.textColor(appTheme.primary),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          VSpace(Insets.i8),

          // Distance, Duration, ETA info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoCard(
                icon: svgAssets.distance,
                label: 'Distance',
                value: LocationService.formatDistance(
                    waypoint?.distanceFromPrevious),
              ),
              _InfoCard(
                icon: svgAssets.duration,
                label: 'Duration',
                value: LocationService.formatDuration(
                    waypoint?.durationFromPrevious),
              ),
              _InfoCard(
                icon: svgAssets.eta,
                label: 'ETA',
                value:
                    LocationService.formatETA(waypoint?.estimatedArrivalTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Insets.i4),
        padding: EdgeInsets.symmetric(
          horizontal: Insets.i8,
          vertical: Insets.i8,
        ),
        decoration: BoxDecoration(
          color: appTheme.bgBox,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: Insets.i16,
              colorFilter: ColorFilter.mode(
                appTheme.primary,
                BlendMode.srcIn,
              ),
            ),
            VSpace(Insets.i4),
            Text(
              label,
              style: AppCss.lexendRegular12.textColor(appTheme.textClr),
            ),
            VSpace(Insets.i2),
            Text(
              value,
              style: AppCss.lexendBold14.textColor(appTheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
