import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/auth/screens/personal_det.dart';
import 'package:nawiri/auth/screens/verify.dart';
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/core/home/home.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCtrl extends GetxController {
  User profile = User(
      id: 1,
      busname: 'Asis Tea Sales',
      busaddress: 'P.O BOX 234 5788',
      location: 'KImathi House',
      phone: 0712345678,
      till: 564534,
      recFooter: 'Thank you for coming',
      username: 'Admin_one',
      address: 'admin@gmail.com',
      phoneno: 0712345678,
      pin: 1234);
  RxList<User> user = RxList<User>();

  get headers {
    return {"Content-Type": "application/json"};
  }

  // ----------------------------- SIGN IN -------------------------------------

  get getBranchId async {
    var prefs = await SharedPreferences.getInstance();
    var branchId = prefs.getString('branchId');
    if (branchId != null) {
      return branchId;
    } else {
      return null;
    }
  }



  login(String branchId, String pin) async{
    debugPrint('login called');
    var body = jsonEncode({
      'branch_id': branchId,
      'password': pin
    });
    try {
      var res = await http.post(Uri.parse(loginUrl),
          body: body, headers: headers);

      if (res.statusCode == 201) {
        var resData = json.decode(res.body);
        storeBranchId(branchId);
        showSnackbar(
            path: Icons.check_rounded,
            title: "Succes!",
            subtitle: "Login Success");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => NavigatorHandler(0));

        return ;
      }
      else if(res.statusCode==200){
        showSnackbar(
            path: Icons.close_rounded,
            title: "Login error",
            subtitle: "Wrong pin code !");
      }
      return 0;
    } catch (error) {
      debugPrint("$error");
    }
  }

  Future<void> storeBranchId(String branchId) async {
    print('storeBranch Called');
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("branchId", branchId);
    print('branchId stored');
    var branch = prefs.getString('branchId');
    print('-----the branch Id is -----');
    print(branch);

  }

// ----------------------------- SIGN UP -------------------------------------

  createCompany(List userdata) async {
    var body = jsonEncode({
      'company_name': userdata[0],
      'company_address': userdata[1],
      'company_town': userdata[2],
      'company_tel': userdata[3],
      'payment_details': userdata[4],
      'logo': userdata[5]
    });
    try {
      var res = await http.post(Uri.parse(addCompanyUrl),
          body: body, headers: headers);
      if (res.statusCode == 201) {
        Map<String, dynamic> resBody = json.decode(res.body);
        await storeBranchId(resBody['branch_id'].toString());
        showSnackbar(
            path: Icons.check_rounded,
            title: "Company Created!",
            subtitle: "Let's create your personal account in the next step");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const PersonalDetails());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to Create Company!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  signUp(List userdata) async {
    var prefs = await SharedPreferences.getInstance();
    var branchId = prefs.getString('branchId');
    var body = jsonEncode({
      'user_name': userdata[0],
      'staff_id': userdata[1],
      'user_lif': userdata[2],
      'user_pin': userdata[3],
      'branch_id': int.parse(branchId!)
    });
    try {
      var res =
          await http.post(Uri.parse(signUpUrl), body: body, headers: headers);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Nawiri Account Created!",
            subtitle: "Kindly verify your account in the next step");
        await Future.delayed(const Duration(seconds: 2));
        Get.offAll(() => const VerifyAccount());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed Sign Up!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ----------------------------- UPDATE USER -------------------------------------

  updateUser(String gender, String dob) async {
    var body = jsonEncode({'gender': gender, 'dob': dob});

    try {
      var res = await http.patch(Uri.parse(''), body: body, headers: headers);
      if (res.statusCode == 200) {
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
      showSnackbar(
          path: Icons.close_rounded,
          title: "Details not updated!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ----------------------------- VERIFY ACCOUNT -------------------------------------

  verifyAccount(int otp) async {
    var body = json.encode({"verify_code": otp});
    // try {
    //   var res = await http.post(Uri.parse(resetPassUrl),
    //       body: body, headers: authHeaders);
    //   if (res.statusCode == 200) {
    showSnackbar(
        path: Icons.check_rounded,
        title: "Account Verified",
        subtitle: "Karibu Nawiri!");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => NavigatorHandler(0));
    Get.dialog(const WelcomePrompt());
    //   } else {
    //     showSnackbar(
    //         path: Icons.close_rounded,
    //         title: "Invalid Reset Code",
    //         subtitle: "Please enter the reset code sent to your email");
    //   }
    //   return res;
    // } catch (error) {
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to reset password",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

// ----------------------------- SIGN OUT -------------------------------------
  Future<bool> logout() async {
    await clearStorage();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(const Login());
    return true;
  }

  Future<bool> clearStorage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
