import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/expenses/expenses.dart';
import 'package:nawiri/theme/global_widgets.dart';

class TransactionCtrl extends GetxController {
  RxString modeDropDown = ''.obs;
  RxBool showMenu = false.obs;
  RxBool isTransEdit = false.obs;
  RxInt transToEdit = 1.obs;

  List<String> expModeStr = ['', 'Bank Account', 'Cash', 'M-pesa'];
  RxList<Expense> expenses = RxList<Expense>();

  @override
  void onInit() {
    super.onInit();
    getExpesnses();
  }

  // ---------- Get Functions -----------------

  getExpesnses() {
    expenses.clear();
    expenses.value = [
      Expense(
          id: 1,
          mode: 'M-pesa',
          desc: 'Lorem ipsum dolor',
          amount: 10000,
          type: 'Rent'),
      Expense(
          id: 2,
          mode: 'Bank Account',
          desc: 'Lorem ipsum dolor',
          amount: 7000,
          type: 'Electrictity'),
      Expense(
          id: 3,
          mode: 'Cash',
          desc: 'Lorem ipsum dolor',
          amount: 400,
          type: 'Water'),
      Expense(
          id: 4,
          mode: 'M-pesa',
          desc: 'Lorem ipsum dolor',
          amount: 250,
          type: 'Food'),
      Expense(
          id: 5,
          mode: 'Cash',
          desc: 'Lorem ipsum dolor',
          amount: 20000,
          type: 'Transport'),
    ];
  }

  // ---------- Add Functions -----------------

  addExpense(Expense expData) async {
    var body = jsonEncode({
      'type': expData.type,
      'desc': expData.desc,
      'mode': expData.mode,
      'amount': expData.amount,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Expense Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const TransactionsPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to add Category!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

  // ---------- Edit Functions -----------------

  editExpense(Expense expData) async {
    var body = jsonEncode({
      'type': expData.type,
      'desc': expData.desc,
      'mode': expData.mode,
      'amount': expData.amount,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.patch(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Expense Updated!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const TransactionsPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to update category!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }
}
