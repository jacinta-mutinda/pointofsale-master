import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/category/category_main.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/core/home/inventory/products/product_main.dart';
import 'package:nawiri/core/home/inventory/uoms/uom_main.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryCtrl extends GetxController {
  String? branchId;

  @override
  void onInit() {
    super.onInit();
    setBranchId();
    getCategories();
    getUoMs();
    getProducts();
  }

  setBranchId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('branchId');
  }

  // ---------------------------------- Category Variables & Functions -----------------------------------------------

  RxBool isCatEdit = false.obs;
  RxString catDropdown = ''.obs;
  RxBool showCatData = false.obs;
  RxBool showCatLoading = true.obs;
  RxBool fieldsCatRequired = false.obs;
  RxString catToEdit = ''.obs;
  List<String> catStrs = [];
  RxList<Category> categories = RxList<Category>();
  RxList<Category> rangeCatList = RxList<Category>();

  getCategories() async {
    clearCatLists();
    try {
      final response = await http.get(Uri.parse('$getCategoriesUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Category cat = Category(
              id: item['category_id'],
              name: item['category_desc'],
              retailMg: item['rmargin'],
              wholesaleMg: item['wmargin'],
              showInPos: item['show_in_pos']);
          categories.add(cat);
          if (!catStrs.contains(item['category_desc'])) {
            catStrs.add(item['category_desc']);
          }
        }
        catStrs.add(catDropdown.value);
        filterCatPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load categories!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addCategory(Category catData) async {
    var body = jsonEncode({
      'branch_id': branchId,
      'category_desc': catData.name,
      'rmargin': catData.retailMg,
      'wmargin': catData.wholesaleMg,
      'show_in_pos': catData.showInPos,
    });
    try {
      var res =
          await http.post(Uri.parse(addCategoryUrl), body: body, headers: {});
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Category Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getCategories();
        Get.off(() => const CategoriesPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Category!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  editCategory(Category catData) async {
    var body = {
      'category_id': catToEdit.value,
      'category_desc': catData.name,
      'rmargin': catData.retailMg,
      'wmargin': catData.wholesaleMg,
      'show_in_pos': catData.showInPos,
    };
    try {
      var res = await http.patch(Uri.parse(updateCatUrl),
        body: body, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },);
      debugPrint("Got response ${res.statusCode}");
      print(catToEdit.value);

      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Category Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getCategories();
        Get.off(() => const CategoriesPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update category!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterCatPaginator() {
    listPaginator(rangeList: rangeCatList, selectList: categories);
    if (rangeCatList.isEmpty) {
      showCatLoading.value = false;
      showCatData.value = false;
    } else {
      showCatLoading.value = false;
      showCatData.value = true;
    }
  }

  searchCatFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<Category> searchResult = RxList<Category>();

    for (var cat in categories) {
      List<String> catValue = searchParser(cat.name);
      for (var value in searchList) {
        if (searchResult.contains(cat) == false) {
          if (catValue.contains(value)) {
            searchResult.add(cat);
          }
        }
      }
    }
    clearCatLists();
    rangeCatList = searchResult;
    filterCatPaginator();
    update();
  }

  clearCatLists() {
    rangeCatList.clear();
    categories.clear();
    catStrs.clear();
  }

  // ---------------------------------- UoM Variables & Functions -----------------------------------------------

  RxString uoMToEdit = ''.obs;
  RxString uomDropdown = ''.obs;
  RxBool showUoMData = false.obs;
  RxBool showUoMLoading = true.obs;
  RxBool fieldsUoMRequired = false.obs;
  RxBool isUoMEdit = false.obs;
  List<String> uomStr = [];
  RxList<UoM> rangeUomList = RxList<UoM>();
  RxList<UoM> uoms = RxList<UoM>();

  getUoMs() async {
    clearUomLists();
    try {
      final response = await http.get(Uri.parse('$getUoMsUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          UoM um = UoM(
              id: item['uom_id'],
              name: item['uom_description'],
              uomCode: item['uom_code']);
          uoms.add(um);
          if (!uomStr.contains(item['uom_description'])) {
            uomStr.add(item['uom_description']);
          }
        }
        uomStr.add(uomDropdown.value);
        filterUoMPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load Units of Measurement!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addUoM(UoM uomData) async {
    var body = jsonEncode({
      'branch_id': branchId,
      'uom_description': uomData.name,
      'uom_code': uomData.uomCode
    });
    try {
      var res =
          await http.post(Uri.parse(addUoMUrl), body: body, headers: headers);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Unit of Measurement Added!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getUoMs();
        Get.off(() => const UoMsPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Unit of Measurement!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  editUOM(UoM uomData) async {
    var body = {
      'uom-id': uoMToEdit.value,
      'uom_description': uomData.name,
      'uom_code': uomData.uomCode
    };


    try {
      var res = await http.patch(Uri.parse(updateUomUrl),
        body: body, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },);
      debugPrint("Got response ${res.statusCode}");
      // debugPrint(res.body);
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Unit of Measurement Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getUoMs();
        Get.off(() => const UoMsPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update Unit of Measurement!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterUoMPaginator() {
    listPaginator(rangeList: rangeUomList, selectList: uoms);
    if (rangeUomList.isEmpty) {
      showUoMLoading.value = false;
      showUoMData.value = false;
    } else {
      showUoMLoading.value = false;
      showUoMData.value = true;
    }
  }

  searchUomFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<UoM> searchResult = RxList<UoM>();

    for (var um in uoms) {
      List<String> umValue = searchParser(um.name);
      for (var value in searchList) {
        if (searchResult.contains(um) == false) {
          if (umValue.contains(value)) {
            searchResult.add(um);
          }
        }
      }
    }

    clearUomLists();
    rangeUomList = searchResult;
    filterUoMPaginator();
    update();
  }

  clearUomLists() {
    rangeUomList.clear();
    uoms.clear();
    uomStr.clear();
  }

  // ---------------------------------- Product Variables & Functions -----------------------------------------------

  RxBool showProdData = false.obs;
  RxBool showProdLoading = true.obs;
  RxBool fieldsProdRequired = false.obs;
  RxBool isProdEdit = false.obs;
  RxString prodToEdit = ''.obs;
  RxList<Product> products = RxList<Product>();
  RxList<Product> rangeProdList = RxList<Product>();

  getProducts() async {
    clearProdLists();
    try {
      final response = await http.get(Uri.parse('$getProductsUrl/$branchId'),
          headers: apiHeaders);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        for (var item in resData) {
          Product product = Product(
              cartQuantity: '1',
              id: item['location_product_id'].toString(),
              name: item['location_product_description'].toString(),
              desc: item['location_product_description'].toString(),
              code: item['location_productcode'].toString(),
              retailMg: item['location_product_sp'].toString(),
              wholesaleMg: item['location_product_sp1'].toString(),
              buyingPrice: item['location_product_sp'].toString(),
              categoryid: item['category_id'].toString(),
              uomId: item['uom_code'].toString(),
              blockingneg: item['blockneg'].toString(),
              active: item['active'].toString());
          products.add(product);
        }
        filterProdPaginator();
        update();
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load products",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  addProduct(Product prodData) async {
    var body = jsonEncode({
      'branch_id': branchId,
      'location_productcode': prodData.code,
      'location_product_description': prodData.name,
      'location_product_sp': prodData.retailMg,
      'location_product_quantity':0,
      'location_product_sp1': prodData.wholesaleMg,
      'category_id': prodData.categoryid,
      'product_bp': prodData.buyingPrice,
      'blockneg': prodData.blockingneg,
      'active': prodData.active,
      'uom_code': prodData.uomId
    });
    try {
      var res =
      await http.post(Uri.parse(addProductUrl), body: body, headers: {});
      print(res.body);
      if (res.statusCode == 201) {
        showSnackbar(
            path: Icons.check_rounded, title: "Product Added!", subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getProducts();
        Get.off(() => const ProductsPage());
        return;
      }
      return;
    } catch (error) {
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to add Product!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  editProduct(Product prodData) async {
    var body = {
      'branch_id': branchId,
      'location_productcode': prodData.code,
      'location_product_description': prodData.name,
      'location_product_sp': prodData.retailMg,
      'location_product_quantity':0,
      'location_product_sp1': prodData.wholesaleMg,
      'category_id': prodData.categoryid,
      'product_bp': prodData.buyingPrice,
      'blockneg': prodData.blockingneg,
      'active': prodData.active,
      'uom_code': prodData.uomId
    };

    try {
      var res = await http.patch(Uri.parse(updateProdUrl),
        body: body, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },);
      debugPrint("Got response ${res.statusCode}");
      // debugPrint(res.body);
      if (res.statusCode == 200) {
        showSnackbar(
            path: Icons.check_rounded,
            title: "Unit of Measurement Updated!",
            subtitle: "");
        await Future.delayed(const Duration(seconds: 2));
        getUoMs();
        Get.off(() => const UoMsPage());
        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to update Unit of Measurement!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  filterProdPaginator() {
    listPaginator(rangeList: rangeProdList, selectList: products);
    if (rangeProdList.isEmpty) {
      showProdLoading.value = false;
      showProdData.value = false;
    } else {
      showProdLoading.value = false;
      showProdData.value = true;
    }
  }

  searchProdFilter(String searchItem) async {
    List<String> searchList = searchParser(searchItem);
    RxList<Product> searchResult = RxList<Product>();

    for (var prod in products) {
      List<String> prodValue = searchParser(prod.name);
      for (var value in searchList) {
        if (searchResult.contains(prod) == false) {
          if (prodValue.contains(value)) {
            searchResult.add(prod);
          }
        }
      }
    }

    clearProdLists();
    rangeProdList = searchResult;
    filterProdPaginator();
    update();
  }

  clearProdLists() {
    rangeProdList.clear();
    products.clear();
  }
}
