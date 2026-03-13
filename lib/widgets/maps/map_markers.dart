import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:skolo_driver/config.dart' hide Marker, Polyline, LatLng;
import 'dart:math' as math;

/// Reusable marker builder for all map providers
class MapMarkers {
  /// Generic marker with SVG icon and dark color opacity background
  static Marker _buildMarker({
    required LatLng point,
    required String svgAssetPath,
    required Color color,
    double width = 20,
    double height = 20,
    Border? border,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssetPath,
                width: width,
                height: height,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Current location marker (primary color with white border)
  static Marker currentLocationMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.gps,
      color: appColor(context).appTheme.primary,
      border: Border.all(
        color: appColor(context).appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Pickup location marker (online/success color)
  static Marker pickupMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.location,
      color: appColor(context).appTheme.primary,
      border: Border.all(
        color: appColor(context).appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Student/waypoint marker (yellow/warning color)
  static Marker waypointMarker(
    LatLng point,
    String studentName,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.location,
      color: appColor(context).appTheme.primary,
      border: Border.all(
        color: appColor(context).appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Driver/Vehicle location marker (primary color) with pulsing animation
  static Marker driverLocationMarker(
    LatLng point,
    BuildContext context, {
    double heading = 0.0,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: _PulsingDriverMarker(
        svgAssetPath: svgAssets.carLight,
        pulseColor: appColor(context).appTheme.lightText,
        iconColor: appColor(context).appTheme.primary,
        heading: heading,
        onTap: onTap,
      ),
    );
  }

  /// School/Drop-off location marker (bank icon with primary color)
  static Marker dropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.bank,
      color: appColor(context).appTheme.primary,
      border: Border.all(
        color: appColor(context).appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Completed waypoint marker (greyed out with checkmark - already visited)
  static Marker completedWaypointMarker(
    LatLng point,
    String studentName,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.check,
                size: 16,
                color: appColor(context).appTheme.primary.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Completed drop-off marker (greyed out with checkmark - school already visited)
  static Marker completedDropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.check,
                size: 16,
                color: appColor(context).appTheme.primary.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Current waypoint marker (dark/prominent color - student to pick up next)
  /// Shows with full opacity and prominent styling
  static Marker currentWaypointMarker(
    LatLng point,
    String studentName,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary,
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssets.location,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Upcoming waypoint marker (light color - future pick-ups)
  /// Shows with reduced opacity and lighter styling to indicate it's not the immediate next stop
  static Marker upcomingWaypointMarker(
    LatLng point,
    String studentName,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssets.location,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// School drop-off location marker (dark/prominent)
  static Marker currentDropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary,
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssets.bank,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// School drop-off location marker (light color - future drop-off)
  static Marker upcomingDropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: appColor(context).appTheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: appColor(context).appTheme.primary.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssets.bank,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  appColor(context).appTheme.primary.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated pulsing marker for driver location
class _PulsingDriverMarker extends StatefulWidget {
  final String svgAssetPath;
  final Color pulseColor;
  final Color iconColor;
  final double heading;
  final VoidCallback? onTap;

  const _PulsingDriverMarker({
    required this.svgAssetPath,
    required this.pulseColor,
    required this.iconColor,
    this.heading = 0.0,
    this.onTap,
  });

  @override
  State<_PulsingDriverMarker> createState() => _PulsingDriverMarkerState();
}

class _PulsingDriverMarkerState extends State<_PulsingDriverMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.pulseColor
                          .withOpacity(_opacityAnimation.value),
                    ),
                  ),
                );
              },
            ),
            // Main icon container with rotation based on heading
            // GPS heading: 0° = North (up), 90° = East (right), 180° = South, 270° = West
            // Adjust the offset based on your car SVG's default direction:
            // - If car points UP by default: use heading directly (offset = 0)
            // - If car points RIGHT by default: subtract 90 (offset = -90)
            // - If car points DOWN by default: subtract 180 (offset = -180)
            Transform.rotate(
              angle: widget.heading *
                  (math.pi / 180), // Convert degrees to radians
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.pulseColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    widget.svgAssetPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      widget.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
