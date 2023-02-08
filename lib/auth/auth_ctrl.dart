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




  RxList<User> userList = RxList<User>();
  String companyPhone = '';
  @override

  get headers {
    return {"Content-Type": "application/json"};
  }


  // ----------------------------- SIGN IN -------------------------------------

  login(String loginpin) async {
    var prefs = await SharedPreferences.getInstance();
    var branchId = '669892';
    await storeBranchId(branchId);
    // var branchId = prefs.getString('branchId');

    print(branchId);
    var body = jsonEncode({'branch_id': branchId, 'password': loginpin});
    try {
      var res =
      await http.post(Uri.parse(loginUrl), body: body, headers: headers);

      if (res.statusCode == 201) {
        var resData = json.decode(res.body);
        storeDataInSharedPreferences(resData);
        showSnackbar(
            path: Icons.check_rounded,
            title: "Successful Login!",
            subtitle: "Welcome Back");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => NavigatorHandler(0));
        // Get.off(() => WelcomePrompt());
        // Get.off(() => VerifyAccount());

        return;
      } else if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Login error",
            subtitle: "Please enter the correct branch and pin code");
      }
      return 0;
    } catch (error) {
      debugPrint("$error");
    }
  }

  Future<void> storeBranchId(String branchId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("branchId", branchId);
  }

  Future<void> storeFooter(String footer) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("footer", footer);
  }

  Future<void> storeTill(String till) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("till", till);
  }

  Future<void> storeCompanyId(String companyId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("companyId", companyId);
  }

  Future<void> storeCompanyName(String companyName) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("companyName", companyName);
  }

  Future<void> storeCompanyPhone(String companyPhone) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("companyPhone", companyPhone);
  }
  Future<void> storeCompanyEmail(String companyEmail) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("companyEmail", companyEmail);
  }
  Future<void> storeDataInSharedPreferences(Map<String, dynamic> data) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final dataJson = jsonEncode(data);
    await sharedPreferences.setString('user', dataJson);
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

    storeCompanyName(userdata[0]);
    storeCompanyPhone(userdata[3]);
    storeCompanyEmail(userdata[1]);

    try {
      var res = await http.post(Uri.parse(addCompanyUrl),
          body: body, headers: headers);
      print(res.body);
      if (res.statusCode == 201) {
        Map<String, dynamic> resBody = json.decode(res.body);
        await storeBranchId(resBody['branch_id'].toString());
        await storeFooter(userdata[5].toString());
        await storeTill(userdata[4].toString());
        showSnackbar(
            path: Icons.check_rounded,
            title: "Routing to user details",
            subtitle: "");
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
    var till = prefs.getString('till');
    var footer = prefs.getString('footer');
    companyPhone = prefs.getString('companyPhone').toString();


    var body = jsonEncode({
      'user_name': userdata[0],
      'staff_id': userdata[3],
      'user_lif': userdata[2],
      'user_pin': userdata[3],
      'referal_code':userdata[4],
      'branch_id': int.parse(branchId!),
      'till': till,
      'footer': footer
    });
    try {
      var res =
      await http.post(Uri.parse(signUpUrl), body: body, headers: headers);
      print(res.body);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Nawiri Account Created!",
            subtitle: "Kindly verify your account in the next step " +
                branchId);
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
    var prefs = await SharedPreferences.getInstance();
    var correctotp = prefs.getString('otp');
    print(correctotp);
    var body = json.encode({"verify_code": otp});
    if(otp==int.parse(correctotp!)){
      showSnackbar(
          path: Icons.check_rounded,
          title: "Account Verified",
          subtitle: "Karibu Nawiri!");
      await Future.delayed(const Duration(seconds: 2));
      // Get.off(() => NavigatorHandler(0));
      Get.offAll(const Login());
      Get.dialog(const WelcomePrompt());

    }
    else{
      showSnackbar(
          path: Icons.check_rounded,
          title: "Verification failed",
          subtitle: "The code is incorrect!");
    }
    // try {
    //   var res = await http.post(Uri.parse(resetPassUrl),
    //       body: body, headers: authHeaders);
    //   if (res.statusCode == 200) {

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

  getCompanyPhone() async {
    var prefs = await SharedPreferences.getInstance();
    var companyPhone = prefs.getString('companyPhone').toString();
    String modifiedNumber = "254" + companyPhone.substring(1);
    print(modifiedNumber);
    return modifiedNumber;

  }
  getCompanyName() async {
    var prefs = await SharedPreferences.getInstance();
    var companyName = prefs.getString('companyName');

    return companyName;

  }
  getCompanyEmail() async {
    var prefs = await SharedPreferences.getInstance();
    var companyEmail = prefs.getString('companyEmail');
    return companyEmail;

  }

  userDetails() async {
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    var userData = json.decode(user!);
    var u=userData['user'];
    var till=userData['till'];
    var company=userData['company'];
    User profile = User(
        id: 2,
        busname: company[0]['company_name'],
        busaddress: company[0]['company_address'],
        location: company[0]['company_town'],
        phone: int.parse(company[0]['company_tel']),
        till: int.parse(till[0]['till_no']),
        recFooter: till[0]['till_receipt_msg1'],
        username: u['user_name'],
        address: u['user_name'],
        phoneno: 0,
        pin: int.parse(u['user_pin']));

    userList.add(profile);
    return ;

  }

}
