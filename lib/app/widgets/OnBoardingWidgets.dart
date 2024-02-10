import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';

class OnBoardingWidgets extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subtitle;
  const OnBoardingWidgets({super.key, this.image, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      child: Column(
        children: [
          Container(
            height: Get.height * 0.65,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${image}'),
                scale: 1.75,
              ),
            ),
          ),
          Container(
            height: Get.height * 0.35,
            width: Get.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${title}',
                  style: bold.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${subtitle}',
                  style: regular.copyWith(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
