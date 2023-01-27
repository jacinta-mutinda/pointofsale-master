import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/work_period.dart';
import 'package:nawiri/core/work_period/wp_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:http/http.dart' as http;
import '../../../utils/functions.dart';

class ShiftCtrl extends GetxController {
  RxBool shiftStarted = false.obs;
  RxString accDropdown = ''.obs;
  RxString branchId = ''.obs;


  startShift(Shift shiftData) async {
    shiftStarted.value = true;
    branchId.value="122";

    var body = jsonEncode({
      "branch_id": branchId.value,
      'till_float': shiftData.float,
      'shift_day': shiftData.dayShift,
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


    var till ;
    var staff;

    var body = jsonEncode({
      "branch_id": branchId.value,
      'shift_id': shift.dayShift,
      "till_id": till.id,
      "staff_id":staff.id,
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
          path: Icons.check_rounded, title: "Shift Closed!", subtitle: "");
      await Future.delayed(const Duration(seconds: 2));
      Get.off(() => const WorkPeriodPage());
    }
  }
}