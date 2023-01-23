import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/suppliers/supplier_payments.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';

class SupplierCtrl extends GetxController {
  RxString transtyeDrop = ''.obs;
  RxString branchId = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxBool showPayData = false.obs;
  RxBool showPayLoading = true.obs;
  RxBool fieldsRequired = false.obs;
  RxBool isSupEdit = false.obs;
  SupplierPayment singleSupPay = SupplierPayment(
      id: '',
      supId: '',
      date: '',
      transtype: '',
      discount: '',
      ref: '',
      comment: '',
      amount: '');
  Supplier supToShow = Supplier(
      id: '',
      name: '',
      item: '',
      bankacc: '',
      krapin: '',
      address: '',
      cpperson: '',
      phoneno: '');

  List<String> transtypes = ['', 'Cash', 'M-pesa', 'Bank'];
  RxList<Supplier> suppliers = RxList<Supplier>();
  RxList<Supplier> rangeSupList = RxList<Supplier>();
  RxList<SupplierPayment> supPayments = RxList<SupplierPayment>();
  RxList<SupplierPayment> ranegSupPayments = RxList<SupplierPayment>();

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
  }

  // ---------- Get Functions -----------------

  getSuppliers() async {
    clearLists();
    // get branchId from functions.dart
    try {
      branchId.value = '122';
      final response = await http.get(
          Uri.parse('$getSupplierUrl/${branchId.value}'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Supplier sup = Supplier(
              id: item['Supplier_id'],
              name: item['supplier_name'],
              item: item['supplier_item'],
              bankacc: item['supplier_bank_acc'],
              krapin: item['supplier_pin'],
              address: item['supplier_address'],
              cpperson: item['supplier_contact_person'],
              phoneno: item['supplier_phone_no']);
          suppliers.add(sup);
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
          title: "Failed to load suppliers!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getSupPayments() async {
    clearPayLists();
    // get branchId from functions.dart
    try {
      branchId.value = '122';
      final response = await http.get(
          Uri.parse('$getSupPayUrl/${branchId.value}'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          if (item['supPay'] == supToShow.id) {
            SupplierPayment supPay = SupplierPayment(
                id: item['receipt_id'],
                supId: item['supplier'],
                ref: item['transaction_ref'],
                date: item['date'],
                amount: item['transaction_amount'],
                discount: item['discount'],
                transtype: item['trans_type'],
                comment: item['transaction_comment']);
            supPayments.add(supPay);
          }
        }
        filterSupPayPaginator();
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

  // ---------- Add Functions -----------------

  addSupplier(Supplier supData) async {
    var body = jsonEncode({
      'supplier_name': supData.name,
      'supplier_item': supData.item,
      'supplier_bank_acc': supData.bankacc,
      'supplier_pin': supData.krapin,
      'supplier_address': supData.address,
      'supplier_phone_no': supData.cpperson,
      'supplier_contact_person': supData.cpperson,
    });
    try {
      var res = await http.post(Uri.parse(addSupplierUrl),
          body: body, headers: headers);
      print(res.body);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Supplier Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getSuppliers();
        Get.off(() => const SupplierPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Supplier!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addSupPay(SupplierPayment supPayData) async {
    var body = jsonEncode({
      "branch_id": branchId.value,
      "supplier": supPayData.supId,
      "transaction_ref": supPayData.ref,
      "transaction_amount": supPayData.amount,
      "transaction_comment": supPayData.comment,
      "discount": supPayData.discount,
      "trans_type": supPayData.transtype
    });
    try {
      var res =
          await http.post(Uri.parse(addSupPayUrl), body: body, headers: {});
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Supplier Payment Added!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getSupPayments();
        Get.off(() => const SupplierPayments());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Supplier Payment!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Edit Functions -----------------

  editSupplier(Supplier supData) async {
    var body = jsonEncode({
      'Supplier_id': supData.id,
      'supplier_name': supData.name,
      'supplier_item': supData.item,
      'supplier_bank_acc': supData.bankacc,
      'supplier_pin': supData.krapin,
      'supplier_address': supData.address,
      'supplier_phone_no': supData.cpperson,
    });
    try {
      var res = await http.patch(Uri.parse(updateSupUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      // debugPrint(res.body);
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Supplier Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getSuppliers();
        Get.off(() => const SupplierPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update supplier!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Utility Functions -----------------

  filterPaginator() {
    listPaginator(rangeList: rangeSupList, selectList: suppliers);
    if (rangeSupList.isEmpty) {
      showLoading.value = false;
      showData.value = false;
    } else {
      showLoading.value = false;
      showData.value = true;
    }
  }

  filterSupPayPaginator() {
    listPaginator(rangeList: ranegSupPayments, selectList: supPayments);
    if (ranegSupPayments.isEmpty) {
      showPayLoading.value = false;
      showPayData.value = false;
    } else {
      showPayLoading.value = false;
      showPayData.value = true;
    }
  }

  searchFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<Supplier> searchResult = RxList<Supplier>();

    for (var sup in suppliers) {
      List<String> supValue = searchParser(sup.name);
      for (var value in searchList) {
        if (searchResult.contains(sup) == false) {
          if (supValue.contains(value)) {
            searchResult.add(sup);
          }
        }
      }
    }

    clearLists();
    rangeSupList = searchResult;
    filterPaginator();
    update();
  }

  clearLists() {
    rangeSupList.clear();
    suppliers.clear();
  }

  clearPayLists() {
    ranegSupPayments.clear();
    supPayments.clear();
  }
}
