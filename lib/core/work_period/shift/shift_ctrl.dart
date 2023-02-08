import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/work_period.dart';
import 'package:nawiri/core/work_period/wp_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShiftCtrl extends GetxController {
  RxBool shiftStarted = false.obs;
  RxString accDropdown = ''.obs;
  String? branchId;
  RxString shiftId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkShiftStarted();
    setBranchId();
  }

  checkShiftStarted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var shift = prefs.getString('shiftId');
    if (shift != null) {
      shiftId.value = shift;
      shiftStarted.value = true;
    } else {
      shiftId.value = 'null';
      shiftStarted.value = false;
    }
    update();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }

  startShift(Shift shiftData) async {
    var body = jsonEncode({
      "branch_id": branchId,
      'till_float': shiftData.float,
      'shift_day': shiftData.dayShift,
      'shift_description': shiftData.desc,
      'shift_complete': shiftData.isComplete,
      "till_id": "",
      "staff_id": "",
    });
    debugPrint(body);
    try {
      var res = await http.post(Uri.parse(createShiftUrl),
          body: body, headers: headers);
      if (res.statusCode == 201) {
        var resData = json.decode(res.body);
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString("shiftId", resData['shift_id']);
        shiftStarted.value = true;
        showSnackbar(
            path: Icons.check_rounded, title: "Shift Started!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const WorkPeriodPage());
      }
      update();
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to start shift!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  closeShift(Shift shift) async {
    var body = {
      "branch_id": branchId,
      'shift_id': shiftId.value,
    };

    try {
      var res = await http.patch(Uri.parse(closeShiftUrl),
          body: body, headers: formHeaders);
      if (res.statusCode == 200) {
        var prefs = await SharedPreferences.getInstance();
        prefs.remove("shiftId");
        shiftStarted.value = true;
        showSnackbar(
            path: Icons.check_rounded, title: "Shift Closed!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const WorkPeriodPage());
      }
      update();
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
