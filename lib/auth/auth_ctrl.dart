import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/auth/screens/verify.dart';
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Auth with ChangeNotifier {
  late DateTime _expiryDate = DateTime.now().add(const Duration(days: 100));
  late String _token = "";
  late Map<String, dynamic> _profile = {};
  static final _localAuth = LocalAuthentication();
  int? passcode;

  Auth() {
    debugPrint("#################");
    debugPrint("##### AUTH ######");
    debugPrint("#################");

    getStorageToken();
  }

  get authHeaders {
    return {"Content-Type": "application/json"};
  }

  get headers {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token"
    };
  }

  // ----------------------------- SIGN IN -------------------------------------

  getPasscode() async {
    var prefs = await SharedPreferences.getInstance();
    var pass = prefs.getInt('passcode');
    if (pass != null) {
      passcode = pass;
    }
  }

  // ----------------- biometrics

  bioAuth() async {
    final isAuthenticated = await authenticate();
    if (isAuthenticated) {
      Get.offAll(() => NavigatorHandler(0));
    }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
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
    } on PlatformException {
      return false;
    }
  }

// ----------------------------- SIGN UP -------------------------------------

  signUp(List userdata) async {
    var body = jsonEncode({
      'bus_name': userdata[0],
      'address': userdata[1],
      'location': userdata[2],
      'bus_phone': userdata[3],
      'till_no': userdata[4],
      'rec_footer': userdata[5],
      'username': userdata[6],
      'pers_email': userdata[7],
      'pers_phone': userdata[8],
      'pin': userdata[9]
    });
    debugPrint(body);
    storePasscode(userdata[9]);
    // try {
    //   var res =
    //       await http.post(Uri.parse(signUpUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {
    //     var token = json.decode(res.body)["token"]["access_token"];
    //     _token = token;
    //     await setTokenInfo(json.decode(res.body)["token"]);

    //     var profile = json.decode(res.body)["profile"];
    //     setProfile(profile);
    //     notifyListeners();
    debugPrint('Data posted');
    showSnackbar(
        path: Icons.check_rounded,
        title: "Nawiri Account Created!",
        subtitle: "Kindly verify your account in the next step");
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(() => const VerifyAccount());
    //     return;
    //   } else {
    //     showSnackbar(
    //         path: Icons.close_rounded,
    //         title: "Failed Sign Up!",
    //         subtitle: "Looks like the user email already exists!");
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed Sign Up!",
    //       subtitle: "Please check your internet connection or try again later");
    // }

    // notifyListeners();
  }

  Future<void> storePasscode(String passCode) async {
    var prefs = await SharedPreferences.getInstance();
    var fullPin = '01$passCode';
    await prefs.setInt("passcode", int.parse(fullPin));
  }

  // ----------------------------- UPDATE USER -------------------------------------

  updateUser(String gender, String dob) async {
    var body = jsonEncode({'gender': gender, 'dob': dob});
    debugPrint(body);
    var prefs = await SharedPreferences.getInstance();
    var token = json.decode(prefs.getString("token")!);
    _token = token['access_token'];

    try {
      var res = await http.patch(Uri.parse(updateUserUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var profile = json.decode(res.body);
        setProfile(profile);
        notifyListeners();
        debugPrint('Data posted');
        showSnackbar(
            path: Icons.check_rounded,
            title: "Details successfully added!",
            subtitle: "Just one more step");
        await Future.delayed(const Duration(seconds: 2));
        // Get.offAll(() => const SetLockScreen(
        //       firstSet: true,
        //     ));
        return;
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Update Failed",
            subtitle: "Please try again later!");
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Details not updated!",
          subtitle: "Please check your internet connection or try again later");
    }

    notifyListeners();
  }

  // ----------------------------- VERIFY ACCOUNT -------------------------------------

  verifyAccount(int otp) async {
    var body = json.encode({"verify_code": otp});
    debugPrint(body);
    // try {
    //   var res = await http.post(Uri.parse(resetPassUrl),
    //       body: body, headers: authHeaders);

    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 200) {
    showSnackbar(
        path: Icons.check_rounded,
        title: "Account Verified",
        subtitle: "Karibu Nawiri!");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => NavigatorHandler(0));
    //   } else {
    //     showSnackbar(
    //         path: Icons.close_rounded,
    //         title: "Invalid Reset Code",
    //         subtitle: "Please enter the reset code sent to your email");
    //   }
    //   return res;
    // } catch (error) {
    //   debugPrint('$error');
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to reset password",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

// ----------------------------- TOKENS -------------------------------------
  Future<void> setTokenInfo(info) async {
    debugPrint('$info');
    if (info == null) {
      return;
    }
    _token = info["access_token"];
    _expiryDate = DateTime.now().add(Duration(seconds: info['expires_in']));
    return await storeTokenInfo(info);
  }

  Future<void> storeTokenInfo(info) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", json.encode(info));
  }

  String getToken() {
    if (_expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return _token;
  }

  Future<bool> getStorageToken() async {
    var prefs = await SharedPreferences.getInstance();
    bool foundToken = false;
    if (prefs.containsKey("token")) {
      var token = json.decode(prefs.getString("token")!);
      _token = token['access_token'];
      setTokenInfo(token);
      if (prefs.containsKey("profile")) {
        _profile = json.decode(prefs.getString("profile")!);
      } else {
        debugPrint("No profile found.");
      }
      foundToken = true;
    } else {
      debugPrint("No token found.");
    }
    return foundToken;
  }

// ----------------------------- PROFILE -------------------------------------

  void setProfile(profile) async {
    _profile = profile;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile", json.encode(profile));
    debugPrint('$profile');
  }

  Future<http.Response> getProfile() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token"
    };
    return http.get(Uri.parse(profileUrl), headers: headers);
  }

  void updateProfile() async {
    debugPrint("getting the profile");
    var profileResp = await getProfile();

    if (profileResp.statusCode == 200) {
      var profile = json.decode(profileResp.body);
      debugPrint('$profile');
      setProfile(profile);
    }
  }

  void doGetProfile() async {
    var profileResp = await getProfile();
    if (profileResp.statusCode == 200) {
      var profile = json.decode(profileResp.body);
      setProfile(profile);
      debugPrint("Setting profile Complete :)");
    }
  }

// ----------------------------- SIGN OUT -------------------------------------
  Future<bool> logout() async {
    debugPrint("Logging out");
    _token = '';
    _expiryDate = DateTime.now();
    _profile = {};
    await clearStorage();
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(const Login());
    return true;
  }

  Future<bool> clearStorage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
