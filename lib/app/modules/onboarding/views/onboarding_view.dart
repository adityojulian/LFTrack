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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  controller.indicator.jumpToPage(3);
                },
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: Get.height * 0.7,
              child: PageView(
                controller: controller.indicator,
                onPageChanged: ((value) {
                  controller.page.value = value;
                  // print(controller.page.value);
                }),
                children: const [
                  // start page onboarding
                  OnBoardingWidgets(
                    image: 'on_boarding_1.png',
                    title: 'Track Everything',
                    subtitle:
                        'your financial journey start here. We are\nhere to help ypur tracking and handle every\ntransaction 24/day.',
                  ),
                  OnBoardingWidgets(
                    image: 'on_boarding_2.png',
                    title: 'Fast Transaction',
                    subtitle:
                        'Get easy to pay all yours bills with just a\nfew taps. paying your bill become fast \nand efficient. Enjoy',
                  ),
                  OnBoardingWidgets(
                    image: 'on_boarding_3.png',
                    title: 'Enjoy Everyday!',
                    subtitle:
                        'Be wise, and discover your best financial\nexperience with us. Everything is in\nyour hands!',
                  ),
                  // end
                ],
              ),
            ),
            // const Expanded(
            //   child: SizedBox.shrink(),
            // ),
            // Container(
            //   alignment: Alignment(0.8, -0.85),
            //   child: GestureDetector(
            //     onTap: () {
            //       controller.indicator.jumpToPage(3);
            //     },
            //     child: Text('Skip'),
            //   ),
            // ),
            Obx(() => Container(
                  // alignment: Alignment(0, 0.85),
                  child: controller.page.value != 2
                      ? SmoothPageIndicator(
                          controller: controller.indicator,
                          count: 3,
                          effect: ScrollingDotsEffect(
                            // fixedCenter: true,
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            spacing: 10,
                            radius: 6,
                            dotWidth: 10,
                            dotHeight: 10,
                            dotColor:
                                Theme.of(context).colorScheme.inversePrimary,
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
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
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
