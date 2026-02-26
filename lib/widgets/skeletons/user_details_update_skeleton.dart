import 'package:skolo_driver/config.dart';
import 'package:shimmer/shimmer.dart';

class UserDetailsUpdateSkeleton extends StatelessWidget {
  const UserDetailsUpdateSkeleton({super.key});

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
                    // Vehicle selection skeleton
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index) {
                          return Shimmer.fromColors(
                            baseColor: appTheme.stroke,
                            highlightColor: appTheme.borderColor,
                            child: Container(
                              width: Insets.i75.toDouble(),
                              height: Insets.i94.toDouble(),
                              decoration: BoxDecoration(
                                color: appTheme.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ).marginSymmetric(horizontal: Insets.i6),
                          );
                        }),
                      ),
                    ),
                    VSpace(Insets.i25),
                    // Name field skeleton
                    _buildFieldSkeleton(),
                    VSpace(Insets.i25),
                    // Email field skeleton
                    _buildFieldSkeleton(),
                    VSpace(Insets.i25),
                    // Vehicle number field skeleton
                    _buildFieldSkeleton(),
                    VSpace(Insets.i25),
                    // Maximum seats field skeleton
                    _buildFieldSkeleton(),
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
    );
  }
}
