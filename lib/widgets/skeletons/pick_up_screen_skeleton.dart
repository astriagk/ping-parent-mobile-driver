import 'package:shimmer/shimmer.dart';
import 'package:taxify_driver_ui/config.dart';

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

/// Skeleton loading state for PickUpCustomerScreen
/// Shows placeholder for map header, map area and bottom sheet
class PickUpScreenSkeleton extends StatelessWidget {
  const PickUpScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Map header skeleton (matches CommonMapHeader)
        Container(
          decoration: ShapeDecoration(
            color: appColor(context).appTheme.bgBox,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                bottomLeft: SmoothRadius(
                  cornerRadius: 20,
                  cornerSmoothing: 0.6,
                ),
                bottomRight: SmoothRadius(
                  cornerRadius: 20,
                  cornerSmoothing: 0.6,
                ),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.i12,
                vertical: Insets.i10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button placeholder (circular)
                  _SkeletonBox(height: 40, width: 40, radius: 20),
                  SizedBox(width: Insets.i10),
                  // Waypoint info and stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stop progress
                        _SkeletonBox(height: 14, width: 100),
                        SizedBox(height: Insets.i2),
                        // Address
                        _SkeletonBox(height: 12, width: double.infinity),
                        SizedBox(height: Insets.i8),
                        // Compact info chips row
                        Row(
                          children: [
                            _CompactChipSkeleton(),
                            SizedBox(width: Insets.i8),
                            _CompactChipSkeleton(),
                            SizedBox(width: Insets.i8),
                            _CompactChipSkeleton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Map area skeleton
        Expanded(
          child: Shimmer.fromColors(
            baseColor: appTheme.stroke.withOpacity(0.3),
            highlightColor: appTheme.borderColor,
            child: Container(
              color: appTheme.bgBox,
            ),
          ),
        ),

        // Bottom sheet skeleton (matches OtpVerificationSheet)
        Container(
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(Insets.i20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: "Next Ride" + car image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(height: 18, width: 80),
                  _SkeletonBox(height: 25, width: 40),
                ],
              ),
              SizedBox(height: Insets.i15),

              // Divider
              _SkeletonBox(height: 1, width: double.infinity),
              SizedBox(height: Insets.i15),

              // User row: Avatar + Name + Call button
              Row(
                children: [
                  _SkeletonBox(height: 40, width: 40, radius: 20),
                  SizedBox(width: Insets.i8),
                  Expanded(
                    child: _SkeletonBox(height: 14, width: 100),
                  ),
                  SizedBox(width: Insets.i8),
                  _SkeletonBox(height: 40, width: 40, radius: 20),
                ],
              ),
              SizedBox(height: Insets.i12),

              // Student rows with toggle
              _StudentRowSkeleton(),
              SizedBox(height: Insets.i8),
              _StudentRowSkeleton(),
              SizedBox(height: Insets.i15),

              // Divider
              _SkeletonBox(height: 1, width: double.infinity),
              SizedBox(height: Insets.i15),

              // OTP text field skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(height: 12, width: 100),
                  SizedBox(height: Insets.i8),
                  _SkeletonBox(height: 48, width: double.infinity, radius: 8),
                ],
              ),
              SizedBox(height: Insets.i25),

              // Button row: Absent (small) + Verify OTP (expanded)
              Row(
                children: [
                  _SkeletonBox(height: 48, width: 80, radius: 12),
                  SizedBox(width: Insets.i12),
                  Expanded(
                    child: _SkeletonBox(height: 48, radius: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Skeleton for compact info chip (Distance/Duration/ETA)
class _CompactChipSkeleton extends StatelessWidget {
  const _CompactChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.i8,
        vertical: Insets.i4,
      ),
      decoration: BoxDecoration(
        color: appColor(context).appTheme.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonBox(height: 14, width: 14, radius: 7),
          SizedBox(width: Insets.i4),
          _SkeletonBox(height: 12, width: 35),
        ],
      ),
    );
  }
}

/// Skeleton for student row with toggle
class _StudentRowSkeleton extends StatelessWidget {
  const _StudentRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SkeletonBox(height: 12, width: 100),
        Row(
          children: [
            _SkeletonBox(height: 12, width: 50),
            SizedBox(width: Insets.i8),
            _SkeletonBox(height: 24, width: 44, radius: 12),
          ],
        ),
      ],
    );
  }
}
