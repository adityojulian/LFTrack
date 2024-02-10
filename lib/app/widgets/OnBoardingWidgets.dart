import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';

class OnBoardingWidgets extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subtitle;
  const OnBoardingWidgets({this.image, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            // color: Theme.of(context).colorScheme.surface,
            color: Theme.of(context).colorScheme.secondaryContainer,
            height: (Get.height - AppBar().preferredSize.height) * 0.4,
            width: Get.width * 0.7,
            // height: 400,
          )
        ],
      ),
    );
  }
}
