import 'package:get/get.dart';

import '../modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import '../modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/lft_details/bindings/lft_details_binding.dart';
import '../modules/lft_details/views/lft_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/placeholder/bindings/placeholder_binding.dart';
import '../modules/placeholder/views/placeholder_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

// import '../modules/detector_widget/bindings/detector_widget_binding.dart';
// import '../modules/detector_widget/views/detector_widget_view.dart';
// import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => const HomeView(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
        name: _Paths.SPLASH_SCREEN,
        page: () => const SplashScreenView(),
        binding: SplashScreenBinding(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(seconds: 1)),
    GetPage(
        name: _Paths.ONBOARDING,
        page: () => const OnboardingView(),
        binding: OnboardingBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 600)),
    // GetPage(
    //   name: _Paths.DETECTOR_WIDGET,
    //   page: () => const DetectorWidget(),
    //   binding: DetectorWidgetBinding(),
    // ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.PLACEHOLDER,
      page: () => const PlaceholderView(),
      binding: PlaceholderBinding(),
    ),
    GetPage(
        name: _Paths.BOTTOM_NAV_BAR,
        page: () => const BottomNavBarView(),
        binding: BottomNavBarBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 600)),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginView(),
        binding: LoginBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 600)),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LFT_DETAILS,
      page: () => const LftDetailsView(),
      binding: LftDetailsBinding(),
    ),
  ];
}
