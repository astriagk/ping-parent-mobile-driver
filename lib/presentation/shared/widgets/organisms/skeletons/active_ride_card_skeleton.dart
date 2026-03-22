import 'package:shimmer/shimmer.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/presentation/shared/widgets/molecules/common_bg_layout.dart';

// Helper widget to reduce Shimmer repetition
class _SkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const _SkeletonBox({
    required this.height,
    this.width,
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: appTheme.stroke,
      highlightColor: appTheme.borderColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: appTheme.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Skeleton for the Active Ride card shown in ActiveRideScreen
class ActiveRideCardSkeleton extends StatelessWidget {
  const ActiveRideCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgLayout(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          // Header row: avatar, name, rating, trip type badge
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      // Avatar skeleton (matching userProfileImage)
                      _SkeletonBox(
                        height: Insets.i50,
                        width: Insets.i50,
                        radius: Insets.i7,
                      ),
                      HSpace(Insets.i10),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            // Name skeleton
                            _SkeletonBox(
                              height: Insets.i16,
                              width: Insets.i100.toDouble(),
                            ),
                            VSpace(Insets.i6),
                            // Rating skeleton
                            _SkeletonBox(
                              height: Insets.i12,
                              width: Insets.i80.toDouble(),
                            )
                          ])),
                      // Trip type badge skeleton
                      _SkeletonBox(
                        height: Insets.i14,
                        width: Insets.i50.toDouble(),
                        radius: Insets.i4,
                      )
                    ]))
              ]),
          VSpace(Insets.i15),
          // Dotted line divider skeleton
          _SkeletonBox(
            height: 1,
            width: double.infinity,
          ),
          VSpace(Insets.i15),
          // Time and action buttons row
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Time skeleton
            _SkeletonBox(
              height: Insets.i12,
              width: Insets.i70.toDouble(),
            ),
            // Icon buttons skeleton (chat + call)
            Row(children: [
              _SkeletonBox(
                height: Insets.i36,
                width: Insets.i36,
                radius: Insets.i8,
              ),
              HSpace(Insets.i10),
              _SkeletonBox(
                height: Insets.i36,
                width: Insets.i36,
                radius: Insets.i8,
              ),
            ])
          ]),
          VSpace(Insets.i15),
          // Action button skeleton
          Row(children: [
            HSpace(Insets.i10),
            Expanded(
              child: _SkeletonBox(
                height: Insets.i48,
                width: double.infinity,
                radius: Insets.i8,
              ),
            )
          ]).marginOnly(top: Insets.i15, bottom: Insets.i10)
        ]));
  }
}
