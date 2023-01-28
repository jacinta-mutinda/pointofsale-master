// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/pos/checkout/checkout.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';

final posCtrl = Get.put(PoSCtrl());

class Categories extends StatefulWidget {
  static const routeName = "/categories";
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int index = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => posCtrl.posCats.isEmpty
            ? noItemsWidget(
                label:
                    'No categories to display! Please add categories in Inventory')
            : Container(
                padding: const EdgeInsets.all(15),
                child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 7.0,
                    mainAxisSpacing: 8.0,
                    children: getCats()))));
  }

  List<Widget> getCats() {
    List<Widget> cats = [];
    for (var category in posCtrl.posCats) {
      cats.add(GestureDetector(
          onTap: () {
            posCtrl.selectedCat.value = category.id;
            posCtrl.setNextTab();
            DefaultTabController.of(context)!.animateTo(1);
          },
          child: Obx(() => Card(
              color:
                  category.id == posCtrl.selectedCat.value ? kDarkGreen : kGrey,
              elevation: 7.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      color: category.id == posCtrl.selectedCat.value
                          ? kLightGreen
                          : Colors.black,
                      size: 64,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: category.id == posCtrl.selectedCat.value
                                  ? kLightGreen
                                  : Colors.black),
                        ))
                  ])))));
    }
    return cats;
  }
}

class Products extends StatefulWidget {
  static const routeName = "/products";
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(15),
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 8.0,
                children: getProds())));
  }

  List<Widget> getProds() {
    List<Widget> prods = [];
    for (var product in posCtrl.catProds) {
      prods.add(GestureDetector(
          onTap: () {
            posCtrl.addToCart(product.id);
          },
          onDoubleTap: () {
            posCtrl.prodToChange = product;
            Get.dialog(const CartItem());
          },
          onLongPress: () {
            posCtrl.prodToChange = product;
            Get.dialog(const CartItem());
          },
          child: Obx(() => Card(
              color: posCtrl.isSelected(product.id) ? kDarkGreen : kGrey,
              elevation: 7.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket,
                      color: posCtrl.isSelected(product.id)
                          ? kLightGreen
                          : Colors.black,
                      size: 64,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                product.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: posCtrl.isSelected(product.id)
                                        ? kLightGreen
                                        : Colors.black),
                              )),
                          Text(
                            'Kes.${product.retailMg}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: posCtrl.isSelected(product.id)
                                    ? kLightGreen
                                    : Colors.black),
                          )
                        ]))
                  ])))));
    }
    return prods;
  }
}

class Cart extends StatefulWidget {
  static const routeName = "/cart";
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final bool _isCheckoutLoading = false;
  final bool _isCancelLoading = false;

  @override
  void initState() {
    super.initState();
    posCtrl.createCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text('All Cart Items', style: kSubTitle)),
            Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var cart = posCtrl.cartSale.cart;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Card(
                          color: kGrey,
                          elevation: 7.0,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            ListTile(
                                title: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(cart[index].name,
                                        style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreen))),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Quantity: ${cart[index].quantity}',
                                          style: kBlackTxt),
                                      Text(
                                          'Unit Price: Kes.${formatAmount((cart[index].unitPrice).toString())}',
                                          style: kBlackTxt)
                                    ]),
                                trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            posCtrl.selectedItem = cart[index];
                                            posCtrl.removeCartItem();
                                          },
                                          child: Container(
                                              width: 25,
                                              height: 25,
                                              margin: const EdgeInsets.only(
                                                  bottom: 7),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kPrimaryRed),
                                              child: const Icon(
                                                  Icons.remove_circle,
                                                  size: 15,
                                                  color: Colors.white))),
                                      Text(
                                        'Total: Kes.${formatAmount((cart[index].total).toString())}',
                                        style: kTotalTxt,
                                      )
                                    ])),
                          ])),
                    );
                  },
                  itemCount: posCtrl.cartSale.cart.length),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 25),
                child: Divider(
                  color: kDarkGreen,
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: kPageTitle),
                      Obx(() => Text(
                          'Kes.${formatAmount((posCtrl.cartSale.total).toString())}',
                          style: kPageTitle))
                    ])),
            const Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Divider(
                  color: kDarkGreen,
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              priBtn(
                  label: 'Checkout',
                  txtColour: Colors.white,
                  bgColour: kDarkGreen,
                  isLoading: _isCheckoutLoading,
                  function: () {
                    Get.to(const CheckoutPage());
                  }),
              priBtn(
                  label: 'Cancel',
                  txtColour: Colors.white,
                  bgColour: kPrimaryRed,
                  isLoading: _isCancelLoading,
                  function: () {
                    posCtrl.cancelSale();
                    DefaultTabController.of(context)!.animateTo(0);
                  })
            ])
          ])),
    );
  }
}

class CartItem extends StatefulWidget {
  static const routeName = "/CartItem";

  const CartItem({Key? key}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool _isLoading = false;
  final bool _isRemoveLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitCtrl = TextEditingController();
  TextEditingController quantityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    unitCtrl.text = posCtrl.prodToChange.retailMg;
    quantityCtrl.text = '1';
  }

  @override
  void dispose() {
    unitCtrl.dispose();
    quantityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Edit Cart Item'),
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Form(
            key: _formKey,
            child: Column(children: <Widget>[
              formField(
                  label: 'Unit Price (in Kes)',
                  require: true,
                  controller: unitCtrl,
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the unit price';
                    }
                    return null;
                  }),
              formField(
                  label: 'Quantity',
                  require: true,
                  controller: quantityCtrl,
                  type: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  }),
              priBtn(
                bgColour: kDarkGreen,
                txtColour: Colors.white,
                label: 'Add To Cart',
                isLoading: _isLoading,
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    posCtrl.prodToChange.cartQuantity = quantityCtrl.text;
                    posCtrl.prodToChange.retailMg = unitCtrl.text;
                    posCtrl.addChangedItem();
                    Get.back();
                  }
                },
              )
            ]))
      ])
    ]);
  }
}

class PoSPage extends StatefulWidget {
  static const routeName = "/PoSPage";

  const PoSPage({Key? key}) : super(key: key);

  @override
  _PoSPageState createState() => _PoSPageState();
}

class _PoSPageState extends State<PoSPage> {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    posCtrl.getCategories();
    posCtrl.getProducts();
    _tabController = DefaultTabController.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    posCtrl.clearLists();
    _tabController?.animateTo(0);
    posCtrl.cartSale.cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 3,
            toolbarHeight: 80,
            backgroundColor: kDarkGreen,
            title: const Text('Point of Sale', style: kAppBarTitle),
            centerTitle: true,
            leading: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 25,
                  color: Colors.white,
                )),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: kLightGreen,
              indicatorWeight: 3.0,
              tabs: <Widget>[
                Tab(child: tabitem(label: "Categories", path: Icons.category)),
                Tab(
                    child: tabitem(
                        label: "Products", path: Icons.shopping_basket)),
                Tab(child: tabitem(label: "Cart", path: Icons.shopping_cart))
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[Categories(), Products(), Cart()],
          ),
        ));
  }
}

Widget tabitem({label, path, Color? bgcolor, int? number}) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          path,
          size: 14,
          color: Colors.white,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              label,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kCreamTheme),
            )),
        label == 'Cart'
            ? Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: kPrimaryRed),
                child: Obx(() => Text(
                      posCtrl.cartLength.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )))
            : const SizedBox(),
      ]);
}
