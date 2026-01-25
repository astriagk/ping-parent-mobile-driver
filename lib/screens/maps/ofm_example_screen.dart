import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/common/maps/map_providers_registry.dart';
import 'package:taxify_driver_ui/widgets/maps/index.dart';

/// OpenFreeMap Example Screen - Main Map Screen
/// Uses CartoDB Voyager tiles with UniversalMapExampleScreen
class OpenFreeMapExampleScreen extends StatelessWidget {
  const OpenFreeMapExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = MapProvidersRegistry.getConfig('ofm');
    return UniversalMapExampleScreen(
      config: config,
      tileLayerBuilder: (urlTemplate) => OFMTileLayer(
        urlTemplate: urlTemplate,
      ),
    );
  }
}
