import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';

final invtCtrl = Get.put(InventoryCtrl());

class PoSCtrl extends GetxController {
  RxInt selectedCat = 1.obs;
  RxInt selectedCartItem = 1.obs;
  CartItem selectedItem =
      CartItem(id: 1, name: '', prodId: 1, quantity: 1, unitPrice: 1, total: 1);

  RxList<Product> catProds = RxList<Product>();
  RxList<int> selectedProdIds = RxList<int>();
  RxList<Product> selectedProds = RxList<Product>();
  Sale cartSale = Sale(
      id: 1,
      cart: [],
      total: 1,
      payMethod: '',
      custId: 1,
      refCode: '',
      date: '',
      paid: false);

  setNextTab() {
    selectedProds.clear();
    selectedProdIds.clear();
    for (var prod in invtCtrl.products) {
      if (prod.categoryid == selectedCat.value) {
        catProds.add(prod);
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
          total: prod.retailMg,
          unitPrice: prod.retailMg));
    }
    for (var item in cartSale.cart) {
      var total = 0;
      cartSale.total = total + item.total;
    }
    Get.back();
  }

  updateCart() {
    for (var item in cartSale.cart) {
      var total = 0;
      cartSale.total = total + item.total;
    }
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
}
