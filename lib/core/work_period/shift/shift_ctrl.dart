import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/work_period.dart';
import 'package:nawiri/core/work_period/wp_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/functions.dart';

class ShiftCtrl extends GetxController {
  RxBool shiftStarted = false.obs;
  RxString accDropdown = ''.obs;
  String? branchId;
  @override
  void onInit() {
    super.onInit();
    setBranchId();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }


  startShift(Shift shiftData) async {
    shiftStarted.value = true;

    var body = jsonEncode({
      "branch_id": branchId,
      'till_float': shiftData.float,
      'shift_day': shiftData.dayShift,
      'shift_description':shiftData.desc,
      "till_id": "",
      "staff_id":"",
    });
    debugPrint(body);
    try {
      var res =
      await http.post(Uri.parse('$createShiftUrl'), body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      if (res.statusCode == 201) {

        showSnackbar(
            path: Icons.check_rounded, title: "Shift Started!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const WorkPeriodPage());

        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Product!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  closeShift(Shift shift) async {
    shiftStarted.value = true;


    var body = jsonEncode({
      "branch_id": branchId,
      'shift_id': '',

    });
    debugPrint(body);
    try {
      var res =
      await http.post(Uri.parse('$closeShiftUrl'), body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      if (res.statusCode == 201) {

        showSnackbar(
            path: Icons.check_rounded, title: "Shift Closed!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const WorkPeriodPage());

        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to Close Shift!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}