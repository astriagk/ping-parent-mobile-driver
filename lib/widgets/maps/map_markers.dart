import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;

/// Reusable marker builder for all map providers
class MapMarkers {
  /// Generic marker with SVG icon and color
  static Marker _buildMarker({
    required LatLng point,
    required String svgAssetPath,
    required Color color,
    double width = 40,
    double height = 40,
    Border? border,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: point,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              svgAssetPath,
              colorFilter: ColorFilter.mode(
                appTheme.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Current location marker (blue with border)
  static Marker currentLocationMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.gps,
      color: appTheme.primary,
      width: 35,
      height: 35,
      border: Border.all(
        color: appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Pickup location marker (green)
  static Marker pickupMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.location,
      color: const Color(0xFF27AE60),
      width: 40,
      height: 40,
      border: Border.all(
        color: appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }

  /// Drop-off location marker (red)
  static Marker dropOffMarker(
    LatLng point,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return _buildMarker(
      point: point,
      svgAssetPath: svgAssets.location,
      color: const Color(0xFFE74C3C),
      width: 40,
      height: 40,
      border: Border.all(
        color: appTheme.white,
        width: 2,
      ),
      onTap: onTap,
    );
  }
}
