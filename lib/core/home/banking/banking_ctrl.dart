import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/banking/banking_transactions.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankingCtrl extends GetxController {
  String? branchId;
  RxString transTypeDropdown = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxBool showTransData = false.obs;
  RxBool showTransLoading = true.obs;
  RxBool fieldsRequired = false.obs;
  RxBool isBankEdit = false.obs;
  BankAccount accToShow = BankAccount(
      id: '', bankName: '', accno: '', branchName: '', cpperson: '',running_bal: '');
  BankTransaction singleTrans = BankTransaction(
      id: '',
      refCode: '',
      bankId: '',
      action: '',
      desc: '',
      branchId: '',
      amount: '');

  List<String> bankAccStrs = [];
  List<String> accActionStrs = ['', 'Withdraw', 'Deposit'];
  RxList<BankAccount> bankAccounts = RxList<BankAccount>();
  RxList<BankAccount> rangeAccList = RxList<BankAccount>();
  RxList<BankTransaction> accBankTrans = RxList<BankTransaction>();
  RxList<BankTransaction> rangeBankTrans = RxList<BankTransaction>();

  @override
  void onInit() {
    super.onInit();
    setBranchId();
    getBanks();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }

  // ---------- Get Functions -----------------

  getBanks() async {
    clearLists();
    try {
      final response = await http.get(Uri.parse('$getBankAccsUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          BankAccount bankAcc = BankAccount(
              id: item['bank_id'].toString(),
              bankName: item['bank_name'],
              accno: item['bank_acc_no'],
              branchName: item['account_details'],
              cpperson: item['account_manager'],
              running_bal: item['bank_running_bal'],);
          bankAccounts.add(bankAcc);
          bankAccStrs.add(item['bank_name']);
          if (!bankAccStrs.contains(item['bank_name'])) {
            bankAccStrs.add(item['bank_name']);
          }
        }
        bankAccStrs.add('');
        filterPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load bank accounts!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getBankTransactions() async {
    clearAccTransLists();
    var body = jsonEncode({
      'bank_id': accToShow.id,
    });
    try {
      final response = await http.post(Uri.parse(getBankTransUrl),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        if (resData is List<dynamic>) {
          for (var item in resData) {
            BankTransaction trans = BankTransaction(
                id: item['transaction_id'].toString(),
                refCode: item['trans_ref'].toString(),
                bankId: accToShow.id,
                action: item['transtype'].toString(),
                desc: item['trans_comment'].toString(),
                branchId: item['branch_id'].toString(),
                amount: item['trans_amount'].toString());
            accBankTrans.add(trans);
            filterTransPaginator();
            update();
            return;
          }
        } else {
          accBankTrans.clear();
          filterTransPaginator();
          update();
          return;
        }
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load transctions!",
          subtitle: "Please check your internet connection or try again later");
      showTransLoading.value = false;
    }
  }

  // ---------- Add Functions -----------------

  addBankAcc(BankAccount bankAccData) async {
    var body = jsonEncode({
      'bank_name': bankAccData.bankName,
      'bank_acc_no': bankAccData.accno,
      'account_details': bankAccData.branchName,
      'account_manager': bankAccData.cpperson,
      'branch_id': branchId
    });
    try {
      var res =
          await http.post(Uri.parse(addBankAccUrl), body: body, headers: {});
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Bank Account Added!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getBanks();
        Get.off(() => const BankingPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Bank Account!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addBankTrans(BankTransaction bankTransData) async {
    var body = jsonEncode({
      "bank_id": accToShow.id,
      "transtype": transTypeDropdown.value,
      "transaction_amount": bankTransData.amount,
      "branch_id": branchId,
      "created_by": "",
      "transaction_comment": bankTransData.desc,
      "transaction_ref": bankTransData.refCode,
      "till_id": "89727303-30A6-4E20-A6FB-F72566DA070B",
      "shift_id": "097b6779-fb9b-4c0e-ad6d-5924ac19c3e0"
    });
    try {
      var res = await http.post(Uri.parse(addBankTransUrl),
          body: body, headers: headers);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Bank Transaction Added!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const BankTransPage());

        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Bank Transaction!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Edit Functions -----------------

  editBankAcc(BankAccount bankAccData) async {
    var body = {
      'bank_id': accToShow.id,
      'bank_name': bankAccData.bankName,
      'bank_acc_no': bankAccData.accno,
      'account_details': bankAccData.branchName,
      'account_manager': bankAccData.cpperson,
      'branch_id': branchId
    };
    try {
      var res = await http.patch(
        Uri.parse(updateBankUrl),
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      debugPrint("Got response ${res.body}");
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Bank Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getBanks();
        Get.off(() => const BankingPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update bank!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Utility Functions -----------------

  filterPaginator() {
    listPaginator(rangeList: rangeAccList, selectList: bankAccounts);
    if (rangeAccList.isEmpty) {
      showLoading.value = false;
      showData.value = false;
    } else {
      showLoading.value = false;
      showData.value = true;
    }
  }

  filterTransPaginator() {
    listPaginator(rangeList: rangeBankTrans, selectList: accBankTrans);
    if (rangeBankTrans.isEmpty) {
      showTransLoading.value = false;
      showTransData.value = false;
    } else {
      showTransLoading.value = false;
      showTransData.value = true;
    }
  }

  searchFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<BankAccount> searchResult = RxList<BankAccount>();

    for (var acc in bankAccounts) {
      List<String> custValue = searchParser(acc.bankName);
      for (var value in searchList) {
        if (searchResult.contains(acc) == false) {
          if (custValue.contains(value)) {
            searchResult.add(acc);
          }
        }
      }
    }

    clearLists();
    rangeAccList = searchResult;
    filterPaginator();
    update();
  }

  clearLists() {
    rangeAccList.clear();
    bankAccounts.clear();
    bankAccStrs.clear();
  }

  clearAccTransLists() {
    rangeBankTrans.clear();
    accBankTrans.clear();
  }
}
