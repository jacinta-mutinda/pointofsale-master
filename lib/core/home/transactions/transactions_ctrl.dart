import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/transactions/expense_main.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionCtrl extends GetxController {
  String? branchId;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  Expense singleExpense = Expense(
      id: '',
      date: '',
      payto: '',
      ref: '',
      desc: '',
      amount: '',
      branch_id: '');

  RxList<Expense> expenses = RxList<Expense>();
  RxList<Expense> rangeExpList = RxList<Expense>();

  @override
  void onInit() {
    super.onInit();
    setBranchId();
    getExpesnses();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }

  // ---------- Get Functions -----------------

  getExpesnses() async {
    clearLists();
    try {
      final response = await http.get(Uri.parse('$getExpensesUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Expense exp = Expense(
            id: item['pay_id'].toString(),
            payto: item['pay_to'].toString(),
            desc: item['pay_description'].toString(),
            date: item['pay_date'].toString(),
            ref: item['pay_ref'].toString(),
            amount: item['pay_amount'].toString(),
            branch_id: branchId!,
          );
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
    print(TimeOfDay.now());
    var body = jsonEncode({
      'pay_to': expData.payto,
      'pay_description': expData.desc,
      'pay_amount': expData.amount,
      'pay_date': expData.date,
      "pay_time": '17:34:12.593000',
      'pay_ref': expData.ref,
      'branch_id': branchId
    });
    try {
      var res = await http.post(Uri.parse(addExpenseUrl),
          body: body, headers: headers);

      if (res.statusCode == 200) {
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
