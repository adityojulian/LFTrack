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

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: bold.copyWith(fontSize: 48),
              ),
              TextField(
                controller: emailController,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // this is for the register function in auth controller
                      controller.register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: Text("Sign Up", style: medium),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // this is for the login function in auth controller
                      controller.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    child: Text("Login", style: medium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
