import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ordinary/app/models/screen_params.dart';
import 'package:ordinary/app/modules/detector_widget/views/detector_widget_view.dart';
import 'package:ordinary/app/modules/history/views/history_view.dart';
import 'package:ordinary/app/modules/settings/views/settings_view.dart';
// import 'package:ordinary/app/modules/home/views/home_view.dart';
// import 'package:ordinary/app/modules/placeholder/views/placeholder_view.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: <Widget>[
            // HomeView(bottomPadding: bottomPadding),
            const DetectorWidget(),
            HistoryView(),
            SettingsView()
          ][controller.currentIndex.value],
        ),
      ),
      // body: <Widget>[
      //   HomeView(bottomPadding: bottomPadding),
      //   const HistoryView()
      // ][controller.currentIndex.value],
      // bottomNavigationBar: Obx(
      //   () => BottomNavigationBar(
      //     selectedIconTheme:
      //         IconThemeData(color: Theme.of(context).colorScheme.primary),
      //     unselectedIconTheme:
      //         IconThemeData(color: Theme.of(context).colorScheme.secondary),
      //     selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      //     landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      //     type: BottomNavigationBarType.fixed,
      //     onTap: (index) => controller.setPage(index),
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: Icon(controller.currentIndex.value == 0
      //               ? Icons.home
      //               : Icons.home_outlined),
      //           label: "Home"),
      //       BottomNavigationBarItem(
      //           icon: Icon(controller.currentIndex.value == 1
      //               ? Icons.history
      //               : Icons.history_outlined),
      //           label: "History"),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (int index) {
            controller.setPage(index);
          },
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          selectedIndex: controller.currentIndex.value,
          destinations: <Widget>[
            NavigationDestination(
                selectedIcon: Icon(Icons.home,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                icon: const Icon(Icons.home_outlined),
                label: "Home"),
            NavigationDestination(
                selectedIcon: Icon(Icons.history,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                icon: const Icon(
                  Icons.history_outlined,
                ),
                label: "History"),
            NavigationDestination(
                selectedIcon: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
                icon: const Icon(
                  Icons.settings_outlined,
                ),
                label: "Settings")
          ],
        ),
      ),
    );
  }
}
