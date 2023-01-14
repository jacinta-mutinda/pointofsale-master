import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/banking/banking_transactions.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';

class BankingCtrl extends GetxController {
  RxString accDropdown = ''.obs;
  RxString transTypeDropdown = ''.obs;
  RxBool showMenu = false.obs;
  RxBool isBankEdit = false.obs;
  RxInt bankToEdit = 1.obs;
  RxBool isTransEdit = false.obs;
  RxInt transToEdit = 1.obs;
  RxInt transToShow = 1.obs;
  RxString bankPageName = ''.obs;
  List<String> bankAccStrs = [];
  List<String> accActionStrs = ['', 'Withdraw', 'Deposit'];
  BankAccount transAccToShow = BankAccount(
      id: 1,
      bankName: '',
      accno: 1,
      branchName: '',
      cpperson: 1,
      currentTotal: 1);
  RxList<BankAccount> bankAccounts = RxList<BankAccount>();
  RxList<BankTransaction> allBankTrans = RxList<BankTransaction>();
  RxList<BankTransaction> accBankTrans = RxList<BankTransaction>();

  @override
  void onInit() {
    super.onInit();
    getBanks();
    getBankTransactions();
  }

  // ---------- Get Functions -----------------

  getBanks() {
    bankAccounts.clear();
    bankAccounts.value = [
      BankAccount(
          id: 1,
          bankName: 'Equity Bank',
          accno: 1244411231,
          branchName: 'Kimathi Street',
          cpperson: 0712345678,
          currentTotal: 50000),
      BankAccount(
          id: 2,
          bankName: 'KCB',
          accno: 1244411231,
          branchName: 'Ronald Ngara',
          cpperson: 0712345678,
          currentTotal: 10560),
      BankAccount(
          id: 3,
          bankName: 'Stanbic Bank',
          accno: 1244411231,
          branchName: 'Kimathi Street',
          cpperson: 0712345678,
          currentTotal: 5600),
    ];
    bankAccStrs.add('');
    for (final acc in bankAccounts) {
      bankAccStrs.add(acc.bankName);
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

  getAccBankTrans() {
    bankPageName.value = '';
    accBankTrans.clear();
    for (final trans in allBankTrans) {
      if (trans.bankId == transToShow.value) {
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
      'bankName': bankAccData.bankName,
      'accno': bankAccData.accno,
      'branchName': bankAccData.branchName,
      'cpperson': bankAccData.cpperson,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Bank Account Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const BankingPage());

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

  addBankTrans(BankTransaction bankTransData) async {
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
        title: "Bank Transaction Added!",
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
    //       title: "Failed to add Product!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

  // ---------- Edit Functions -----------------

  editBankAcc(BankAccount bankAccData) async {
    var body = jsonEncode({
      'bankName': bankAccData.bankName,
      'accno': bankAccData.accno,
      'branchName': bankAccData.branchName,
      'cpperson': bankAccData.cpperson,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.patch(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded,
        title: "Bank Account Updated!",
        subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const BankingPage());

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
}
