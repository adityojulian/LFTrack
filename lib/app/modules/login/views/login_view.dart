import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
          'Welcome',
          style: bold.copyWith(
              fontSize: 60, color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  label: Text(
                    "Enter your email",
                    style: regular.copyWith(color: theme.colorScheme.onSurface),
                  ),
                  // labelStyle: regular,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      Icon(Icons.email, color: theme.colorScheme.primary),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    "Enter your password",
                    style: regular.copyWith(color: theme.colorScheme.onSurface),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      Icon(Icons.lock, color: theme.colorScheme.primary),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  controller.register(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: Text("Sign Up",
                    style: medium.copyWith(color: theme.colorScheme.onPrimary)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: Text("Login",
                    style:
                        medium.copyWith(color: theme.colorScheme.onSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
