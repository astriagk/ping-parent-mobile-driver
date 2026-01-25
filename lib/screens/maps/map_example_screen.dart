import 'package:taxify_driver_ui/common/maps/map_config.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/widgets/maps/index.dart';

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
    );
  }
}
