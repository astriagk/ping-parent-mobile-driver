import 'package:skolo_driver/screens/app_pages/app_settings/app_setting_screen.dart';
import 'package:skolo_driver/screens/app_pages/notifications_screen/empty_notification.dart';
import 'package:skolo_driver/screens/app_pages/notifications_screen/notification_screen.dart';
import 'package:skolo_driver/screens/auth_screen/onboarding_screen/onboarding_screen.dart';
import 'package:skolo_driver/screens/auth_screen/otp_screen/otp_screen.dart';
import 'package:skolo_driver/screens/auth_screen/sign_in_screen/sign_in_screen.dart';
import 'package:skolo_driver/screens/auth_screen/splash_screen/splash_screen.dart';
import '../config.dart';
import '../screens/app_pages/bank_details_screen/bank_details_screen.dart';
import '../screens/app_pages/chat_screen/chat_screen.dart';
import '../screens/app_pages/document_registration_update/document_update_screen.dart';
import '../screens/app_pages/my_wallet_screen/layouts/top_up_wallet_screen.dart';
import '../screens/app_pages/my_wallet_screen/layouts/withdraw_screen.dart';
import '../screens/app_pages/my_wallet_screen/my_wallet_screen.dart';
import '../screens/app_pages/offer_list_screen/create_offer_screen.dart';
import '../screens/app_pages/offer_list_screen/offer_screen.dart';
import '../screens/app_pages/profile_screen/profile_screen.dart';
import '../screens/app_pages/save_location_screen/save_location_screen.dart';
import '../screens/app_pages/user_details_update/user_details_update_screen.dart';
import '../screens/bottom_navigation_bar/bottom_bar.dart';
import '../screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/cancel_ride_details_screen.dart';
import '../screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/completed_ride_details_screen.dart';
import '../screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_details_screen.dart';
import '../screens/bottom_navigation_bar/layouts/pick_up_customer_screen/pick_up_customer_screen.dart';
import '../screens/bottom_navigation_bar/layouts/drop_student_selection_screen/drop_student_selection_screen.dart';
import '../screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/ride_details_screen.dart';

class AppRoute {
  Map<String, Widget Function(BuildContext)> route = {
    routeName.splash: (p0) => const SplashScreen(),
    routeName.otpScreen: (p0) => const OtpScreen(),
    routeName.chatScreen: (p0) => const ChatScreen(),
    routeName.onBoard: (p0) => const OnboardingScreen(),
    routeName.signInScreen: (p0) => const SignInScreen(),
    routeName.signUpScreen: (p0) => const SignUpScreen(),
    routeName.documentsOnboarding: (p0) => const DocumentsOnboardingScreen(),
    routeName.userOnboarding: (p0) => const UserOnboardingScreen(),
    routeName.bankOnboarding: (p0) => const BankOnboardingScreen(),
    routeName.profileScreen: (p0) => const ProfileScreen(),
    routeName.withdrawScreen: (p0) => const WithdrawScreen(),
    routeName.myWalletScreen: (p0) => const MyWalletScreen(),
    routeName.offerListScreen: (p0) => const OfferListScreen(),
    routeName.appSettingScreen: (p0) => const AppSettingScreen(),
    routeName.bankDetailsScreen: (p0) => const BankDetailsScreen(),
    routeName.topUpWalletScreen: (p0) => const TopUpWalletScreen(),
    routeName.saveLocationScreen: (p0) => const SaveLocationScreen(),
    routeName.commonBottomBar: (p0) => const CommonBottomNavigationBar(),
    routeName.pendingRideDetails: (p0) => const PendingRideDetailsScreen(),
    routeName.completedRideDetails: (p0) => const CompletedRideDetailsScreen(),
    routeName.cancelRideDetailsScreen: (p0) => const CancelRideDetailsScreen(),
    routeName.createOfferScreen: (p0) => const CreateOfferScreen(),
    routeName.documentUpdateScreen: (p0) => const DocumentUpdateScreen(),
    routeName.userUpdateScreen: (p0) => const UserUpdateScreen(),
    routeName.pickupCustomerScreen: (p0) => const PickUpCustomerScreen(),
    routeName.dropStudentSelectionScreen: (p0) =>
        const DropStudentSelectionScreen(),
    routeName.rideDetailsScreen: (p0) => const RideDetailsScreen(),
    routeName.notificationScreen: (p0) => const NotificationScreen(),
    routeName.emptyNotificationScreen: (p0) => const EmptyNotification()
  };
}
