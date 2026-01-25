import 'package:taxify_driver_ui/widgets/maps/universal_map_widget.dart';

/// OpenFreeMap Configuration with CartoDB Voyager tiles
class OpenFreeMapConfig implements MapProviderConfig {
  // No API Key required for OpenFreeMap

  // Selected tile index (CartoDB Voyager)
  static const int _selectedTileIndex = 0;

  // Available tile options
  static const List<Map<String, String>> _allTileOptions = [
    {
      'name': 'CartoDB Voyager',
      'url':
          'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      'description': 'Colorful, detailed map style',
    },
  ];

  // Default location (San Francisco)
  static const double _defaultLatitude = 37.7749;
  static const double _defaultLongitude = -122.4194;

  // Zoom constraints - not enforced by MapOptions, users can zoom freely
  static const double _defaultZoom = 15.0;
  static const double _minZoom = 0.0;
  static const double _maxZoom = 28.0;

  // Routing API base URL (OSRM - Open Route Service Machine)
  static const String routingBaseUrl =
      'https://router.project-osrm.org/route/v1';

  // Geocoding API base URL (Nominatim)
  static const String geocodingBaseUrl =
      'https://nominatim.openstreetmap.org/search';

  // Reverse geocoding URL
  static const String reverseGeocodingBaseUrl =
      'https://nominatim.openstreetmap.org/reverse';

  // User agent for tile requests
  static const String userAgentPackageName = 'com.pingparent.app';

  @override
  String get appBarTitle => 'OpenFreeMap';

  @override
  double get defaultLatitude => _defaultLatitude;

  @override
  double get defaultLongitude => _defaultLongitude;

  @override
  double get defaultZoom => _defaultZoom;

  @override
  int get selectedTileIndex => _selectedTileIndex;

  @override
  double get minZoom => _minZoom;

  @override
  double get maxZoom => _maxZoom;

  @override
  List<Map<String, String>> get allTileOptions => _allTileOptions;
}
