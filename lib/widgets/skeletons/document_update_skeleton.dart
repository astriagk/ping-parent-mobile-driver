import 'package:skolo_driver/config.dart';
import 'package:shimmer/shimmer.dart';

class DocumentUpdateSkeleton extends StatelessWidget {
  const DocumentUpdateSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.i20.toDouble(),
                    vertical: Insets.i10.toDouble()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Driving License skeleton
                    _buildDocumentFieldSkeleton(),
                    VSpace(Insets.i25),
                    // Vehicle License Number skeleton
                    _buildDocumentFieldSkeleton(),
                    VSpace(Insets.i25),
                    // Insurance Number skeleton
                    _buildDocumentFieldSkeleton(),
                  ],
                ),
              ),
            ],
          ).authExtension(context)!,
          // Button skeleton
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s20.toDouble()),
            child: Shimmer.fromColors(
              baseColor: appTheme.stroke,
              highlightColor: appTheme.borderColor,
              child: Container(
                width: double.infinity,
                height: Sizes.s50.toDouble(),
                decoration: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: BorderRadius.circular(Insets.i10.toDouble()),
                ),
              ),
            ),
          ).marginOnly(bottom: Insets.i20, top: Insets.i10),
        ],
      ),
    );
  }

  Widget _buildDocumentFieldSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title skeleton
        Shimmer.fromColors(
          baseColor: appTheme.stroke,
          highlightColor: appTheme.borderColor,
          child: Container(
            width: Insets.i80.toDouble(),
            height: Insets.i16.toDouble(),
            decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: BorderRadius.circular(Insets.i4.toDouble()),
            ),
          ),
        ),
        VSpace(Insets.i10),
        // Upload container skeleton
        Shimmer.fromColors(
          baseColor: appTheme.stroke,
          highlightColor: appTheme.borderColor,
          child: Container(
            width: double.infinity,
            height: Insets.i94.toDouble(),
            decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: BorderRadius.circular(AppRadius.r12.toDouble()),
            ),
          ),
        ),
        VSpace(Insets.i12),
        // Text field skeleton
        Shimmer.fromColors(
          baseColor: appTheme.stroke,
          highlightColor: appTheme.borderColor,
          child: Container(
            width: double.infinity,
            height: Insets.i50.toDouble(),
            decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: BorderRadius.circular(Insets.i8.toDouble()),
            ),
          ),
        ),
      ],
    );
  }
}
