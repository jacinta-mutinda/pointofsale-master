import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/drawer/drawer_models.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';

class ShiftSaleCtrl extends GetxController {
  RxString shiftId = ''.obs;
  ShiftSale saleRow = ShiftSale(
      id: '',
      cashAmt: '0.0',
      mpesaAmt: '0.0',
      cardAmt: '0.0',
      total: '0.0'.obs);


  @override
  void onInit() {
    super.onInit();
    getShiftId();
    getShiftSales();
  }

  getShiftId() {
    shiftId.value = '097b6779-fb9b-4c0e-ad6d-5924ac19c3e0';
  }

  getShiftSales() async {
    saleRow = ShiftSale(
        id: '',
        cashAmt: '0.0',
        mpesaAmt: '0.0',
        cardAmt: '0.0',
        total: '0.0'.obs);
    var body = jsonEncode({
      'shift_id': shiftId.value,
    });
    try {
      final response = await http.post(Uri.parse(getShiftSalesUrl),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        print(resData);
        if (resData is Map) {
          saleRow.id = resData['id'].toString();
          saleRow.cashAmt = resData['cash'].toString();
          saleRow.mpesaAmt = resData['mpesa'].toString();
          saleRow.cardAmt = resData['bank'].toString();
          saleRow.total.value = resData['total'].toString();
        }
      }
      update();
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load cash drawer sales details!",
          subtitle: "Please check your internet connection or try again later");
    }
  }


}
