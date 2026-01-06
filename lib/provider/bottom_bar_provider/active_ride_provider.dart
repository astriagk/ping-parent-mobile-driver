import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/widgets/common_confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveRideProvider extends ChangeNotifier {
  cancelRideTap(context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
              message: "Are you sure you want to cancel your ride?",
              onConfirm: () => removeRide(index, context),
              onCancel: () => route.pop(context));
        });
  }

  void removeRide(int index, context) {
    appArray.ridesData.removeAt(index);
    route.pop(context);
    notifyListeners();
  }

  Future<void> openDialer(String phoneNumber) async {
    // Request phone permission
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      // Try to launch the dialer
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        log("Could not open dialer");
      }
    } else if (status.isDenied) {
      log("Phone permission denied");
    } else if (status.isPermanentlyDenied) {
      log("Phone permission permanently denied, open app settings.");
      openAppSettings();
    }
  }
}
