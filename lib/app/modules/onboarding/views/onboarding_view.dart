import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ordinary/app/routes/app_pages.dart';
import 'package:ordinary/app/shared/theme.dart';
import 'package:ordinary/app/widgets/OnBoardingWidgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: controller.indicator,
          onPageChanged: ((value) {
            controller.page.value = value;
            // print(controller.page.value);
          }),
          children: const [
            // start page onboarding
            OnBoardingWidgets(
              image: 'on_boarding_1.png',
              title: 'Get LFT Ready',
              subtitle:
                  'Place Lateral Flow Test (LFT) on top of a flat surface',
            ),
            OnBoardingWidgets(
              image: 'on_boarding_2.png',
              title: 'Adjust Phone\'s Position',
              subtitle:
                  'Frame the LFT to be in the middle of the camera preview by adjusting phone\'s position and angle',
            ),
            OnBoardingWidgets(
              image: 'on_boarding_3.png',
              title: 'Let AI do the works!',
              subtitle:
                  'Wait for countdown to finish and the result will be automatically stored',
            ),
            // end
          ],
        ),
        Container(
          alignment: const Alignment(0.8, -0.85),
          child: GestureDetector(
            onTap: () {
              controller.indicator.jumpToPage(3);
            },
            child: Text(
              'Skip',
              style: semibold.copyWith(
                  fontSize: 16, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        Obx(() => Container(
              alignment: Alignment(0, controller.page.value == 2 ? 0.88 : 0.85),
              child: controller.page.value != 2
                  ? SmoothPageIndicator(
                      controller: controller.indicator,
                      count: 3,
                      effect: const ScrollingDotsEffect(
                        activeDotColor: purple,
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 8,
                        dotHeight: 8,
                        dotColor: darkGrey,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                      child: Container(
                        height: 55,
                        width: Get.width * 0.8,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Getting Started',
                          style: semibold.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ))
      ],
    ));
  }
}
