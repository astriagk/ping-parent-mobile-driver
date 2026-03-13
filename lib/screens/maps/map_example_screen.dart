import 'package:skolo_driver/common/maps/map_config.dart';
import 'package:skolo_driver/config.dart' hide Marker, Polyline, LatLng;
import 'package:skolo_driver/widgets/maps/index.dart';

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
