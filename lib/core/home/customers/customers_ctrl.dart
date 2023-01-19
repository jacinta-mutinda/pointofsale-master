import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_bills.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/customers/single_bill.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerCtrl extends GetxController {
  RxString branchId = ''.obs;
  RxBool showData = false.obs;
  RxBool isCustEdit = false.obs;
  RxString custToEdit = ''.obs;
  RxString billsToShow = ''.obs;
  RxInt singleBillId = 1.obs;
  RxString custPageName = ''.obs;
  Customer custToShow = Customer(
      id: '',
      name: '',
      phoneno: '',
      bankacc: '',
      krapin: '',
      address: '',
      cpperson: '',
      creditlimit: '',
      totalCredit: '',
      runningBal: '');
  Sale singleBill = Sale(
      id: 1,
      cart: <CartItem>[].obs,
      total: 1.obs,
      payMethod: '',
      custId: 1,
      refCode: '',
      paid: true,
      date: '');
  RxList<Customer> customers = RxList<Customer>();
  RxList<Customer> rangeCustList = RxList<Customer>();
  RxList<Sale> allSales = RxList<Sale>();
  RxList<Sale> oneCustSales = RxList<Sale>();

  @override
  void onInit() async {
    super.onInit();
    getBranch();
    getCustomers();
    getAllSales();
  }

  void getBranch() async {
    var prefs = await SharedPreferences.getInstance();
    var branch = prefs.getString('branchId');
    if (branch != null) {
      branchId.value = branch;
    }
  }

  // ---------- Get Functions -----------------
  Map<String, String> apiHeaders = {'Content-type': 'application/json'};

  getCustomers() async {
    clearLists();
    // get branchId
    try {
      branchId.value = '122';
      final response = await http.get(
          Uri.parse('$getCustomersUrl/${branchId.value}'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Customer cust = Customer(
              id: item['customer_id'],
              name: item['customer_name'],
              phoneno: item['customer_phone_no'],
              bankacc: item['customer_bank_acc'],
              krapin: item['pin_number'],
              address: item['customer_address'],
              cpperson: item['customer_contact_person'],
              creditlimit: item['customer_credit_limit'],
              runningBal: item['customer_running_bal'],
              totalCredit: item['customer_total_credit']);
          customers.add(cust);
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
          title: "Failed to load customers!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getAllSales() {
    allSales.value = [
      Sale(
          id: 1,
          cart: [
            CartItem(
                id: 1,
                prodId: 1,
                quantity: 3,
                total: 900.obs,
                unitPrice: 300,
                name: 'Product 00'),
            CartItem(
                id: 2,
                prodId: 2,
                quantity: 2,
                total: 1000.obs,
                unitPrice: 500,
                name: 'Product 00'),
          ].obs,
          total: 1900.obs,
          payMethod: 'M-pesa',
          paid: false,
          refCode: 'QERT44663',
          custId: 1,
          date: '2023-01-14'),
      Sale(
          id: 2,
          cart: [
            CartItem(
                id: 1,
                prodId: 1,
                quantity: 3,
                total: 900.obs,
                unitPrice: 300,
                name: 'Product 00'),
            CartItem(
                id: 2,
                prodId: 2,
                quantity: 2,
                total: 1000.obs,
                unitPrice: 500,
                name: 'Product 00'),
          ].obs,
          total: 1250.obs,
          payMethod: 'M-pesa',
          paid: true,
          refCode: 'QERT44663',
          custId: 1,
          date: '2023-01-14'),
      Sale(
          id: 3,
          cart: [
            CartItem(
                id: 1,
                prodId: 1,
                quantity: 3,
                total: 900.obs,
                unitPrice: 300,
                name: 'Product 00'),
            CartItem(
                id: 2,
                prodId: 2,
                quantity: 2,
                total: 1000.obs,
                unitPrice: 500,
                name: 'Product 00'),
          ].obs,
          total: 1900.obs,
          payMethod: 'M-pesa',
          paid: true,
          refCode: 'QERT44663',
          custId: 2,
          date: '2023-01-14'),
      Sale(
          id: 4,
          cart: [
            CartItem(
                id: 1,
                prodId: 1,
                quantity: 3,
                total: 900.obs,
                unitPrice: 300,
                name: 'Product 00'),
            CartItem(
                id: 2,
                prodId: 2,
                quantity: 2,
                total: 1000.obs,
                unitPrice: 500,
                name: 'Product 00'),
          ].obs,
          total: 1900.obs,
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
      // if (sale.custId == int.parse(billsToShow.value)) {
      oneCustSales.add(sale);
      // }
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
      "branch_id": branchId.value,
      "customer_name": custData.name,
      "customer_running_bal": custData.runningBal,
      "customer_bank_acc": custData.bankacc,
      "customer_phone_no": custData.phoneno,
      "customer_address": custData.address,
      "customer_contact_person": custData.cpperson,
      "customer_credit_limit": custData.creditlimit,
      "customer_total_credit": custData.totalCredit,
      "pin_number": custData.krapin,
    });
    try {
      var res =
          await http.post(Uri.parse(addCustomerUrl), body: body, headers: {});
      debugPrint(res.body);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Customer Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const CustomersPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Category!",
          subtitle: "Please check your internet connection or try again later");
    }
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

  // ---------- Utility Functions -----------------

  filterPaginator() {
    listPaginator(rangeList: rangeCustList, selectList: customers);
    if (rangeCustList.isEmpty) {
      showData.value = false;
    } else {
      showData.value = true;
    }
  }

  clearLists() {
    rangeCustList.clear();
    customers.clear();
  }
}
