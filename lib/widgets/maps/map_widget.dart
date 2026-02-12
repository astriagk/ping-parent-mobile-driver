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
  final List<Marker> Function()? markers;
  final List<Polyline> Function()? polylines;
  final List<Polyline> Function(BuildContext context)? polylineBuilder;
  final Marker Function(LatLng point, BuildContext context)?
      currentLocationMarkerBuilder;
  final Function(TapPosition, LatLng)? onTap;
  final PositionCallback? onPositionChanged;
  final bool showControls;
  final bool showCurrentLocation;

  const MapWidget({
    super.key,
    required this.config,
    required this.tileLayerBuilder,
    this.markers,
    this.polylines,
    this.polylineBuilder,
    this.currentLocationMarkerBuilder,
    this.onTap,
    this.onPositionChanged,
    this.showControls = false,
    this.showCurrentLocation = true,
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
        _updateMarkers();
      });
      // Delay to ensure map controller is initialized
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _mapController.move(location, 15);
      }
    }
  }

  void _updateMarkers() {
    _markers = [
      if (widget.showCurrentLocation)
        widget.currentLocationMarkerBuilder?.call(_currentLocation!, context) ??
            MapMarkers.currentLocationMarker(_currentLocation!, context),
      ...?widget.markers?.call(),
    ];
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update markers if the markers callback changed or if parent data changed
    if (oldWidget.markers != widget.markers ||
        oldWidget.currentLocationMarkerBuilder !=
            widget.currentLocationMarkerBuilder) {
      if (_currentLocation != null) {
        setState(() {
          _updateMarkers();
        });
      }
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
      // Show map placeholder while loading location
      return Container(
        color: appTheme.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_outlined,
                size: 48,
                color: appTheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading map...',
                style: AppCss.lexendRegular14.textColor(appTheme.lightText),
              ),
            ],
          ),
        ),
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
            if ((widget.polylineBuilder?.call(context).isNotEmpty ?? false) ||
                (widget.polylines?.call().isNotEmpty ?? false))
              PolylineLayer(
                polylines: widget.polylineBuilder?.call(context) ??
                    widget.polylines?.call() ??
                    [],
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
