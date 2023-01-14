import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_bills.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/customers/single_bill.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';

class CustomerCtrl extends GetxController {
  RxBool showMenu = false.obs;
  RxBool isCustEdit = false.obs;
  RxInt custToEdit = 1.obs;
  RxInt billsToShow = 1.obs;
  RxInt singleBillId = 1.obs;
  RxString custPageName = ''.obs;
  Customer custToShow = Customer(
      id: 1,
      name: '',
      phoneno: 1,
      bankacc: 1,
      krapin: 1,
      address: '',
      cpperson: 1,
      creditlimit: 1);
  Sale singleBill = Sale(
      id: 1,
      cart: [],
      total: 1,
      payMethod: '',
      custId: 1,
      refCode: '',
      paid: true,
      date: '');
  RxList<Customer> customers = RxList<Customer>();
  RxList<Sale> allSales = RxList<Sale>();
  RxList<Sale> oneCustSales = RxList<Sale>();

  @override
  void onInit() {
    super.onInit();
    getCustomers();
    getAllSales();
  }

  // ---------- Get Functions -----------------

  getCustomers() {
    customers.clear();
    customers.value = [
      Customer(
          id: 1,
          name: 'Customer 01',
          phoneno: 0712345678,
          bankacc: 642312,
          krapin: 4323212,
          address: 'Kamuthi Estate',
          cpperson: 0712345678,
          creditlimit: 1000),
      Customer(
          id: 2,
          name: 'Customer 02',
          phoneno: 0712345678,
          bankacc: 642312,
          krapin: 4323212,
          address: 'Kamuthi Estate',
          cpperson: 0712345678,
          creditlimit: 1000),
      Customer(
          id: 3,
          name: 'Customer 03',
          phoneno: 0712345678,
          bankacc: 642312,
          krapin: 4323212,
          address: 'Kamuthi Estate',
          cpperson: 0712345678,
          creditlimit: 1000),
    ];
  }

  getAllSales() {
    allSales.value = [
      Sale(
          id: 1,
          cart: [
            CartItem(id: 1, prodId: 1, quantity: 3, total: 900),
            CartItem(id: 2, prodId: 2, quantity: 2, total: 1000),
          ],
          total: 1900,
          payMethod: 'M-pesa',
          paid: false,
          refCode: 'QERT44663',
          custId: 1,
          date: '2023-01-14'),
      Sale(
          id: 2,
          cart: [
            CartItem(id: 1, prodId: 1, quantity: 3, total: 900),
            CartItem(id: 2, prodId: 2, quantity: 2, total: 1000),
          ],
          total: 1250,
          payMethod: 'M-pesa',
          paid: true,
          refCode: 'QERT44663',
          custId: 1,
          date: '2023-01-14'),
      Sale(
          id: 3,
          cart: [
            CartItem(id: 1, prodId: 1, quantity: 3, total: 900),
            CartItem(id: 2, prodId: 2, quantity: 2, total: 1000),
          ],
          total: 1900,
          payMethod: 'M-pesa',
          paid: true,
          refCode: 'QERT44663',
          custId: 2,
          date: '2023-01-14'),
      Sale(
          id: 4,
          cart: [
            CartItem(id: 1, prodId: 1, quantity: 3, total: 900),
            CartItem(id: 2, prodId: 2, quantity: 2, total: 1000),
          ],
          total: 1900,
          payMethod: 'M-pesa',
          paid: true,
          refCode: 'QERT44663',
          custId: 3,
          date: '2023-01-14'),
    ];
  }

  getCustSales() {
    custPageName.value = '';
    oneCustSales.clear();
    for (final sale in allSales) {
      if (sale.custId == billsToShow.value) {
        oneCustSales.add(sale);
      }
    }
    custToShow =
        customers.where((element) => element.id == (billsToShow.value)).first;
    custPageName.value = customers
        .where((element) => element.id == (billsToShow.value))
        .first
        .name;
    Get.to(() => const CustomerBills());
  }

  getSingleBill() {
    singleBill = oneCustSales
        .where((element) => element.id == (singleBillId.value))
        .first;
    Get.dialog(const SingleBill());
  }

  // ---------- Add Functions -----------------

  addCustomer(Customer custData) async {
    var body = jsonEncode({
      'name': custData.name,
      'item': custData.phoneno,
      'bankacc': custData.bankacc,
      'krapin': custData.krapin,
      'address': custData.address,
      'cpperson': custData.cpperson,
      'creditlimit': custData.creditlimit,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Customer Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const CustomersPage());

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

  editCustomer(Customer custData) async {
    var body = jsonEncode({
      'name': custData.name,
      'item': custData.phoneno,
      'bankacc': custData.bankacc,
      'krapin': custData.krapin,
      'address': custData.address,
      'cpperson': custData.cpperson,
      'creditlimit': custData.creditlimit,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.patch(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Customer Updated!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const CustomersPage());

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
