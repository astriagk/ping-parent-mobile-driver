import 'package:shimmer/shimmer.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/widgets/common_bg_layout.dart';

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

class CustomerCardSkeleton extends StatelessWidget {
  const CustomerCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBgLayout(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          // Header row with avatar, name, rating, and price
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar skeleton
                      _SkeletonBox(
                        height: Insets.i50,
                        width: Insets.i50,
                        radius: Insets.i7,
                      ),
                      HSpace(Insets.i6),
                      Column(
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
                          ])
                    ]),
                // Price skeleton
                _SkeletonBox(
                  height: Insets.i24,
                  width: Insets.i60.toDouble(),
                )
              ]),
          VSpace(Insets.i15),
          // Divider
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
            // Icon buttons skeleton
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
          // Location skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBox(
                height: Insets.i12,
                width: double.infinity,
              ),
              VSpace(Insets.i10),
              _SkeletonBox(
                height: Insets.i12,
                width: double.infinity,
              ),
            ],
          ),
          VSpace(Insets.i15),
          // Buttons skeleton
          Row(
            children: [
              Expanded(
                child: _SkeletonBox(
                  height: Insets.i48,
                  width: double.infinity,
                  radius: Insets.i8,
                ),
              ),
              SizedBox(width: Insets.i10),
              Expanded(
                child: _SkeletonBox(
                  height: Insets.i48,
                  width: double.infinity,
                  radius: Insets.i8,
                ),
              ),
            ],
          )
        ])).marginSymmetric(horizontal: Insets.i20, vertical: Insets.i7);
  }
}
