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
  RxString branchId = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxBool fieldsRequired = false.obs;
  RxBool isSupEdit = false.obs;
  RxString supToEdit = ''.obs;
  RxBool isSupPayEdit = false.obs;
  RxInt supPayToEdit = 1.obs;
  RxString paysToShow = ''.obs;
  RxString supPageName = ''.obs;
  Supplier supToShow = Supplier(
      id: '',
      name: '',
      item: '',
      bankacc: '',
      krapin: '',
      address: '',
      cpperson: '',
      phoneno: '');
  RxList<Supplier> suppliers = RxList<Supplier>();
  RxList<Supplier> rangeSupList = RxList<Supplier>();
  RxList<SupplierPayment> allSupPayments = RxList<SupplierPayment>();
  RxList<SupplierPayment> oneSupPayments = RxList<SupplierPayment>();

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
    getSupPayments();
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

  getSupPayments() {
    allSupPayments.value = [
      SupplierPayment(
          id: 1,
          supplierId: 1,
          quantity: 20,
          unitPrice: 300,
          total: 6000,
          date: '2023-01-14'),
      SupplierPayment(
          id: 1,
          supplierId: 2,
          quantity: 30,
          unitPrice: 350,
          total: 6000,
          date: '2023-01-14'),
      SupplierPayment(
          id: 1,
          supplierId: 2,
          quantity: 50,
          unitPrice: 400,
          total: 6000,
          date: '2023-01-14'),
      SupplierPayment(
          id: 1,
          supplierId: 3,
          quantity: 60,
          unitPrice: 450,
          total: 6000,
          date: '2023-01-14'),
    ];
  }

  getOneSupPayments() {
    supPageName.value = '';
    oneSupPayments.clear();
    for (final pay in allSupPayments) {
      if (pay.supplierId == paysToShow.value) {
        oneSupPayments.add(pay);
      }
    }
    supToShow =
        suppliers.where((element) => element.id == (paysToShow.value)).first;
    supPageName.value = suppliers
        .where((element) => element.id == (paysToShow.value))
        .first
        .name;
    Get.to(() => const SupplierPayments());
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
      'supplierId': supPayData.supplierId,
      'quantity': supPayData.quantity,
      'unitPrice': supPayData.unitPrice,
      'total': supPayData.total,
      'date': supPayData.date
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
        title: "Supplier Payment Added!",
        subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const SupplierPage());

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

  editSupPay(SupplierPayment supPayData) async {
    var body = jsonEncode({
      'supplierId': supPayData.supplierId,
      'quantity': supPayData.quantity,
      'unitPrice': supPayData.unitPrice,
      'total': supPayData.total,
      'date': supPayData.date
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Supplier Updated!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const SupplierPage());

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
    listPaginator(rangeList: rangeSupList, selectList: suppliers);
    if (rangeSupList.isEmpty) {
      showLoading.value = false;
      showData.value = false;
    } else {
      showLoading.value = false;
      showData.value = true;
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
}
