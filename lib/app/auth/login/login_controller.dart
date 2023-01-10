import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nawiri/app/navigator.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCtrl extends GetxController {
  static final _localAuth = LocalAuthentication();
  int? passcode;

  /* ------ secret passcode ------- */

  Future<void> storePasscode(int passCode, bool firstSet) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("passcode", passCode);
    showSnackbar(
        path: Icons.check_rounded,
        title: "New Passcode Saved!",
        subtitle: firstSet
            ? "Your account is now more secure"
            : "Your passcode has been changed");
    await Future.delayed(const Duration(seconds: 2));
    if (firstSet) {
      // Get.offAll(const ImportData(firstImport: true));
    } else {
      Get.off(NavigatorHandler(0));
    }
  }

  getPasscode() async {
    var prefs = await SharedPreferences.getInstance();
    var pass = prefs.getInt('passcode');
    if (pass != null) {
      passcode = pass;
    }
  }

  /* ------ biometrics ------ */

  bioAuth() async {
    final isAuthenticated = await authenticate();
    if (isAuthenticated) {
      Get.offAll(() => NavigatorHandler(0));
    }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate using biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}
