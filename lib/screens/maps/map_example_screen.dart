import 'package:skolo_driver/core/constants/map_config.dart';
import 'package:skolo_driver/config.dart' hide Marker, Polyline, LatLng;

/// Map Example Screen - Main Map Screen
/// Tiles with MapWidget
class MapExampleScreen extends StatelessWidget {
  const MapExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = MapProvidersRegistry.getConfig();
    return MapWidget(
      config: config,
      tileLayerBuilder: (urlTemplate) => MapTileLayer(
        urlTemplate: urlTemplate,
      ),
      showControls: true,
    );
  }
}
