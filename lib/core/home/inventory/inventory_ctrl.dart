import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/category/category_main.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/inventory/products/product_main.dart';
import 'package:nawiri/core/home/inventory/uoms/uom_main.dart';
import 'package:nawiri/theme/global_widgets.dart';

class InventoryCtrl extends GetxController {
  RxString catDropdown = ''.obs;
  RxString uomDropdown = ''.obs;
  RxBool isCatEdit = false.obs;
  RxBool isProdEdit = false.obs;
  RxBool isUoMEdit = false.obs;
  RxInt catToEdit = 1.obs;
  RxInt prodToEdit = 1.obs;
  RxInt uoMToEdit = 1.obs;
  List<String> catStrs = [];
  List<String> uomStr = [];

  RxList<Category> categories = RxList<Category>();
  RxList<Product> products = RxList<Product>();
  RxList<UoM> uoms = RxList<UoM>();

  @override
  void onInit() {
    super.onInit();
    getCategories();
    getProducts();
    getUoMs();
  }

  // ---------- Get Functions -----------------

  getCategories() {
    categories.value = [
      Category(
          name: 'Category 01',
          id: 1,
          retailMg: 300,
          wholesaleMg: 150,
          showInPos: true),
      Category(
          name: 'Category 02',
          id: 2,
          retailMg: 500,
          wholesaleMg: 250,
          showInPos: true),
      Category(
          name: 'Category 03',
          id: 3,
          retailMg: 1000,
          wholesaleMg: 750,
          showInPos: false),
    ];
    catStrs.add('');
    for (final cat in categories) {
      catStrs.add(cat.name);
    }
  }

  getProducts() {
    products.value = [
      Product(
          name: 'Product 01',
          desc:
              'Lorem ipsum dolor sit amet, consecuture adipscing elit. Nam quis felis magna',
          retailMg: 700,
          wholesaleMg: 500,
          code: 1234,
          buyingPrice: 300,
          blockingneg: true,
          active: true,
          id: 1,
          categoryid: 1,
          uomId: 1),
      Product(
          name: 'Product 02',
          desc:
              'Lorem ipsum dolor sit amet, consecuture adipscing elit. Nam quis felis magna',
          retailMg: 850,
          wholesaleMg: 600,
          code: 9656,
          buyingPrice: 300,
          blockingneg: true,
          active: true,
          id: 2,
          categoryid: 3,
          uomId: 2),
      Product(
          name: 'Product 03',
          desc:
              'Lorem ipsum dolor sit amet, consecuture adipscing elit. Nam quis felis magna',
          retailMg: 1000,
          wholesaleMg: 750,
          code: 0977,
          buyingPrice: 300,
          blockingneg: true,
          active: true,
          id: 3,
          categoryid: 3,
          uomId: 2),
      Product(
          name: 'Product 03',
          desc:
              'Lorem ipsum dolor sit amet, consecuture adipscing elit. Nam quis felis magna',
          retailMg: 1000,
          wholesaleMg: 750,
          code: 0977,
          buyingPrice: 300,
          blockingneg: true,
          active: true,
          id: 4,
          categoryid: 2,
          uomId: 3)
    ];
  }

  getUoMs() {
    uoms.value = [
      UoM(name: 'UoM 01', id: 1),
      UoM(name: 'UoM 02', id: 2),
      UoM(name: 'UoM 03', id: 3),
    ];
    uomStr.add('');
    for (final uom in uoms) {
      uomStr.add(uom.name);
    }
  }

  // ---------- Add Functions -----------------

  addCategory(Category catData) async {
    var body = jsonEncode({
      'name': catData.name,
      'retailMg': catData.retailMg,
      'wholesaleMg': catData.wholesaleMg,
      'showInPos': catData.showInPos,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Category Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const CategoriesPage());

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

  addProduct(Product prodData) async {
    var body = jsonEncode({
      'name': prodData.name,
      'desc': prodData.desc,
      'retailMg': prodData.retailMg,
      'wholesaleMg': prodData.wholesaleMg,
      'code': prodData.code,
      'buyingPrice': prodData.buyingPrice,
      'blockingneg': prodData.blockingneg,
      'active': prodData.active,
      'categoryId': prodData.categoryid,
      'uomId': prodData.uomId
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(addUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Product Added!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const ProductsPage());

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

  addUoM(UoM uomData) async {
    var body = jsonEncode({
      'name': uomData.name,
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
        title: "Unit of Measurement Added!",
        subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const UoMsPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to add Unit of Measurement!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }

  // ---------- Edit Functions -----------------

  editCategory(Category catData) async {
    var body = jsonEncode({
      'name': catData.name,
      'retailMg': catData.retailMg,
      'wholesaleMg': catData.wholesaleMg,
      'showInPos': catData.showInPos,
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.patch(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Category Updated!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const CategoriesPage());

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

  editProduct(Product prodData) async {
    var body = jsonEncode({
      'name': prodData.name,
      'desc': prodData.desc,
      'retailMg': prodData.retailMg,
      'wholesaleMg': prodData.wholesaleMg,
      'code': prodData.code,
      'buyingPrice': prodData.buyingPrice,
      'blockingneg': prodData.blockingneg,
      'active': prodData.active,
      'categoryId': prodData.categoryid,
      'uomId': prodData.uomId
    });
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded, title: "Product Updated!", subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const ProductsPage());

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

  editUOM(UoM uomData) async {
    var body = jsonEncode({'name': uomData.name});
    debugPrint(body);
    // try {
    //   var res =
    //       await http.post(Uri.parse(editUrl), body: body, headers: headers);
    //   debugPrint("Got response ${res.statusCode}");
    //   debugPrint(res.body);
    //   if (res.statusCode == 201) {

    showSnackbar(
        path: Icons.check_rounded,
        title: "Unit of Measurement Updated!",
        subtitle: "");
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const UoMsPage());

    //     return;
    //   }
    //   return;
    // } catch (error) {
    //   debugPrint("$error");
    //   showSnackbar(
    //       path: Icons.close_rounded,
    //       title: "Failed to update Unit of Measurement!",
    //       subtitle: "Please check your internet connection or try again later");
    // }
  }
}
