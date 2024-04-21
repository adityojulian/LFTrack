import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  void showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Confirm Logout',
          style: bold,
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: regular,
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: medium,
            ),
            onPressed: () {
              Get.back(); // Close the dialog
            },
          ),
          TextButton(
            child: Text(
              'Logout',
              style: medium,
            ),
            onPressed: () {
              Get.back(); // Close the dialog
              controller
                  .signOut(); // Call the logout function after confirmation
            },
          ),
        ],
      ),
      barrierDismissible: false, // User must tap a button to close the dialog
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
          'Settings',
          style: bold.copyWith(
              fontSize: 70, color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          ListTile(
            leading:
                Icon(Icons.email, color: Theme.of(context).iconTheme.color),
            title: Text(
              'Account Email',
              style: medium,
            ),
            subtitle:
                Text(controller.email!), // Placeholder or fetch real email
          ),
          ListTile(
            leading: Icon(Icons.light_mode,
                color: Theme.of(context).iconTheme.color),
            title: Text('Dark Mode', style: medium),
            trailing: Obx(() => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (value) => controller.switchTheme(),
                )),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: Theme.of(context).iconTheme.color),
            title: Text('Logout', style: medium),
            onTap: () => showLogoutConfirmation(),
          ),
        ],
      ),
    );
  }
}
