import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/drawer/drawer_models.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';

class DrawerCtrl extends GetxController {
  RxString shiftId = ''.obs;

  ShiftSale saleRow =
      ShiftSale(id: '', cashAmt: '', mpesaAmt: '', cardAmt: '', total: '0'.obs);
  ShiftFloat floatRow = ShiftFloat(
       payRef: '', 
              payDate: '', 
              payAmount: '',
               cashAmount: '', 
               mobileAmount: '',
               payDescription: '',);

  @override
  void onInit() {
    super.onInit();
    getShiftId();
    getShiftSales();
    getShiftFloats();
  }

  getShiftId() {
    shiftId.value = '097b6779-fb9b-4c0e-ad6d-5924ac19c3e0';
  }

  getShiftSales() async {
    saleRow = ShiftSale(
        id: '', cashAmt: '', mpesaAmt: '', cardAmt: '', total: '0'.obs);
    var body = jsonEncode({
      'shift_id': shiftId.value,
    });
    try {
      final response = await http.post(Uri.parse(getShiftSalesUrl),
          body: body, headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        if (resData is List<dynamic>) {
          for (var item in resData) {
            saleRow.id = item['id'];
            saleRow.cashAmt = item['cash'];
            saleRow.mpesaAmt = item['mpesa'];
            saleRow.cardAmt = item['card'];
            saleRow.total.value = (int.parse(saleRow.cardAmt) +
                    int.parse(saleRow.mpesaAmt) +
                    int.parse(saleRow.cashAmt))
                .toString();
          }
        } else {
          saleRow = ShiftSale(
              id: '', cashAmt: '', mpesaAmt: '', cardAmt: '', total: '0'.obs);
        }
        update();
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load cash drawer sales details!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getShiftFloats() async {
    floatRow = ShiftFloat(
         payRef: '', 
              payDate: '', 
              payAmount: '',
               cashAmount: '', 
               mobileAmount: '',
               payDescription: '',);
    var body = jsonEncode({
      'shift_id': shiftId.value,
    });
    try {
      final response = await http.post(Uri.parse(getShiftSalesUrl),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        if (resData is List<dynamic>) {
          for (var item in resData) {
            floatRow.payRef = item['payRef'];
            floatRow.cashAmount = item['cashAmount'];
            floatRow.mobileAmount = item['mobileAmount'];
            floatRow.payAmount = item['payAmount'];
            // floatRow.total.value = (int.parse(floatRow.payAmount ?? '') +
            //         int.parse(floatRow.mobileAmount?? '') +
            //         int.parse(floatRow.cashAmount?? ''))
            //     .toString();
          }
        } else {
          floatRow = ShiftFloat(
              payRef: '', 
              payDate: '', 
              payAmount: '',
               cashAmount: '', 
               mobileAmount: '',
               payDescription: '',);
        }
        update();
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load cash drawer float details!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
}
