import 'package:shimmer/shimmer.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/widgets/common_bg_layout.dart';

/// Skeleton box helper for shimmer effect
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

/// Skeleton loading state for DropStudentSelectionScreen
class DropStudentSelectionSkeleton extends StatelessWidget {
  const DropStudentSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selection count header skeleton
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.i20,
            vertical: Insets.i10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SkeletonBox(height: 14, width: 100),
              _SkeletonBox(height: 14, width: 80),
            ],
          ),
        ),
        // Student cards list
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return const _StudentCardSkeleton();
            },
          ),
        ),
        // Bottom button skeleton
        Padding(
          padding: EdgeInsets.all(Insets.i20),
          child: _SkeletonBox(height: 48, radius: 12),
        ),
      ],
    );
  }
}

/// Skeleton for individual student card
class _StudentCardSkeleton extends StatelessWidget {
  const _StudentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return CommonBgLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Avatar skeleton
                    _SkeletonBox(
                      height: Insets.i50,
                      width: Insets.i50,
                      radius: Insets.i7,
                    ),
                    HSpace(Insets.i6),
                    // Student info skeleton
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name skeleton
                        _SkeletonBox(
                          height: 14,
                          width: 120,
                        ),
                        VSpace(Insets.i6),
                        // Class skeleton
                        _SkeletonBox(
                          height: 12,
                          width: 80,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Selection indicator skeleton
              _SkeletonBox(
                height: Insets.i24,
                width: Insets.i24,
                radius: 12,
              ),
            ],
          ),
          VSpace(Insets.i15),
          // Dotted line placeholder
          _SkeletonBox(height: 1, width: double.infinity),
          VSpace(Insets.i15),
          // Parent info and action buttons skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SkeletonBox(height: 12, width: 100),
              Row(
                children: [
                  _SkeletonBox(height: 40, width: 40, radius: 20),
                  HSpace(Insets.i12),
                  _SkeletonBox(height: 40, width: 40, radius: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
