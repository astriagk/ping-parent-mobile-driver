import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../config.dart';
import '../../widgets/common_bg_layout.dart';
import '../../widgets/common_divider.dart';

class RideDetailsProvider extends ChangeNotifier {
  double currentRating = 3.0;
  bool isPaymentComplete = false;

  rating(rating) {
    if (rating == rating.toInt()) {
      return rating.toInt().toString();
    } else {
      return rating.toStringAsFixed(1);
    }
  }

  bool isDeleted = false;

  showBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(Insets.i20))),
        context: context,
        builder: (context) {
          return Consumer<RideDetailsProvider>(
              builder: (context, rideDetailsPvr, child) {
            return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.i20, vertical: Insets.i22),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language(context, appFonts.rateACustomer),
                                    style: AppCss.lexendSemiBold16
                                        .textColor(appTheme.primary))
                                .marginOnly(
                                    left: MediaQuery.of(context).size.width *
                                        0.25),
                            VSpace(Insets.i22),
                            SvgPicture.asset(svgAssets.close)
                                .inkWell(onTap: () => route.pop(context))
                          ]),
                      VSpace(Insets.i22),
                      CommonBgLayout(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Expanded(
                                child: RatingBar.builder(
                                    initialRating: rideDetailsPvr.currentRating,
                                    glow: false,
                                    itemSize: 30,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    unratedColor: appTheme.stroke,
                                    itemPadding:
                                        EdgeInsets.only(right: Insets.i16),
                                    itemBuilder: (context, _) =>
                                        SvgPicture.asset(svgAssets.star1),
                                    onRatingUpdate: (rating) {
                                      rideDetailsPvr.currentRating = rating;
                                      log('$rating');
                                    })),
                            CommonDivider(
                                height: Insets.i26,
                                margin: EdgeInsets.only(right: Insets.i10)),
                            Text(
                                '${rideDetailsPvr.rating(rideDetailsPvr.currentRating)}/5',
                                style: AppCss.lexendMedium16
                                    .textColor(appTheme.primary))
                          ])),
                      VSpace(Insets.i15),
                      Text(language(context, appFonts.customMessage),
                          style: AppCss.lexendMedium14
                              .textColor(appTheme.primary)),
                      VSpace(Insets.i8),
                      TextField(
                          decoration: InputDecoration(
                              hintText: language(context, appFonts.writeHere),
                              hintStyle: AppCss.lexendRegular12
                                  .textColor(appTheme.lightText),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: appTheme.bgBox),
                          maxLines: 3),
                      VSpace(Insets.i25),
                      CommonButton(
                          text: language(context, appFonts.submitReview),
                          onTap: () => {
                                route.pop(context),
                                rideDetailsPvr.isCompleteRide = true,
                                rideDetailsPvr.notifyListeners()
                              })
                    ]));
          });
        });
  }

  paymentRequest() {
    isPaymentComplete = true;
    notifyListeners();
  }

  bool isCompleteRide = false;

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
}
