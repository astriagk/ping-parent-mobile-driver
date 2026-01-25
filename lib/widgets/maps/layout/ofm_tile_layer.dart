import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:taxify_driver_ui/common/maps/open_free_map_config.dart';

/// OpenFreeMap TileLayer widget for reusability
class OFMTileLayer extends StatelessWidget {
  final String? urlTemplate;
  final Key? tileKey;

  const OFMTileLayer({
    this.urlTemplate,
    this.tileKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = OpenFreeMapConfig();
    final url =
        urlTemplate ?? config.allTileOptions[config.selectedTileIndex]['url']!;
    return TileLayer(
      key: tileKey,
      urlTemplate: url,
      userAgentPackageName: OpenFreeMapConfig.userAgentPackageName,
      retinaMode: RetinaMode.isHighDensity(context),
      maxZoom: config.maxZoom,
    );
  }
}

/// Adaptive tile layer that switches based on theme
class OFMAdaptiveTileLayer extends StatelessWidget {
  final String? lightTileUrl;
  final String? darkTileUrl;

  const OFMAdaptiveTileLayer({
    this.lightTileUrl,
    this.darkTileUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = OpenFreeMapConfig();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final url = isDark
        ? (darkTileUrl ?? config.allTileOptions[2]['url']!)
        : (lightTileUrl ??
            config.allTileOptions[config.selectedTileIndex]['url']!);

    return OFMTileLayer(urlTemplate: url);
  }
}
