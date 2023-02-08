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
  ShiftSale saleRow = ShiftSale(
      id: '',
      cashAmt: '0.0',
      mpesaAmt: '0.0',
      cardAmt: '0.0',
      total: '0.0'.obs);
  ShiftFloat floatRow = ShiftFloat(
    payRef: '',
    payTo: '',
    payAmount: '',
    cashAmount: '',
    mobileAmount: '',
    payDescription: ''.obs
  );
  Shiftexpense expenseRow = Shiftexpense(
    payRef: '',
    payTo: '',
    payAmount: '',
    cashAmount: '',
    mobileAmount: '',
    payDescription: ''.obs);
  

  @override
  void onInit() {
    super.onInit();
    getShiftId();
    getShiftSales();
    getShiftFloats();
    getShiftExpenses();
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

  getShiftFloats() async {
    floatRow = ShiftFloat(
      payRef: '',
      payTo: '',
      payAmount: '0.0',
      cashAmount: '0.0',
      mobileAmount: '0.0',
      payDescription: ''.obs
    );
    var body = jsonEncode({
      'shift_id': 153,
    });
    try {
      final response =
          await http.post(Uri.parse(getShiftFloatUrl), body: body, headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        print(resData);
        if (resData is Map) {
          floatRow.payRef = resData['pay_ref'].toString();
          floatRow.payTo = resData['pay_to'];
          floatRow.cashAmount = resData['cash_amount'].toString();
          floatRow.mobileAmount = resData['mobile_amount'].toString();
          floatRow.payAmount = resData['pay_amount'].toString();
          floatRow.payDescription.value = resData['pay_description'].toString();
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

 getShiftExpenses() async {
    var expenseRow = Shiftexpense(
        payRef: '',
    payTo: '',
    payAmount: '',
    cashAmount: '',
    mobileAmount: '',
    payDescription: ''.obs);
 
    var body = jsonEncode({
      'shift_id': 654,
    });
    try {
      final response = await http.get(Uri.parse(getShiftExpensesUrl),
           headers: headers);
           print(response.body);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
       print(resData);
        if (resData is Map) {
          expenseRow.payRef = resData['pay_ref'];
          expenseRow.cashAmount = resData['cash_amount'].toString();
          expenseRow.mobileAmount = resData['mobile_amount'].toString();
          expenseRow.payAmount = resData['pay_amount'].toString();
          
        }}
        
      // update();
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load cash drawer expenses details!",
          subtitle: "Please check your internet connection or try again later");
    }
  }
  
  
  
  