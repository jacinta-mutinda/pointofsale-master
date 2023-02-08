import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/pos/checkout/checkout.dart';
import 'package:nawiri/core/home/pos/checkout/pdf_invoice_api.dart';
import 'package:nawiri/core/home/pos/pos.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/file_handle_api.dart';

final customersCtrl = Get.put(CustomerCtrl());
final posCtrl = Get.put(PoSCtrl());
final invtCtrl = Get.put(InventoryCtrl());

class CheckoutCtrl extends GetxController {
  RxString selectedCustAcc = ''.obs;
  RxString bankAccDropdown = ''.obs;
  RxBool isMpesaPay = false.obs;
  RxBool isCashPay = false.obs;
  RxBool isBankPay = false.obs;
  RxBool isOnAccPay = false.obs;
  RxString selectedCustAccId = ''.obs;
  RxInt selectedBankId = 1.obs;
  TextEditingController customerctrl = TextEditingController();
  CheckOutDet checkDetData = CheckOutDet(
      totalPaid: '',
      payMthd: '',
      mpesaRefCode: '',
      bankRefCode: '',
      cashPaid: '',
      bankPaid: '',
      onAccPaid: '',
      mobilePaid: '',
      balance: '',
      custAccId: '',
      bankAccId: '');

  RxList<Customer> custList = RxList<Customer>();

  setBankAcc() {
    for (BankAccount acc in BankingCtrl().bankAccounts) {
      if (acc.bankName == bankAccDropdown.value) {
        selectedBankId.value = int.parse(acc.id);
      }
    }
  }

  setCustAcc() {
    for (Customer cust in customersCtrl.customers) {
      if (cust.name == selectedCustAcc.value) {
        selectedCustAccId.value = cust.id;
      }
    }
    customerctrl.text = selectedCustAcc.value;
    Get.back();
  }

  completeSale() async {
    var sale = posCtrl.cartSale;
    var cart = posCtrl.cartSale.cart;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var shift = prefs.getString('shiftId');

    // creating receipt item jsons
    var rd = [];
    for (var item in cart) {
      Product cartProd = invtCtrl.products
          .where((element) => element.id == (item.prodId))
          .first;
      rd.add({
        "receipt_id": "NaN",
        "trans_quantity": (item.quantity.value).toString(),
        "product_sp": cartProd.retailMg,
        "product_bp": (item.unitPrice.value).toString(),
        "vat": '0',
        "cat_levy": '0',
        "cancelled": 'N',
        "footnote": null,
        "accompaniment_id": null,
        'branch_id': '122',
        "updated": 'N',
        "linenum": '0',
        "uom_code": cartProd.uomId,
        "item_printed": 'N',
        "batch_no": null,
        "fuel_vat": '0',
        "discount": '0',
        "packaging": '0',
        "location_product": "NaN",
        "location_product_id": cartProd.id
      });
    }
// creating the full checkout POST body
    var body = jsonEncode({
      "RC": {
        "receipt_id": "NaN",
        "receipt_ref": "",
        "receipt_date": sale.date,
        "receipt_time": '00:00',
        "receipt_total_amount": (sale.total.value).toString(),
        "total_vat": "0",
        "total_cat_levy": "0",
        "receipt_cash_amount": checkDetData.cashPaid,
        "receipt_cheque_amount": '0',
        "receipt_card_amount": checkDetData.bankPaid,
        "receipt_voucher_amount": '0',
        "receipt_mobile_money": checkDetData.mobilePaid,
        "cancelled": "",
        "table_id": "",
        "receipt_paid": "Y",
        "customer_alias": "",
        "stype": "",
        "dlocation": "",
        "sales_staff_id": "",
        "receipt_code": "",
        "comments": "",
        "receipt_discount": "0.00",
        "updated": "Y",
        "uom_code": null,
        "bill_printed": 'N',
        "total_fuel_vat": '0',
        "service_customer_id": null,
        "service_vehicle_id": null,
        "branch": 125,
        "location": "",
        "staff": "",
        "till": "",
        "shift": shift,
        "customer": selectedCustAccId.value
      },
      "RD": rd,
      "RP": {
        "payment_date": sale.date,
        "staff_id": "",
        "shift_id": shift,
        "till_id": "",
        "cancelled": "Y",
        "cancelled_by": "45",
        "cancelled_on": "2020-09-11",
        "payment_amount": (checkDetData.totalPaid),
        "receipt_id": ''
      }
    });
    try {
      var res = await http.post(Uri.parse(addCheckoutUrl),
          body: body, headers: apiHeaders);
      if (res.statusCode == 201) {
        print(res.body);
        showSnackbar(
            path: Icons.check_rounded,
            title: "Checkout Successful!",
            subtitle: "Thank you for Shopping with us!");
        fetchReceipt();
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to checkout!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  reset() {
    isMpesaPay.value = false;
    isBankPay.value = false;
    isCashPay.value = false;
    isOnAccPay.value = false;
    bankAccDropdown.value = '';
    selectedCustAcc = ''.obs;
    selectedCustAccId = ''.obs;
    selectedBankId = 1.obs;
    checkDetData = CheckOutDet(
        totalPaid: '',
        payMthd: '',
        mpesaRefCode: '',
        bankRefCode: '',
        cashPaid: '',
        bankPaid: '',
        onAccPaid: '',
        mobilePaid: '',
        balance: '',
        custAccId: '',
        bankAccId: '');
    update();
  }

  final pdfCtrl = Get.put(PdfInvoiceApi());

  fetchReceipt() async {
    final pdfFile =
        await pdfCtrl.generate(checkDetData.balance, checkDetData.totalPaid);
    FileHandleApi.openFile(pdfFile);
    posCtrl.clearSale();
    Get.offAll(const PoSPage());
  }
}
