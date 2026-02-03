import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;

/// Reusable marker builder for all map providers
class MapMarkers {
  /// Generic marker with SVG icon and dark color opacity background
  static Marker _buildMarker({
    required LatLng point,
    required String svgAssetPath,
    required Color color,
    double width = 56,
    double height = 56,
    Border? border,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: border ??
                  Border.all(
                    color: color.withOpacity(0.3),
                    width: 2,
                  ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssetPath,
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
      color: appColor(context).appTheme.online,
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

  /// Driver/Vehicle location marker (primary color)
  static Marker driverLocationMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.carDark,
      color: appColor(context).appTheme.primary,
      border: Border.all(
        color: appColor(context).appTheme.white,
        width: 2,
      ),
      onTap: onTap,
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
}
