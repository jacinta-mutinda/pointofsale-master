import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/pos/pos.dart' as pos;
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

final invtCtrl = Get.put(InventoryCtrl());
final customersCtrl = Get.put(CustomerCtrl());

class PoSCtrl extends GetxController {
  RxString selectedCustAcc = ''.obs;
  RxString bankAccDropdown = ''.obs;
  RxString payMthdDropdown = ''.obs;
  RxBool showCheckoutForm = false.obs;
  RxBool isMpesaPay = false.obs;
  RxBool isCashPay = false.obs;
  RxBool isBankPay = false.obs;
  RxBool isOnAccPay = false.obs;
  RxInt selectedCartItem = 1.obs;
  RxInt selectedCustAccId = 1.obs;
  RxInt selectedBankId = 1.obs;
  TextEditingController customerctrl = TextEditingController();

  CheckOutDet checkDetData = CheckOutDet(
      payMthd: '',
      mpesaRefCode: '',
      bankRefCode: '',
      paid: 1,
      balance: 1,
      custAccId: 1,
      bankAccId: 1);
  List<String> payMthdsStrs = [
    '',
    'M-pesa',
    'Cash',
    'Bank Account',
    'On Customer Account'
  ];
  RxList<Product> catProds = RxList<Product>();
  RxList<int> selectedProdIds = RxList<int>();
  RxList<Product> selectedProds = RxList<Product>();
  RxList<int> selectedCatIds = RxList<int>();
  RxList<Customer> custList = RxList<Customer>();

  CartItem selectedItem = CartItem(
      id: 1, name: '', prodId: 1, quantity: 1, unitPrice: 1, total: 1.obs);
  CartItem newCartItem = CartItem(
      id: 1, name: '', prodId: 1, quantity: 1, unitPrice: 1, total: 1.obs);
  Sale cartSale = Sale(
      id: 1,
      cart: <CartItem>[].obs,
      total: 1.obs,
      payMethod: '',
      custId: 1,
      refCode: '',
      date: '',
      paid: false);

  setCheckoutForm() {
    if (payMthdDropdown.value == 'M-pesa') {
      isMpesaPay.value = true;
      isCashPay.value = false;
      isBankPay.value = false;
      isOnAccPay.value = false;
    } else if (payMthdDropdown.value == 'Cash') {
      isMpesaPay.value = false;
      isCashPay.value = true;
      isBankPay.value = false;
      isOnAccPay.value = false;
    } else if (payMthdDropdown.value == 'Bank Account') {
      isMpesaPay.value = false;
      isCashPay.value = false;
      isBankPay.value = true;
      isOnAccPay.value = false;
    } else {
      isMpesaPay.value = false;
      isCashPay.value = false;
      isBankPay.value = false;
      isOnAccPay.value = true;
      custList.clear();
      for (var cust in customersCtrl.customers) {
        custList.add(cust);
      }
      Get.dialog(const pos.CustomerList());
    }
  }

  addToCatProds(int catId) async {
    if (selectedCatIds.contains(catId)) {
      selectedCatIds.remove(catId);
    } else {
      selectedCatIds.add(catId);
    }
    selectedProds.clear();
    selectedProdIds.clear();
    catProds.clear();
    for (var catId in selectedCatIds) {
      for (var prod in invtCtrl.products) {
        if (prod.categoryid == catId) {
          catProds.add(prod);
        }
      }
    }
  }

  addToCart(int prodId) {
    selectedProds.add(
        invtCtrl.products.where((element) => element.id == (prodId)).first);
    selectedProdIds.add(prodId);
  }

  createCart() {
    cartSale.cart.clear();
    cartSale.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var cartItemId = -1;
    for (var prod in selectedProds) {
      cartSale.cart.add(CartItem(
          id: cartItemId + 1,
          name: prod.name,
          prodId: prod.id,
          quantity: 1,
          total: prod.retailMg.obs,
          unitPrice: prod.retailMg));
      cartItemId++;
    }
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
  }

  updateCart() {
    var prevItem = cartSale.cart
        .where((element) => element.id == (selectedCartItem.value))
        .first;
    cartSale.cart
        .removeWhere((element) => element.id == (selectedCartItem.value));
    cartSale.cart.add(CartItem(
        id: selectedCartItem.value,
        name: prevItem.name,
        prodId: prevItem.id,
        quantity: newCartItem.quantity,
        total: newCartItem.total,
        unitPrice: newCartItem.unitPrice));
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
    Get.back();
  }

  setCartItem() {
    selectedItem = cartSale.cart
        .where((element) => element.id == (selectedCartItem.value))
        .first;
  }

  bool isSelected(int prodId) {
    if (selectedProdIds.contains(prodId)) {
      return true;
    } else {
      return false;
    }
  }

  bool isCatSelected(int catId) {
    if (selectedCatIds.contains(catId)) {
      return true;
    } else {
      return false;
    }
  }

  setBankAcc() {
    for (BankAccount acc in BankingCtrl().bankAccounts) {
      if (acc.bankName == bankAccDropdown.value) {
        selectedBankId.value = acc.id;
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

  completeSale() {
    // save form
    showSnackbar(
        title: 'Sale Successfully Closed!',
        path: Icons.check_rounded,
        subtitle: 'Redirecting to Home Page');
    Get.offAll(NavigatorHandler(0));
  }

  checkout() {
    showCheckoutForm.value = true;
  }

  createBill() {
    // add sale to Pending Bills
    showSnackbar(
        title: 'Bill added to Pending Bills',
        path: Icons.check_rounded,
        subtitle: '');
    Get.offAll(NavigatorHandler(0));
  }

  cancelSale() {
    cartSale = Sale(
        id: 1,
        cart: <CartItem>[].obs,
        total: 1.obs,
        payMethod: '',
        custId: 1,
        refCode: '',
        date: '',
        paid: false);
    selectedCartItem = 1.obs;
    selectedItem = CartItem(
        id: 1, name: '', prodId: 1, quantity: 1, unitPrice: 1, total: 1.obs);
    selectedProdIds.clear();
    selectedProds.clear();
    Get.offAll(NavigatorHandler(0));
  }
}

class CheckOutDet {
  String payMthd;
  String mpesaRefCode;
  String bankRefCode;
  int paid;
  int balance;
  int custAccId;
  int bankAccId;

  CheckOutDet(
      {required this.payMthd,
      required this.mpesaRefCode,
      required this.bankRefCode,
      required this.paid,
      required this.balance,
      required this.custAccId,
      required this.bankAccId});
}
