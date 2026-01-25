import 'package:taxify_driver_ui/config.dart';

/// Loading overlay widget for maps
class MapLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isLoading;

  const MapLoadingOverlay({
    super.key,
    this.message,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(Insets.i24),
        decoration: BoxDecoration(
          color: appTheme.screenDarkBg,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.primary),
            ),
            if (message != null) ...[
              SizedBox(height: Insets.i16),
              Text(
                message!,
                style: AppCss.lexendRegular14.textColor(appTheme.white),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
