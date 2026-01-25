import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:taxify_driver_ui/common/maps/map_config.dart';

/// Map TileLayer widget for reusability
class MapTileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;

  const MapTileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = MapConfig();
    final url =
        urlTemplate ?? config.allTileOptions[config.selectedTileIndex]['url']!;
    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: MapConfig.userAgentPackageName,
      retinaMode: RetinaMode.isHighDensity(context),
      maxZoom: config.maxZoom,
    );
  }
}

/// Adaptive tile layer that switches based on theme
class MapAdaptiveTileLayer extends StatelessWidget {
  final String? lightTileUrl;
  final String? darkTileUrl;

  const MapAdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = MapConfig();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final url = isDark
        ? (darkTileUrl ?? config.allTileOptions[2]['url']!)
        : (lightTileUrl ??
            config.allTileOptions[config.selectedTileIndex]['url']!);

    return MapTileLayer(urlTemplate: url);
  }
}
