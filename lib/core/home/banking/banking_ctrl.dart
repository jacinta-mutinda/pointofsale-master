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

class BankingCtrl extends GetxController {
  RxString branchId = ''.obs;
  RxString accDropdown = ''.obs;
  RxString transTypeDropdown = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxBool showTransData = false.obs;
  RxBool showTransLoading = true.obs;
  RxBool fieldsRequired = false.obs;
  RxBool isBankEdit = false.obs;
  RxString bankToEdit = ''.obs;
  RxBool isTransEdit = false.obs;
  RxInt transToEdit = 1.obs;
  RxString transToShow = ''.obs;
  RxString bankPageName = ''.obs;
  List<String> bankAccStrs = [];
  List<String> accActionStrs = ['', 'Withdraw', 'Deposit'];
  BankAccount transAccToShow = BankAccount(
      id: '', bankName: '', accno: '', branchName: '', cpperson: '');
  RxList<BankAccount> bankAccounts = RxList<BankAccount>();
  RxList<BankAccount> rangeAccList = RxList<BankAccount>();
  RxList<BankTransaction> allBankTrans = RxList<BankTransaction>();
  RxList<BankTransaction> accBankTrans = RxList<BankTransaction>();
  RxList<BankTransaction> rangeBankTrans = RxList<BankTransaction>();



  @override
  void onInit() {
    super.onInit();
    getBanks();
    getBankTransactions();
  }

  // ---------- Get Functions -----------------

  getBanks() async {
    clearLists();
    // get branchId from functions.dart
    try {
      branchId.value = '122';
      final response = await http.get(
          Uri.parse('$getBankAccsUrl/${branchId.value}'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          BankAccount bankAcc = BankAccount(
              id: item['bank_id'].toString(),
              bankName: item['bank_name'],
              accno: item['bank_acc_no'],
              branchName: item['account_details'],
              cpperson: item['account_manager']);
          bankAccounts.add(bankAcc);
          bankAccStrs.add(item['bank_name']);
          if (!bankAccStrs.contains(item['bank_name'])) {
            bankAccStrs.add(item['bank_name']);
          }
        }
        bankAccStrs.add(accDropdown.value);
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

  getBankTransactions() {
    allBankTrans.value = [
      BankTransaction(
          id: 1,
          bankId: 1,
          action: 'Withdraw',
          desc: 'For rent',
          amount: 20000,
          date: '2023-01-14'),
      BankTransaction(
          id: 2,
          bankId: 1,
          action: 'Deposit',
          desc: 'For clothes supplier',
          amount: 5000,
          date: '2023-01-14'),
      BankTransaction(
          id: 3,
          bankId: 2,
          action: 'Deposit',
          desc: 'For clothes supplier',
          amount: 5000,
          date: '2023-01-14'),
      BankTransaction(
          id: 4,
          bankId: 3,
          action: 'Withdraw',
          desc: 'For personal use',
          amount: 300,
          date: '2023-01-14'),
    ];
  }
  getCustPayments(String bank_id) async {
    var body = jsonEncode({
      'bank_id': bank_id,
    });
    try {
      branchId.value = '122';

      final response = await http.post(Uri.parse(getCustReceiptsUrl),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {

          BankTransaction rec = BankTransaction(
              id: item['customer_trans_id'],
              bankId: item['customer'],
              action: item['transaction_ref'],
              desc: item['transaction_date'],
              amount: item['transaction_amount'],
              date: item['discount']);
          allBankTrans.add(rec);

        }
        filterTransPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load customers!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getAccBankTrans() {
    bankPageName.value = '';
    accBankTrans.clear();
    for (final trans in allBankTrans) {
      if (trans.bankId.toString() == transToShow.value) {
        accBankTrans.add(trans);
      }
    }
    transAccToShow = bankAccounts
        .where((element) => element.id == (transToShow.value))
        .first;
    bankPageName.value = bankAccounts
        .where((element) => element.id == (transToShow.value))
        .first
        .bankName;
    Get.to(() => const BankTransPage());
    accDropdown.value = bankAccStrs[0];
    transTypeDropdown.value = accActionStrs[0];
  }

  // ---------- Add Functions -----------------

  addBankAcc(BankAccount bankAccData) async {
    var body = jsonEncode({
      'bank_name': bankAccData.bankName,
      'bank_acc_no': bankAccData.accno,
      'account_details': bankAccData.branchName,
      'account_manager': bankAccData.cpperson,
      'branch_id': '122'
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
    var body = jsonEncode(
      {
        "bank_id":bankTransData.bankId,
        "transtype":bankTransData.action,
        "transaction_amount":bankTransData.amount,
        "branch_id":122,
        "created_by":"",
        "transaction_comment":"",
        "transaction_ref":"",
        "till_id": "89727303-30A6-4E20-A6FB-F72566DA070B",
        "shift_id": "097b6779-fb9b-4c0e-ad6d-5924ac19c3e0"
      });
    debugPrint(body);
    try {
      var res =
          await http.post(Uri.parse(addBankAccTransUrl), body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
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
          title: "Failed to add Product!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Edit Functions -----------------

  editBankAcc(BankAccount bankAccData) async {
    print(bankToEdit.value);
    print(bankToEdit.value.trim());
    if (bankToEdit.value == bankToEdit.value.trim()) {
      print('the same');
    }
    var body = jsonEncode({
      'bank_id': bankToEdit.value,
      'bank_name': bankAccData.bankName,
      'bank_acc_no': bankAccData.accno,
      'account_details': bankAccData.branchName,
      'account_manager': bankAccData.cpperson,
      'branch_id': '122',
    });
    try {
      var res = await http.patch(Uri.parse(updateBankUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      // debugPrint(res.body);
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Bank Account Updated!",
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
          title: "Failed to update bank account!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  editBankTrans(BankTransaction bankTransData) async {
    var body = jsonEncode({
      'bankId': bankTransData.bankId,
      'action': bankTransData.action,
      'desc': bankTransData.desc,
      'amounr': bankTransData.amount,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded,
        title: "Bank Transaction Updated!",
        subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const BankTransPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to update Product!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
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
    listPaginator(rangeList: rangeBankTrans, selectList: allBankTrans);
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
  }
}
