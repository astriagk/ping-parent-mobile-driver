import 'package:skolo_driver/config.dart';
import 'package:shimmer/shimmer.dart';

class ProfileUpdateSkeleton extends StatelessWidget {
  const ProfileUpdateSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image circle skeleton
            Shimmer.fromColors(
              baseColor: appTheme.stroke,
              highlightColor: appTheme.borderColor,
              child: Container(
                width: Insets.i96.toDouble(),
                height: Insets.i96.toDouble(),
                decoration: BoxDecoration(
                  color: appTheme.white,
                  shape: BoxShape.circle,
                ),
              ),
            ).center(),
            VSpace(Insets.i25),
            Divider(color: appTheme.stroke, height: 0)
                .padding(bottom: Sizes.s20),
            // Name field skeleton
            _buildFieldSkeleton(),
            // Mobile number field skeleton
            _buildFieldSkeleton(),
            // Email field skeleton
            _buildFieldSkeleton(),
          ],
        )
            .padding(horizontal: Sizes.s20)
            .authExtension(context),
        // Update button skeleton
        Shimmer.fromColors(
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
        ).padding(horizontal: Sizes.s20, bottom: Sizes.s20),
      ],
    );
  }

  Widget _buildFieldSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        VSpace(Insets.i8),
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
    ).padding(bottom: Sizes.s20);
  }
}
