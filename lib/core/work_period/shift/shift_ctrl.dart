import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/work_period.dart';
import 'package:nawiri/core/work_period/wp_models.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ShiftCtrl extends GetxController {
  RxBool shiftStarted = false.obs;
  RxString accDropdown = ''.obs;

  startShift(Shift shiftData) async {
    shiftStarted.value = true;
    var body = jsonEncode({
      'date': shiftData.date,
      'time': shiftData.time,
      'desc': shiftData.desc,
      'float': shiftData.float,
      'dayShift': shiftData.dayShift
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Shift Started!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const WorkPeriodPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to add Product!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

  closeShift(Shift shift) async {
    showSnackbar(
        path: Icons.check_rounded, title: "Shift Closed!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const WorkPeriodPage());
  }
}
