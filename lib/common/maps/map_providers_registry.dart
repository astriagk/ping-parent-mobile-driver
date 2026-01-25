import 'package:taxify_driver_ui/common/maps/open_free_map_config.dart';
import 'package:taxify_driver_ui/widgets/maps/universal_map_widget.dart';

/// Registry of available map providers
/// Currently using OpenFreeMap with CartoDB Voyager tiles
class MapProvidersRegistry {
  /// Single available map provider
  static const List<MapProvider> availableProviders = [
    MapProvider(
      id: 'ofm',
      name: 'OpenFreeMap',
      description: 'Free mapping with CartoDB Voyager tiles',
      tileCount: 1,
    ),
  ];

  /// Get config instance
  static MapProviderConfig getConfig(String providerId) {
    return OpenFreeMapConfig();
  }

  /// Get tile options
  static List<Map<String, String>> getTileOptions(String providerId) {
    return OpenFreeMapConfig().allTileOptions;
  }

  /// Check if provider exists
  static bool hasProvider(String providerId) {
    return true; // OpenFreeMap is always available
  }

  /// Get provider info
  static MapProvider? getProviderInfo(String providerId) {
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
