import 'package:skolo_driver/presentation/shared/widgets/organisms/maps/map_widget.dart';

/// OpenFreeMap Configuration with CartoDB Voyager tiles
class MapConfig implements MapProviderConfig {
  // No API Key required for OpenFreeMap

  // Selected tile index (CartoDB Voyager)
  static const int _selectedTileIndex = 0;
  static const String apiKey = 'WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G';

  // Available tile options with their associated APIs
  static const List<Map<String, dynamic>> _allTileOptions = [
    {
      'name': 'Open Free Map CartoDB Voyager',
      'url':
          'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      'description': 'Colorful, detailed map style',
      'routingBaseUrl': 'https://router.project-osrm.org/route/v1',
      'geocodingBaseUrl': 'https://nominatim.openstreetmap.org/search',
      'reverseGeocodingBaseUrl': 'https://nominatim.openstreetmap.org/reverse',
    },
    {
      'name': 'TomTom Basic Main',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Standard daytime map style',
      'routingBaseUrl': 'https://api.tomtom.com/routing/1',
      'geocodingBaseUrl': 'https://api.tomtom.com/search/2',
      'reverseGeocodingBaseUrl': 'https://api.tomtom.com/search/2/reverse',
    },
  ];

  // Zoom constraints - not enforced by MapOptions, users can zoom freely
  static const double _defaultZoom = 15.0;
  static const double _minZoom = 10.0;
  static const double _maxZoom = 28.0;

  // User agent for tile requests
  static const String userAgentPackageName = 'com.pingparent.app';

  @override
  String get appBarTitle => 'Map';

  @override
  double get defaultZoom => _defaultZoom;

  @override
  int get selectedTileIndex => _selectedTileIndex;

  @override
  double get minZoom => _minZoom;

  @override
  double get maxZoom => _maxZoom;

  @override
  List<Map<String, String>> get allTileOptions => _allTileOptions
      .map((option) => {
            'name': option['name'] as String,
            'url': option['url'] as String,
            'description': option['description'] as String,
          })
      .toList();

  /// Get routing API base URL based on selected tile index
  String get routingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['routingBaseUrl'] as String;

  /// Get geocoding API base URL based on selected tile index
  String get geocodingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['geocodingBaseUrl'] as String;

  /// Get reverse geocoding API base URL based on selected tile index
  String get reverseGeocodingBaseUrl =>
      _allTileOptions[_selectedTileIndex]['reverseGeocodingBaseUrl'] as String;
}

/// Registry of available map providers
/// Currently using MapConfig
class MapProvidersRegistry {
  /// Single available map provider
  static const List<MapProvider> availableProviders = [
    MapProvider(
      id: 'map_config',
      name: 'Map Provider',
      description: 'Map with multiple tile options',
      tileCount: 2,
    ),
  ];

  /// Get config instance
  static MapProviderConfig getConfig() {
    return MapConfig();
  }

  /// Get tile options
  static List<Map<String, String>> getTileOptions() {
    return MapConfig().allTileOptions;
  }

  /// Check if provider exists
  static bool hasProvider() {
    return true; // MapConfig is always available
  }

  /// Get provider info
  static MapProvider? getProviderInfo() {
    return availableProviders.first;
  }
}

/// Model for map provider information
class MapProvider {
  final String id;
  final String name;
  final String description;
  final int tileCount;

  const MapProvider({
    required this.id,
    required this.name,
    required this.description,
    required this.tileCount,
  });

  @override
  String toString() => '$name ($tileCount tile)';
}
