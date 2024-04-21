import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ordinary/app/models/screen_params.dart';
import 'package:ordinary/app/modules/detector_widget/views/detector_widget_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final double bottomPadding;
  const HomeView({super.key, required this.bottomPadding});
  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      // appBar: AppBar(
      //   title: const Text('HomeView'),
      //   centerTitle: true,
      // ),
      body: DetectorWidget(),
    );
  }
}
