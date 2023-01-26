import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_bills.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerCtrl extends GetxController {
  RxString transtyeDrop = ''.obs;
  RxString branchId = ''.obs;
  RxBool showData = false.obs;
  RxBool showLoading = true.obs;
  RxBool showRecData = false.obs;
  RxBool showRecLoading = true.obs;
  RxBool fieldsRequired = false.obs;
  RxBool isCustEdit = false.obs;
  CustReceipt singleRec = CustReceipt(
      id: '',
      custId: '',
      date: '',
      transtype: '',
      discount: '',
      ref: '',
      comment: '',
      amount: '');
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

  List<String> transtypes = ['', 'Cash', 'M-pesa', 'Bank'];
  RxList<Customer> customers = RxList<Customer>();
  RxList<Customer> rangeCustList = RxList<Customer>();
  RxList<CustReceipt> custReceipts = RxList<CustReceipt>();
  RxList<CustReceipt> rangeCustReceipts = RxList<CustReceipt>();

  @override
  void onInit() async {
    super.onInit();
    setBranchId();
    getCustomers();
  }

  setBranchId() async {
    var prefs = await SharedPreferences.getInstance();
    branchId.value = prefs.getString('branchId') ?? '00';
  }

  // ---------- Get Functions -----------------

  getCustomers() async {
    clearLists();
    // get branchId from functions.dart
    try {
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

  getCustPayments() async {
    clearRecLists();
    var body = jsonEncode({
      'customer_id': custToShow.id,
    });
    try {
      branchId.value = '122';
      final response = await http.post(Uri.parse(getCustReceiptsUrl),
          body: body, headers: headers);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          CustReceipt rec = CustReceipt(
              id: item['customer_trans_id'],
              custId: item['customer'],
              ref: item['transaction_ref'],
              date: item['transaction_date'],
              amount: item['transaction_amount'],
              discount: item['discount'],
              transtype: item['trans_type'].toString(),
              comment: item['transaction_comment']);
          custReceipts.add(rec);
        }
        filterRecPaginator();
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
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Customer Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getCustomers();
        Get.off(() => const CustomersPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Customer!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addCustReceipt(CustReceipt recData) async {
    var body = jsonEncode({
      "branch_id": branchId.value,
      "transaction_date": DateTime.now().toString(),
      "customer": recData.custId,
      "transaction_ref": recData.ref,
      "transaction_amount": int.parse(recData.amount),
      "transaction_comment": recData.comment,
      "discount": recData.discount,
      "created_by": "",
      "bank_id": '1d4c4e57-aac3-497b-bbb3-f3cae6912577',
      "trans_by": "",
      "trans_type": 10,
      "transtype": recData.transtype
    });

    try {
      var res = await http
          .post(Uri.parse(addCustReceiptUrl), body: body, headers: {});
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Customer Payment Added!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getCustPayments();
        Get.off(() => const CustomerReceipts());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Customer Payment!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Edit Functions -----------------

  editCustomer(Customer custData) async {
    var body = jsonEncode({
      "customer_id": custToShow.id,
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
      var res = await http.patch(Uri.parse(updateCustomerUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      // debugPrint(res.body);
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Customer Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getCustomers();
        Get.off(() => const CustomersPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update customer!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  // ---------- Utility Functions -----------------

  filterPaginator() {
    listPaginator(rangeList: rangeCustList, selectList: customers);
    if (rangeCustList.isEmpty) {
      showLoading.value = false;
      showData.value = false;
    } else {
      showLoading.value = false;
      showData.value = true;
    }
  }

  filterRecPaginator() {
    listPaginator(rangeList: rangeCustReceipts, selectList: custReceipts);
    if (rangeCustReceipts.isEmpty) {
      showRecLoading.value = false;
      showRecData.value = false;
    } else {
      showRecLoading.value = false;
      showRecData.value = true;
    }
  }

  searchFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<Customer> searchResult = RxList<Customer>();

    for (var cust in customers) {
      List<String> custValue = searchParser(cust.name);
      for (var value in searchList) {
        if (searchResult.contains(cust) == false) {
          if (custValue.contains(value)) {
            searchResult.add(cust);
          }
        }
      }
    }

    clearLists();
    rangeCustList = searchResult;
    filterPaginator();
    update();
  }

  clearLists() {
    rangeCustList.clear();
    customers.clear();
  }

  clearRecLists() {
    rangeCustReceipts.clear();
    custReceipts.clear();
  }
}
