import 'package:go_router/go_router.dart';
import 'package:skolo_driver/presentation/features/auth/pages/sign_in_page.dart';
import 'package:skolo_driver/presentation/features/auth/pages/sign_up_page.dart';
import 'package:skolo_driver/screens/app_pages/app_settings/app_setting_screen.dart';
import 'package:skolo_driver/screens/app_pages/bank_details_screen/bank_details_screen.dart';
import 'package:skolo_driver/screens/app_pages/chat_screen/chat_screen.dart';
import 'package:skolo_driver/screens/app_pages/document_registration_update/document_update_screen.dart';
import 'package:skolo_driver/screens/app_pages/my_wallet_screen/layouts/top_up_wallet_screen.dart';
import 'package:skolo_driver/screens/app_pages/my_wallet_screen/layouts/withdraw_screen.dart';
import 'package:skolo_driver/screens/app_pages/my_wallet_screen/my_wallet_screen.dart';
import 'package:skolo_driver/screens/app_pages/notifications_screen/empty_notification.dart';
import 'package:skolo_driver/screens/app_pages/notifications_screen/notification_screen.dart';
import 'package:skolo_driver/screens/app_pages/offer_list_screen/create_offer_screen.dart';
import 'package:skolo_driver/screens/app_pages/offer_list_screen/offer_screen.dart';
import 'package:skolo_driver/screens/app_pages/profile_screen/profile_screen.dart';
import 'package:skolo_driver/screens/app_pages/save_location_screen/save_location_screen.dart';
import 'package:skolo_driver/screens/app_pages/user_details_update/user_details_update_screen.dart';
import 'package:skolo_driver/screens/auth_screen/bank_onboarding_screen/bank_onboarding_screen.dart';
import 'package:skolo_driver/screens/auth_screen/documents_onboarding_screen/documents_onboarding_screen.dart';
import 'package:skolo_driver/screens/auth_screen/onboarding_screen/onboarding_screen.dart';
import 'package:skolo_driver/screens/auth_screen/otp_screen/otp_screen.dart';
import 'package:skolo_driver/screens/auth_screen/splash_screen/splash_screen.dart';
import 'package:skolo_driver/screens/auth_screen/user_onboarding_screen/user_onboarding_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/bottom_bar.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/drop_student_selection_screen/drop_student_selection_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/cancel_ride_details_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/completed_ride_details_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/pending_ride_details_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/ride_details_screen.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/pick_up_customer_screen/pick_up_customer_screen.dart';

// ---------------------------------------------------------------------------
// Single source of truth for every route in the app.
// All paths use kebab-case. Legacy camelCase paths redirect to these.
// ---------------------------------------------------------------------------
enum AppRoute {
  // ── Auth ──────────────────────────────────────────────────────────────────
  splash(name: 'splash', path: '/'),
  signIn(name: 'sign-in', path: '/sign-in'),
  signUp(name: 'sign-up', path: '/sign-up'),
  otp(name: 'otp', path: '/otp'),
  onBoarding(name: 'on-boarding', path: '/on-boarding'),
  documentsOnboarding(
      name: 'documents-onboarding', path: '/documents-onboarding'),
  userOnboarding(name: 'user-onboarding', path: '/user-onboarding'),
  bankOnboarding(name: 'bank-onboarding', path: '/bank-onboarding'),

  // ── App screens ───────────────────────────────────────────────────────────
  chat(name: 'chat', path: '/chat'),
  profile(name: 'profile', path: '/profile'),
  withdraw(name: 'withdraw', path: '/withdraw'),
  myWallet(name: 'my-wallet', path: '/my-wallet'),
  topUpWallet(name: 'top-up-wallet', path: '/top-up-wallet'),
  offerList(name: 'offer-list', path: '/offer-list'),
  createOffer(name: 'create-offer', path: '/create-offer'),
  appSettings(name: 'app-settings', path: '/app-settings'),
  bankDetails(name: 'bank-details', path: '/bank-details'),
  saveLocation(name: 'save-location', path: '/save-location'),
  home(name: 'home', path: '/home'),
  notifications(name: 'notifications', path: '/notifications'),
  emptyNotifications(name: 'empty-notifications', path: '/empty-notifications'),

