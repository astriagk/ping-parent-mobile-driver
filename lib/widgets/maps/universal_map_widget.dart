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
  double get defaultLatitude;
  double get defaultLongitude;
  double get defaultZoom;
  double get minZoom;
  double get maxZoom;
  int get selectedTileIndex;
  List<Map<String, String>> get allTileOptions;
}

/// Generic map widget that works with all map providers
/// This widget is provider-agnostic and accepts a TileLayer widget
class UniversalMapWidget extends StatelessWidget {
  final MapController? controller;
  final LatLng initialCenter;
  final double initialZoom;
  final Widget tileLayer; // Accept any tile layer widget
  final List<Marker> markers;
  final List<Polyline> polylines;
  final Function(TapPosition, LatLng)? onTap;
  final PositionCallback? onPositionChanged;
  final Widget? overlayWidget;

  /// Minimum zoom level (default: 5.0)
  final double minZoom;

  /// Maximum zoom level (default: 17.0)
  final double maxZoom;

  const UniversalMapWidget({
    super.key,
    this.controller,
    required this.initialCenter,
    this.initialZoom = 15.0,
    required this.tileLayer,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
    this.onPositionChanged,
    this.overlayWidget,
    this.minZoom = 5.0,
    this.maxZoom = 19.0,
  });

  /// Zoom in one level
  void zoomIn() {
    if (controller != null) {
      controller!.move(
        controller!.camera.center,
        controller!.camera.zoom + 1,
      );
    }
  }

  /// Zoom out one level
  void zoomOut() {
    if (controller != null) {
      controller!.move(
        controller!.camera.center,
        controller!.camera.zoom - 1,
      );
    }
  }

  /// Move to a specific location with optional zoom level
  void moveTo(LatLng location, {double? zoom}) {
    if (controller != null) {
      controller!.move(
        location,
        zoom ?? 15.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: controller,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: initialZoom,
            onTap: onTap,
            onPositionChanged: onPositionChanged,
          ),
          children: [
            tileLayer,
            if (polylines.isNotEmpty)
              PolylineLayer(
                polylines: polylines,
              ),
            if (markers.isNotEmpty)
              MarkerLayer(
                markers: markers,
              ),
          ],
        ),
        if (overlayWidget != null) overlayWidget!,
      ],
    );
  }
}

/// Consolidated Map Example Screen
/// Works with any map provider config
class UniversalMapExampleScreen extends StatefulWidget {
  final MapProviderConfig config;
  final Widget Function(String urlTemplate) tileLayerBuilder;

  const UniversalMapExampleScreen({
    super.key,
    required this.config,
    required this.tileLayerBuilder,
  });

  @override
  State<UniversalMapExampleScreen> createState() =>
      _UniversalMapExampleScreenState();
}

class _UniversalMapExampleScreenState extends State<UniversalMapExampleScreen> {
  late MapController _mapController;
  List<Marker> _markers = [];
  late int _selectedTileIndex;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _selectedTileIndex = widget.config.selectedTileIndex;
    _mapController = MapController();
    _initializeMap();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final location = await LocationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _currentLocation = location;
        _markers = [
          MapMarkers.currentLocationMarker(location, context),
        ];
      });
      _mapController.move(location, 15);
    } else if (mounted) {
      setState(() {
        _currentLocation = LatLng(
          widget.config.defaultLatitude,
          widget.config.defaultLongitude,
        );
        _markers = [
          MapMarkers.currentLocationMarker(_currentLocation!, context),
        ];
      });
    }
  }

  void _initializeMap() {
    _currentLocation = LatLng(
      widget.config.defaultLatitude,
      widget.config.defaultLongitude,
    );
    _markers = [
      MapMarkers.currentLocationMarker(_currentLocation!, context),
    ];
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
      appBar: AppBar(
        title: Text(widget.config.appBarTitle,
            style: AppCss.lexendBold16.textColor(appTheme.white)),
        backgroundColor: appTheme.primary,
        actions: [
          PopupMenuButton<int>(
            onSelected: _changeTileLayer,
            itemBuilder: (BuildContext context) {
              return List<PopupMenuEntry<int>>.generate(
                widget.config.allTileOptions.length,
                (index) => PopupMenuItem<int>(
                  value: index,
                  child: Text(
                    widget.config.allTileOptions[index]['name']!,
                    style: AppCss.lexendRegular14.textColor(appTheme.darkText),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: UniversalMapWidget(
        controller: _mapController,
        initialCenter: LatLng(
          widget.config.defaultLatitude,
          widget.config.defaultLongitude,
        ),
        initialZoom: widget.config.defaultZoom,
        minZoom: widget.config.minZoom,
        maxZoom: widget.config.maxZoom,
        tileLayer: widget.tileLayerBuilder(
          widget.config.allTileOptions[_selectedTileIndex]['url']!,
        ),
        markers: _markers,
        polylines: const [],
        overlayWidget: MapControls(
          onZoomIn: _zoomIn,
          onZoomOut: _zoomOut,
          onMyLocation: () async {
            if (_currentLocation != null) {
              _mapController.move(_currentLocation!, 15);
            } else {
              final location = await LocationService.getCurrentLocation();
              if (location != null && mounted) {
                setState(() {
                  _currentLocation = location;
                });
                _mapController.move(location, 15);
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Unable to get your location. Please enable location permissions.'),
                  ),
                );
              }
            }
          },
          tileOptions: widget.config.allTileOptions,
          onTileSelected: _changeTileLayer,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
