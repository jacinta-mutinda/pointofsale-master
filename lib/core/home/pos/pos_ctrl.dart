import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/pos/checkout/checkout_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_models.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final customersCtrl = Get.put(CustomerCtrl());
final checkoutCtrl = Get.put(CheckoutCtrl());

class PoSCtrl extends GetxController {
  String? branchId;
  RxString selectedCat = ''.obs;
  RxList<Product> catProds = RxList<Product>();
  RxList<String> selectedProdIds = RxList<String>();
  RxList<Product> selectedProds = RxList<Product>();
  RxList<String> selectedCatIds = RxList<String>();
  RxBool showCatsLoading = true.obs;
  RxBool showCatsData = false.obs;
  RxBool catHasProds = true.obs;
  RxBool isProdChange = false.obs;
  Product prodToChange = Product(
      id: '',
      cartQuantity: '',
      name: '',
      desc: '',
      code: '',
      retailMg: '',
      wholesaleMg: '',
      buyingPrice: '',
      categoryid: '',
      uomId: '',
      blockingneg: '',
      active: '');
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

  RxList<Category> posCats = RxList<Category>();
  RxList<Product> posProds = RxList<Product>();

  @override
  void onInit() {
    super.onInit();
    setBranchId();
    getCategories();
    getProducts();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }

  getCategories() async {
    try {
      final response = await http.get(Uri.parse('$getCategoriesUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          if (item['show_in_pos'] == 'Y') {
            Category cat = Category(
                id: item['category_id'],
                name: item['category_desc'],
                retailMg: item['rmargin'],
                wholesaleMg: item['wmargin'],
                showInPos: item['show_in_pos']);
            posCats.add(cat);
          }
        }
      }
      getProducts();
      if (posCats.isEmpty) {
        showCatsLoading.value = false;
        showCatsData.value = false;
      } else {
        showCatsLoading.value = false;
        showCatsData.value = true;
      }
      update();
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load categories!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  getProducts() async {
    try {
      final response = await http.get(Uri.parse('$getProductsUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Product product = Product(
              cartQuantity: '1',
              id: item['location_product_id'],
              name: item['location_product_description'],
              desc: item['location_product_description'],
              code: item['location_productcode'],
              retailMg: item['location_product_sp'],
              wholesaleMg: item['location_product_sp1'],
              buyingPrice: item['location_product_sp'],
              categoryid: item['category_id'],
              uomId: item['uom_code'],
              blockingneg: item['blockneg'],
              active: item['active']);
          posProds.add(product);
        }
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load products",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  setNextTab() {
    catProds.clear();
    for (var prod in posProds) {
      if (prod.categoryid == selectedCat.value) {
        catProds.add(prod);
      }
    }
    if (catProds.isEmpty) {
      catHasProds.value = false;
    } else {
      catHasProds.value = true;
    }
  }

  addToCart(String prodId) {
    if (selectedProdIds.contains(prodId)) {
      selectedProds
          .remove(posProds.where((element) => element.id == (prodId)).first);
      selectedProdIds.remove(prodId);
    } else {
      selectedProds
          .add(posProds.where((element) => element.id == (prodId)).first);
      selectedProdIds.add(prodId);
    }
    cartLength.value = selectedProds.length;
  }

  addChangedItem() {
    Product prodToAdd = Product(
        cartQuantity: prodToChange.cartQuantity,
        id: prodToChange.id,
        name: prodToChange.name,
        desc: prodToChange.desc,
        code: prodToChange.code,
        retailMg: prodToChange.retailMg,
        wholesaleMg: prodToChange.wholesaleMg,
        buyingPrice: prodToChange.buyingPrice,
        categoryid: prodToChange.categoryid,
        uomId: prodToChange.uomId,
        blockingneg: prodToChange.blockingneg,
        active: prodToChange.active);
    selectedProds.add(prodToAdd);
    selectedProdIds.add(prodToAdd.id);
    cartLength.value++;
    prodToChange = Product(
        cartQuantity: '',
        id: '',
        name: '',
        desc: '',
        code: '',
        retailMg: '',
        wholesaleMg: '',
        buyingPrice: '',
        categoryid: '',
        uomId: '',
        blockingneg: '',
        active: '');
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
          quantity: int.parse(prod.cartQuantity).obs,
          unitPrice: int.parse(prodPrice).obs,
          total: (int.parse(prodPrice) * int.parse(prod.cartQuantity)).obs));
      cartItemId++;
    }
    cartLength.value = cartSale.cart.length;
    cartSale.total.value = 0;
    for (var item in cartSale.cart) {
      cartSale.total.value = cartSale.total.value + item.total.value;
    }
  }

  // updateCart() {
  //   cartSale.cart.removeWhere((element) => element.id == (selectedItem.id));
  //   cartSale.cart.add(CartItem(
  //       id: selectedItem.id,
  //       name: selectedItem.name,
  //       prodId: selectedItem.prodId,
  //       quantity: newCartItem.quantity,
  //       total: newCartItem.total,
  //       unitPrice: newCartItem.unitPrice));
  //   cartSale.total.value = 0;
  //   for (var item in cartSale.cart) {
  //     cartSale.total.value = cartSale.total.value + item.total.value;
  //   }
  //   cartLength.value = cartSale.cart.length;
  //   update();
  // }

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
  }

  clearLists() {
    posCats.clear();
    posProds.clear();
  }
}