  // ── Ride / trip screens ───────────────────────────────────────────────────
  pendingRideDetails(name: 'pending-ride-details', path: '/pending-ride-details'),
  completedRideDetails(
      name: 'completed-ride-details', path: '/completed-ride-details'),
  cancelRideDetails(name: 'cancel-ride-details', path: '/cancel-ride-details'),
  documentUpdate(name: 'document-update', path: '/document-update'),
  userUpdate(name: 'user-update', path: '/user-update'),
  pickupCustomer(name: 'pickup-customer', path: '/pickup-customer'),
  dropStudentSelection(
      name: 'drop-student-selection', path: '/drop-student-selection'),
  rideDetails(name: 'ride-details', path: '/ride-details');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

// ---------------------------------------------------------------------------
// Router instance
// ---------------------------------------------------------------------------
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.splash.path,
  routes: [
    // ── Auth screens ──────────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.splash.path,
      name: AppRoute.splash.name,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoute.signIn.path,
      name: AppRoute.signIn.name,
      builder: (_, __) => const SignInPage(),
    ),
    GoRoute(
      path: AppRoute.signUp.path,
      name: AppRoute.signUp.name,
      builder: (_, __) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoute.otp.path,
      name: AppRoute.otp.name,
      // TODO: replace with migrated OtpPage once otp_screen is migrated
      builder: (_, __) => const OtpScreen(),
    ),
    GoRoute(
      path: AppRoute.onBoarding.path,
      name: AppRoute.onBoarding.name,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoute.documentsOnboarding.path,
      name: AppRoute.documentsOnboarding.name,
      builder: (_, __) => const DocumentsOnboardingScreen(),
    ),
    GoRoute(
      path: AppRoute.userOnboarding.path,
      name: AppRoute.userOnboarding.name,
      builder: (_, __) => const UserOnboardingScreen(),
    ),
    GoRoute(
      path: AppRoute.bankOnboarding.path,
      name: AppRoute.bankOnboarding.name,
      builder: (_, __) => const BankOnboardingScreen(),
    ),

