import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/pos/checkout/checkout_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_models.dart';

final invtCtrl = Get.put(InventoryCtrl());
final customersCtrl = Get.put(CustomerCtrl());
final checkoutCtrl = Get.put(CheckoutCtrl());

class PoSCtrl extends GetxController {
  RxString selectedCat = ''.obs;
  RxList<Product> catProds = RxList<Product>();
  RxList<String> selectedProdIds = RxList<String>();
  RxList<Product> selectedProds = RxList<Product>();
  RxList<String> selectedCatIds = RxList<String>();
  RxList<CartItem> tempCart = RxList<CartItem>();
  RxInt cartLength = 0.obs;
  CartItem selectedItem = CartItem(
      id: '',
      name: '',
      prodId: '',
      quantity: 1.obs,
      unitPrice: 1.obs,
      total: 1.obs);
  CartItem newCartItem = CartItem(
      id: '',
      name: '',
      prodId: '',
      quantity: 1.obs,
      unitPrice: 1.obs,
      total: 1.obs);
  Sale cartSale = Sale(
      id: '',
      cart: <CartItem>[].obs,
      total: 1.obs,
      payMethod: '',
      custId: '',
      refCode: '',
      date: '',
      paid: false);

  setNextTab() {
    catProds.clear();
    for (var prod in invtCtrl.products) {
      if (prod.categoryid == selectedCat.value) {
        catProds.add(prod);
      }
    }
  }

  addToCart(String prodId) {
    selectedProds.add(
        invtCtrl.products.where((element) => element.id == (prodId)).first);
    selectedProdIds.add(prodId);
    cartLength.value = selectedProds.length;
  }

  createCart() {
    cartSale.cart.clear();
    cartSale.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var cartItemId = -1;
    for (var prod in selectedProds) {
      var prodPrice = prod.retailMg.substring(0, prod.retailMg.length - 3);
      cartSale.cart.add(CartItem(
          id: (cartItemId + 1).toString(),
          name: prod.name,
          prodId: prod.id,
          quantity: 1.obs,
          total: int.parse(prodPrice).obs,
          unitPrice: int.parse(prodPrice).obs));
      cartItemId++;
    }
    cartLength.value = cartSale.cart.length;
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
  }

  updateCart() {
    cartSale.cart.removeWhere((element) => element.id == (selectedItem.id));
    cartSale.cart.add(CartItem(
        id: selectedItem.id,
        name: selectedItem.name,
        prodId: selectedItem.prodId,
        quantity: newCartItem.quantity,
        total: newCartItem.total,
        unitPrice: newCartItem.unitPrice));
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
    cartLength.value = cartSale.cart.length;
    update();
    Get.back();
  }

  removeCartItem() {
    selectedProds.removeWhere((element) => element.id == (selectedItem.prodId));
    selectedProdIds.remove(selectedItem.prodId);
    cartSale.cart.removeWhere((element) => element.id == (selectedItem.id));
    cartLength.value = cartSale.cart.length;
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
    update();
    Get.back();
  }

  bool isSelected(String prodId) {
    if (selectedProdIds.contains(prodId)) {
      return true;
    } else {
      return false;
    }
  }

  cancelSale() {
    cartSale = Sale(
        id: '',
        cart: <CartItem>[].obs,
        total: 1.obs,
        payMethod: '',
        custId: 1.toString(),
        refCode: '',
        date: '',
        paid: false);
    selectedItem = CartItem(
        id: '',
        name: '',
        prodId: '',
        quantity: 1.obs,
        unitPrice: 1.obs,
        total: 1.obs);
    cartLength.value = 0;
    selectedProdIds.clear();
    selectedProds.clear();
    checkoutCtrl.reset();
    Get.offAll(NavigatorHandler(0));
  }
}
