import 'package:skolo_driver/config.dart';

/// Map controls widget for zoom and layer controls
class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final VoidCallback? onLayers;
  final List<Map<String, String>>? tileOptions;
  final Function(int)? onTileSelected;
  final bool showLayersButton;
  final Alignment alignment;

  const MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
    this.onLayers,
    this.tileOptions,
    this.onTileSelected,
    this.showLayersButton = true,
    this.alignment = Alignment.bottomRight,
  });

  /// Build a reusable control button
  Widget _buildControlButton(IconData icon, VoidCallback? onPressed) {
    return FloatingActionButton(
      mini: true,
      heroTag: null,
      backgroundColor: appTheme.white,
      onPressed: onPressed,
      child: Icon(icon, color: appTheme.primary),
    );
  }

  /// Build spacer between buttons
  Widget _buildSpacer() => SizedBox(height: Insets.i8);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(Insets.i16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(Icons.add, onZoomIn),
            _buildSpacer(),
            _buildControlButton(Icons.remove, onZoomOut),
            _buildSpacer(),
            _buildControlButton(Icons.my_location, onMyLocation),
            if (showLayersButton) _buildSpacer(),
            if (showLayersButton)
              PopupMenuButton<int>(
                onSelected: onTileSelected,
                child: _buildControlButton(Icons.layers, null),
                itemBuilder: (BuildContext context) {
                  if (tileOptions == null || tileOptions!.isEmpty) {
                    return [];
                  }
                  return List<PopupMenuEntry<int>>.generate(
                    tileOptions!.length,
                    (index) => PopupMenuItem<int>(
                      value: index,
                      child: Text(
                        tileOptions![index]['name']!,
                        style:
                            AppCss.lexendRegular14.textColor(appTheme.darkText),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
