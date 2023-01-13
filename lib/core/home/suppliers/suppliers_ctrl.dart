import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/suppliers/supplier_payments.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SupplierCtrl extends GetxController {
  RxBool showMenu = false.obs;
  RxBool isSupEdit = false.obs;
  RxInt supToEdit = 1.obs;
  RxBool isSupPayEdit = false.obs;
  RxInt supPayToEdit = 1.obs;
  RxInt paysToShow = 1.obs;
  RxString supPageName = ''.obs;

  RxList<Supplier> suppliers = RxList<Supplier>();
  RxList<SupplierPayment> allSupPayments = RxList<SupplierPayment>();
  RxList<SupplierPayment> oneSupPayments = RxList<SupplierPayment>();

  @override
  void onInit() {
    super.onInit();
    getSuppliers();
    getSupPayments();
  }

  // ---------- Get Functions -----------------

  getSuppliers() {
    suppliers.clear();
    suppliers.value = [
      Supplier(
          id: 1,
          name: 'Supplier 01',
          item: 'Clothes',
          bankacc: 12345454,
          krapin: 132435,
          address: 'Nairobi CBD',
          cpperson: 0712345678),
      Supplier(
          id: 2,
          name: 'Supplier 02',
          item: 'Bags',
          bankacc: 12345454,
          krapin: 132435,
          address: 'Nairobi CBD',
          cpperson: 0712345678),
      Supplier(
          id: 3,
          name: 'Supplier 03',
          item: 'Shoes',
          bankacc: 12345454,
          krapin: 132435,
          address: 'Nairobi CBD',
          cpperson: 0712345678)
    ];
  }

  getSupPayments() {
    allSupPayments.value = [
      SupplierPayment(
          id: 1, supplierId: 1, quantity: 20, unitPrice: 300, total: 6000),
      SupplierPayment(
          id: 1, supplierId: 2, quantity: 30, unitPrice: 350, total: 6000),
      SupplierPayment(
          id: 1, supplierId: 2, quantity: 50, unitPrice: 400, total: 6000),
      SupplierPayment(
          id: 1, supplierId: 3, quantity: 60, unitPrice: 450, total: 6000),
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
    supPageName.value =
        '${suppliers.where((element) => element.id == (paysToShow.value)).first.name} Payments';
    Get.to(() => const SupplierPayments());
  }

  // ---------- Add Functions -----------------

  addSupplier(Supplier supData) async {
    var body = jsonEncode({
      'name': supData.name,
      'item': supData.item,
      'bankacc': supData.bankacc,
      'krapin': supData.krapin,
      'address': supData.address,
      'cpperson': supData.cpperson,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Supplier Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const SupplierPage());

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

  addSupPay(SupplierPayment supPayData) async {
    var body = jsonEncode({
      'supplierId': supPayData.supplierId,
      'quantity': supPayData.quantity,
      'unitPrice': supPayData.unitPrice,
      'total': supPayData.total,
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
      'name': supData.name,
      'item': supData.item,
      'bankacc': supData.bankacc,
      'krapin': supData.krapin,
      'address': supData.address,
      'cpperson': supData.cpperson,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.patch(Uri.parse(editUrl), body: body, headers: headers);
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
    //       title: "Failed to update category!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

  editSupPay(SupplierPayment supPayData) async {
    var body = jsonEncode({
      'supplierId': supPayData.supplierId,
      'quantity': supPayData.quantity,
      'unitPrice': supPayData.unitPrice,
      'total': supPayData.total,
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
}
