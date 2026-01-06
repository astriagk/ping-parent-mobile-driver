import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taxify_driver_ui/widgets/common_location_layout.dart';

import '../../../../../config.dart';
import '../../../../../widgets/common_bg_layout.dart';
import '../../../../../widgets/common_divider.dart';
import 'my_rides_tab_inner_common_layout.dart';

class CompletedRideDetailsScreen extends StatefulWidget {
  const CompletedRideDetailsScreen({super.key});

  @override
  State<CompletedRideDetailsScreen> createState() =>
      _CompletedRideDetailsScreenState();
}

class _CompletedRideDetailsScreenState
    extends State<CompletedRideDetailsScreen> {
  double currentRating = 3.0;

  String formatRating(double rating) {
    // Check if the rating is a whole number
    if (rating == rating.toInt()) {
      return rating
          .toInt()
          .toString(); // Convert to int and display without decimal
    } else {
      return rating.toStringAsFixed(1); // Display with 1 decimal place
    }
  }

  Future<void> copyAssetToFile() async {
    const fileName = 'dummy_invoice.pdf'; // Your PDF file name
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    // Check if the file already exists
    if (await File(filePath).exists()) {
      log('File already exists at $filePath');
      await openFile(filePath); // Open the PDF file
      return;
    }

    try {
      // Load the asset and write it to the file
      final byteData = await rootBundle.load('assets/$fileName');
      final buffer = byteData.buffer.asUint8List();
      final file = File(filePath);

      // Write the file to the device's storage
      await file.writeAsBytes(buffer, flush: true);
      log('File copied to $filePath');

      // Open the PDF file
      await openFile(filePath);
    } catch (e) {
      log('Error copying PDF: $e');
    }
  }

  Future<void> openFile(String path) async {
    final result = await OpenFile.open(path);
    log('Open file result: ${result.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyRidesTabInnerCommonLayout(
            title: language(context, appFonts.completedRide),
            body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language(context, appFonts.rateUs),
                                    style: AppCss.lexendMedium14
                                        .textColor(appTheme.primary))
                                .marginOnly(bottom: Insets.i8),
                            CommonBgLayout(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Expanded(
                                      child: RatingBar.builder(
                                          initialRating: currentRating,
                                          glow: false,
                                          itemSize: 30,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          unratedColor: appTheme.stroke,
                                          itemPadding: EdgeInsets.only(
                                              right: Insets.i16),
                                          itemBuilder: (context, _) =>
                                              SvgPicture.asset(svgAssets.star2),
                                          onRatingUpdate: (rating) {
                                            setState(() {
                                              currentRating = rating;
                                            });
                                            log("$rating");
                                          })),
                                  CommonDivider(
                                      height: Insets.i26,
                                      margin:
                                          EdgeInsets.only(right: Insets.i10)),
                                  Text('${formatRating(currentRating)}/5',
                                      style: AppCss.lexendMedium16
                                          .textColor(appTheme.primary))
                                ])),
                            Divider(color: appTheme.stroke)
                                .marginSymmetric(vertical: Insets.i10),
                            Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(language(context, appFonts.date),
                                        style: AppCss.lexendRegular12
                                            .textColor(appTheme.textClr)),
                                    Row(children: [
                                      Text(
                                          language(
                                              context, appFonts.bookingDate),
                                          style: AppCss.lexendRegular14
                                              .textColor(appTheme.primary)),
                                      Text(
                                          language(
                                              context, appFonts.bookingTime),
                                          style: AppCss.lexendRegular14
                                              .textColor(appTheme.primary))
                                    ])
                                  ]),
                              VSpace(Insets.i8),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(language(context, appFonts.bookingID),
                                        style: AppCss.lexendRegular12
                                            .textColor(appTheme.textClr)),
                                    Text(
                                        language(
                                            context, appFonts.bookingIDNum),
                                        style: AppCss.lexendRegular14
                                            .textColor(appTheme.primary))
                                  ]),
                              VSpace(Insets.i8),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        language(
                                            context, appFonts.mobileNumber),
                                        style: AppCss.lexendRegular12
                                            .textColor(appTheme.textClr)),
                                    Text(language(context, appFonts.mobNo),
                                        style: AppCss.lexendRegular14
                                            .textColor(appTheme.primary))
                                  ])
                            ]),
                            VSpace(Insets.i15),
                            CommonLocationLayout(
                                pickUpAddress:
                                    language(context, appFonts.pickUpAdd),
                                droppingAddress:
                                    language(context, appFonts.dropAdd))
                          ]).marginSymmetric(horizontal: Insets.i20),
                      Text(language(context, appFonts.billSummary),
                              style: AppCss.lexendMedium14
                                  .textColor(appTheme.primary))
                          .marginOnly(
                              top: Insets.i25,
                              left: Insets.i20,
                              right: Insets.i20,
                              bottom: Insets.i10),
                      Container(
                          padding: EdgeInsets.all(Insets.i20),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/image/home/billSummary.png'))),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.rideFare),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.amount3),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]),
                            VSpace(Insets.i15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      language(
                                          context, appFonts.totalAccessFee),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.amount4),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]),
                            VSpace(Insets.i15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.rideFare),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.amount5),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.alertZone))
                                ]),
                            Divider(color: appTheme.textClr)
                                .marginSymmetric(vertical: Insets.i15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.totalBill),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.amount6),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.priceClr))
                                ])
                          ])),
                      Text(language(context, appFonts.paymentMethod),
                              style: AppCss.lexendMedium14
                                  .textColor(appTheme.primary))
                          .marginOnly(
                              top: Insets.i25,
                              left: Insets.i20,
                              right: Insets.i20,
                              bottom: Insets.i10),
                      Container(
                          padding: EdgeInsets.all(Insets.i20),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/image/home/payment.png'))),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.paymentID),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.payID),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]),
                            VSpace(Insets.i15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.methodType),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.cash),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary))
                                ]),
                            VSpace(Insets.i15),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language(context, appFonts.rideFare),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.primary)),
                                  Text(language(context, appFonts.paid),
                                      style: AppCss.lexendRegular14
                                          .textColor(appTheme.alertZone))
                                ])
                          ])),
                      CommonButton(
                          isIcon: true,
                          margin: EdgeInsets.symmetric(
                              horizontal: Insets.i20, vertical: Insets.i25),
                          color: appTheme.bgBox,
                          onTap: () {
                            copyAssetToFile();
                          },
                          textColor: appTheme.primary,
                          text: language(context, appFonts.downloadInvoice),
                          style: AppCss.lexendMedium14)
                    ]).marginOnly(
                    top: MediaQuery.of(context).size.height * 0.37)),
            rideStatus: language(context, appFonts.complete)));
  }
}
