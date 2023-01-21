import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/transactions/expense_main.dart';
import 'package:nawiri/core/home/transactions/transactions.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';

class TransactionCtrl extends GetxController {
  RxString branchId = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxString modeDropDown = ''.obs;
  RxBool isTransEdit = false.obs;
  RxInt transToEdit = 1.obs;

  List<String> expModeStr = ['', 'Bank Account', 'Cash', 'M-pesa'];
  RxList<Expense> expenses = RxList<Expense>();
  RxList<Expense> rangeExpList = RxList<Expense>();

  @override
  void onInit() {
    super.onInit();
    getExpesnses();
  }

  // ---------- Get Functions -----------------

  getExpesnses() async {
    clearLists();
    // get branchId from functions.dart
    try {
      branchId.value = '122';
      final response = await http.get(
          Uri.parse('$getExpensesUrl/${branchId.value}'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Expense exp = Expense(
              id: item[''],
              mode: item[''],
              desc: item[''],
              type: item[''],
              amount: item['']);
          expenses.add(exp);
        }
        filterPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load expenses!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Add Functions -----------------

  addExpense(Expense expData) async {
    var body = jsonEncode({
      '': expData.id,
      '': expData.mode,
      '': expData.desc,
      '': expData.amount,
      '': expData.type
    });
    try {
      var res = await http.post(Uri.parse(addSupplierUrl),
          body: body, headers: headers);
      print(res.body);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Expense Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getExpesnses();
        Get.off(() => const ExpensesPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Expense!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Utility Functions -----------------

  filterPaginator() {
    listPaginator(rangeList: rangeExpList, selectList: expenses);
    if (rangeExpList.isEmpty) {
      showLoading.value = false;
      showData.value = false;
    } else {
      showLoading.value = false;
      showData.value = true;
    }
  }

  searchFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<Expense> searchResult = RxList<Expense>();

    for (var exp in expenses) {
      List<String> expValue = searchParser(exp.desc);
      for (var value in searchList) {
        if (searchResult.contains(exp) == false) {
          if (expValue.contains(value)) {
            searchResult.add(exp);
          }
        }
      }
    }

    clearLists();
    rangeExpList = searchResult;
    filterPaginator();
    update();
  }

  clearLists() {
    rangeExpList.clear();
    expenses.clear();
  }
}