    // ── App screens ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoute.chat.path,
      name: AppRoute.chat.name,
      builder: (_, __) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoute.profile.path,
      name: AppRoute.profile.name,
      builder: (_, __) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoute.withdraw.path,
      name: AppRoute.withdraw.name,
      builder: (_, __) => const WithdrawScreen(),
    ),
    GoRoute(
      path: AppRoute.myWallet.path,
      name: AppRoute.myWallet.name,
      builder: (_, __) => const MyWalletScreen(),
    ),
    GoRoute(
      path: AppRoute.topUpWallet.path,
      name: AppRoute.topUpWallet.name,
      builder: (_, __) => const TopUpWalletScreen(),
    ),
    GoRoute(
      path: AppRoute.offerList.path,
      name: AppRoute.offerList.name,
      builder: (_, __) => const OfferListScreen(),
    ),
    GoRoute(
      path: AppRoute.createOffer.path,
      name: AppRoute.createOffer.name,
      builder: (_, __) => const CreateOfferScreen(),
    ),
    GoRoute(
      path: AppRoute.appSettings.path,
      name: AppRoute.appSettings.name,
      builder: (_, __) => const AppSettingScreen(),
    ),
    GoRoute(
      path: AppRoute.bankDetails.path,
      name: AppRoute.bankDetails.name,
      builder: (_, __) => const BankDetailsScreen(),
    ),
    GoRoute(
      path: AppRoute.saveLocation.path,
      name: AppRoute.saveLocation.name,
      builder: (_, __) => const SaveLocationScreen(),
    ),
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (_, __) => const CommonBottomNavigationBar(),
    ),
    GoRoute(
      path: AppRoute.notifications.path,
      name: AppRoute.notifications.name,
      builder: (_, __) => const NotificationScreen(),
    ),
    GoRoute(
      path: AppRoute.emptyNotifications.path,
      name: AppRoute.emptyNotifications.name,
      builder: (_, __) => const EmptyNotification(),
    ),

    // ── Ride / trip screens ───────────────────────────────────────────────
    GoRoute(
      path: AppRoute.pendingRideDetails.path,
      name: AppRoute.pendingRideDetails.name,
      builder: (_, __) => const PendingRideDetailsScreen(),
    ),
    GoRoute(
      path: AppRoute.completedRideDetails.path,
      name: AppRoute.completedRideDetails.name,
      builder: (_, __) => const CompletedRideDetailsScreen(),
    ),
    GoRoute(
      path: AppRoute.cancelRideDetails.path,
      name: AppRoute.cancelRideDetails.name,
      builder: (_, __) => const CancelRideDetailsScreen(),
    ),
    GoRoute(
      path: AppRoute.documentUpdate.path,
      name: AppRoute.documentUpdate.name,
      builder: (_, __) => const DocumentUpdateScreen(),
    ),
    GoRoute(
      path: AppRoute.userUpdate.path,
      name: AppRoute.userUpdate.name,
      builder: (_, __) => const UserUpdateScreen(),
    ),
    GoRoute(
      path: AppRoute.pickupCustomer.path,
      name: AppRoute.pickupCustomer.name,
      builder: (_, __) => const PickUpCustomerScreen(),
    ),
    GoRoute(
      path: AppRoute.dropStudentSelection.path,
      name: AppRoute.dropStudentSelection.name,
      builder: (_, __) => const DropStudentSelectionScreen(),
    ),
    GoRoute(
      path: AppRoute.rideDetails.path,
      name: AppRoute.rideDetails.name,
      builder: (_, __) => const RideDetailsScreen(),
    ),

    // ── Legacy path redirects (old camelCase paths → canonical kebab-case)
    //    Remove each entry once all callers are updated to use AppRoute ─────
    GoRoute(path: '/signInScreen', redirect: (_, __) => AppRoute.signIn.path),
    GoRoute(path: '/signUpScreen', redirect: (_, __) => AppRoute.signUp.path),
    GoRoute(path: '/otpScreen', redirect: (_, __) => AppRoute.otp.path),
    GoRoute(path: '/onBoard', redirect: (_, __) => AppRoute.onBoarding.path),
    GoRoute(
        path: '/chatScreen', redirect: (_, __) => AppRoute.chat.path),
    GoRoute(
        path: '/documentsOnboarding',
        redirect: (_, __) => AppRoute.documentsOnboarding.path),
    GoRoute(
        path: '/userOnboarding',
        redirect: (_, __) => AppRoute.userOnboarding.path),
    GoRoute(
        path: '/bankOnboarding',
        redirect: (_, __) => AppRoute.bankOnboarding.path),
    GoRoute(
        path: '/profileScreen', redirect: (_, __) => AppRoute.profile.path),
    GoRoute(
        path: '/withdrawScreen', redirect: (_, __) => AppRoute.withdraw.path),
    GoRoute(
        path: '/myWalletScreen', redirect: (_, __) => AppRoute.myWallet.path),
    GoRoute(
        path: '/offerListScreen', redirect: (_, __) => AppRoute.offerList.path),
    GoRoute(
        path: '/appSettingScreen',
        redirect: (_, __) => AppRoute.appSettings.path),
    GoRoute(
        path: '/bankDetailsScreen',
        redirect: (_, __) => AppRoute.bankDetails.path),
    GoRoute(
        path: '/topUpWalletScreen',
        redirect: (_, __) => AppRoute.topUpWallet.path),
    GoRoute(
        path: '/saveLocationScreen',
        redirect: (_, __) => AppRoute.saveLocation.path),
    GoRoute(
        path: '/commonBottomBar', redirect: (_, __) => AppRoute.home.path),
    GoRoute(
        path: '/pendingRideDetails',
        redirect: (_, __) => AppRoute.pendingRideDetails.path),
    GoRoute(
        path: '/completedRideDetails',
        redirect: (_, __) => AppRoute.completedRideDetails.path),
    GoRoute(
        path: '/cancelRideDetailsScreen',
        redirect: (_, __) => AppRoute.cancelRideDetails.path),
    GoRoute(
        path: '/createOfferScreen',
        redirect: (_, __) => AppRoute.createOffer.path),
    GoRoute(
        path: '/documentUpdateScreen',
        redirect: (_, __) => AppRoute.documentUpdate.path),
    GoRoute(
        path: '/userUpdateScreen',
        redirect: (_, __) => AppRoute.userUpdate.path),
    GoRoute(
        path: '/pickupCustomerScreen',
        redirect: (_, __) => AppRoute.pickupCustomer.path),
    GoRoute(
        path: '/dropStudentSelectionScreen',
        redirect: (_, __) => AppRoute.dropStudentSelection.path),
    GoRoute(
        path: '/rideDetailsScreen',
        redirect: (_, __) => AppRoute.rideDetails.path),
    GoRoute(
        path: '/notificationScreen',
        redirect: (_, __) => AppRoute.notifications.path),
    GoRoute(
        path: '/emptyNotificationScreen',
        redirect: (_, __) => AppRoute.emptyNotifications.path),

    // TODO: Add ShellRoute with BottomNav for Drive + Notifications tabs
    // TODO: Add auth guard redirect (check SecureStorage for valid JWT)
  ],
);
