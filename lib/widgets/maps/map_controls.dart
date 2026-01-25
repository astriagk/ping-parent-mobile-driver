import 'package:flutter/material.dart';
import 'package:taxify_driver_ui/config.dart';

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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(Insets.i16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zoom In Button
            FloatingActionButton(
              mini: true,
              heroTag: 'zoom_in_btn',
              backgroundColor: appTheme.white,
              onPressed: onZoomIn,
              tooltip: 'Zoom In',
              child: Icon(Icons.add, color: appTheme.primary),
            ),
            SizedBox(height: Insets.i8),
            // Zoom Out Button
            FloatingActionButton(
              mini: true,
              heroTag: 'zoom_out_btn',
              backgroundColor: appTheme.white,
              onPressed: onZoomOut,
              tooltip: 'Zoom Out',
              child: Icon(Icons.remove, color: appTheme.primary),
            ),
            SizedBox(height: Insets.i8),
            // My Location Button
            FloatingActionButton(
              mini: true,
              heroTag: 'my_location_btn',
              backgroundColor: appTheme.white,
              onPressed: onMyLocation,
              tooltip: 'My Location',
              child: Icon(Icons.my_location, color: appTheme.primary),
            ),
            if (showLayersButton) SizedBox(height: Insets.i8),
            // Layers Button
            if (showLayersButton)
              PopupMenuButton<int>(
                onSelected: onTileSelected,
                tooltip: 'Change Layer',
                child: FloatingActionButton(
                  mini: true,
                  heroTag: 'layers_btn',
                  backgroundColor: appTheme.white,
                  onPressed: null,
                  tooltip: 'Change Layer',
                  child: Icon(Icons.layers, color: appTheme.primary),
                ),
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
