import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/models/rides_info_model.dart';
import 'package:skolo_driver/widgets/common_divider.dart';
import 'package:skolo_driver/widgets/common_location_layout.dart';

class CommonUpcomingRideLayout extends StatelessWidget {
  final RideInfo rideInfo;
  final GestureTapCallback? onTap;

  const CommonUpcomingRideLayout(
      {super.key, required this.rideInfo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(Insets.i15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: appTheme.primary.withValues(alpha: 0.06),
                  offset: const Offset(0, 4),
                  blurRadius: Insets.i20,
                  blurStyle: BlurStyle.normal)
            ],
            color: appTheme.white,
            border: Border.all(width: Insets.i1, color: appTheme.bgBox),
            borderRadius: SmoothBorderRadius(
                cornerRadius: Insets.i10, cornerSmoothing: Insets.i20)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                  height: Insets.i25,
                  width: Insets.i25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(rideInfo.userImage)))),
              HSpace(Insets.i6),
              Text(rideInfo.userName,
                  style: AppCss.lexendRegular12.textColor(appTheme.primary))
            ]),
            Row(children: [
              SvgPicture.asset(svgAssets.star),
              HSpace(Insets.i3),
              Text(rideInfo.rating,
                  style: AppCss.lexendRegular12.textColor(appTheme.primary)),
              HSpace(Insets.i4),
              CommonDivider(height: Insets.i16),
              HSpace(Insets.i4),
              Text('\$${rideInfo.price}',
                  style: AppCss.lexendMedium16.textColor(appTheme.priceClr))
            ])
          ]),
          VSpace(Insets.i16),
          homeScreenWidget.dottedLineCommon(),
          VSpace(Insets.i15),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SvgPicture.asset(
                      height: Insets.i15,
                      width: Insets.i15,
                      svgAssets.location),
                  HSpace(Insets.i2),
                  Text(rideInfo.distance,
                      style: AppCss.lexendRegular12
                          .textColor(appTheme.primary)
                          .textHeight(1.3))
                ]),
                Text(rideInfo.dateTime,
                    style: AppCss.lexendRegular12.textColor(appTheme.textClr))
              ]),
          VSpace(Insets.i15),
          CommonLocationLayout(
              pickUpAddress: rideInfo.pickUpAddress,
              droppingAddress: rideInfo.dropOffAddress)
        ])).marginOnly(bottom: Insets.i10).inkWell(onTap: onTap);
  }
}
