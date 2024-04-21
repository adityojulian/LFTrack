import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/routes/app_pages.dart';
// import 'package:ordinary/firebase_constants.dart';

class LoginController extends GetxController {
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  // late TextEditingController emailController;
  // late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    // emailController = TextEditingController();
    // passwordController = TextEditingController();
    // emailController.text = "";
    // passwordController.text = "";
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setInitialScreen);

    // emailController.text = "";
    // passwordController.text = "";
  }

  _setInitialScreen(User? user) {
    if (user != null) {
      Get.offAllNamed(
        Routes.BOTTOM_NAV_BAR,
      );
    } else {
      Future.delayed(const Duration(seconds: 2), (() {
        Get.offAllNamed(Routes.ONBOARDING);
      }));
    }
  }

  void register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // print(e.message);
      Get.snackbar(
        "Sign-up Failed",
        "Failed to sign up: ${e.message.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // this is temporary. you can handle different kinds of activities
      //such as dialogue to indicate what's wrong
      print(e.toString());
    }
  }

  void login(String email, String password) async {
    log("em ${email} pass ${password}");
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        "Failed to login: ${e.message.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() {
    try {
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onClose() {
    // emailController.text = "";
    // passwordController.text = "";
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
