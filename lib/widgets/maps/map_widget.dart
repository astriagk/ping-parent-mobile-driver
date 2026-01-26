import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxify_driver_ui/helper/location_service.dart';
import 'package:taxify_driver_ui/config.dart' hide Marker, Polyline, LatLng;
import 'package:taxify_driver_ui/widgets/maps/map_markers.dart';
import 'package:taxify_driver_ui/widgets/maps/map_controls.dart';

/// Configuration interface for map providers
/// Implement this to support different map providers
abstract class MapProviderConfig {
  String get appBarTitle;
  double get defaultZoom;
  double get minZoom;
  double get maxZoom;
  int get selectedTileIndex;
  List<Map<String, String>> get allTileOptions;
}

/// Unified Map Widget with full functionality
/// Combines map display with location services and controls
class MapWidget extends StatefulWidget {
  final MapProviderConfig config;
  final Widget Function(String urlTemplate) tileLayerBuilder;
  final List<Marker> Function()? additionalMarkers;
  final List<Polyline> Function()? polylines;
  final Function(TapPosition, LatLng)? onTap;
  final PositionCallback? onPositionChanged;
  final bool showControls;

  const MapWidget({
    super.key,
    required this.config,
    required this.tileLayerBuilder,
    this.additionalMarkers,
    this.polylines,
    this.onTap,
    this.onPositionChanged,
    this.showControls = false,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapController _mapController;
  List<Marker> _markers = [];
  late int _selectedTileIndex;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _selectedTileIndex = widget.config.selectedTileIndex;
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final location = await LocationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _currentLocation = location;
        _markers = [
          MapMarkers.currentLocationMarker(location, context),
          ...?widget.additionalMarkers?.call(),
        ];
      });
      _mapController.move(location, 15);
    }
  }

  void _changeTileLayer(int index) {
    setState(() {
      _selectedTileIndex = index;
    });
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
      _mapController.camera.center,
      currentZoom + 1,
    );
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(
      _mapController.camera.center,
      currentZoom - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMapBody(),
    );
  }

  Widget _buildMapBody() {
    if (_currentLocation == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation!,
            initialZoom: widget.config.defaultZoom,
            minZoom: widget.config.minZoom,
            maxZoom: widget.config.maxZoom,
            onTap: widget.onTap,
            onPositionChanged: widget.onPositionChanged,
          ),
          children: [
            widget.tileLayerBuilder(
              widget.config.allTileOptions[_selectedTileIndex]['url']!,
            ),
            if (widget.polylines?.call().isNotEmpty ?? false)
              PolylineLayer(
                polylines: widget.polylines!.call(),
              ),
            if (_markers.isNotEmpty)
              MarkerLayer(
                markers: _markers,
              ),
          ],
        ),
        if (widget.showControls)
          MapControls(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onMyLocation: () {
              _mapController.move(_currentLocation!, 15);
            },
            tileOptions: widget.config.allTileOptions,
            onTileSelected: _changeTileLayer,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
