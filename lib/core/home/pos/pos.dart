import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

final posCtrl = Get.put(PoSCtrl());
final invtCtrl = Get.put(InventoryCtrl());

class Categories extends StatefulWidget {
  static const routeName = "/categories";
  const Categories({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
                children: getCats())));
  }

  List<Widget> getCats() {
    List<Widget> cats = [];
    for (var category in invtCtrl.categories) {
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
                      size: 72,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          category.name,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 18,
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
  // ignore: library_private_types_in_public_api
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
    List<Widget> cats = [];
    for (var product in posCtrl.catProds) {
      cats.add(GestureDetector(
          onTap: () {
            posCtrl.addToCart(product.id);
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
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: posCtrl.isSelected(product.id)
                                        ? kLightGreen
                                        : Colors.black),
                              )),
                          Text(
                            'Kes.${product.retailMg}',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: posCtrl.isSelected(product.id)
                                    ? kLightGreen
                                    : Colors.black),
                          )
                        ]))
                  ])))));
    }
    return cats;
  }
}

class Cart extends StatefulWidget {
  static const routeName = "/cart";
  const Cart({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isCreateLoading = false;
  bool _isCheckoutLoading = false;
  bool _isCancelLoading = false;

  final bankingCtrl = Get.put(BankingCtrl());

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController paymthdctrl = TextEditingController();
  TextEditingController amountPaidctrl = TextEditingController();
  TextEditingController customerctrl = TextEditingController();
  TextEditingController balancectrl = TextEditingController();
  TextEditingController refcodectrl = TextEditingController();
  TextEditingController bankAccctrl = TextEditingController();
  TextEditingController bankrefcodectrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    posCtrl.createCart();
  }

  @override
  void dispose() {
    paymthdctrl.dispose();
    amountPaidctrl.dispose();
    customerctrl.dispose();
    balancectrl.dispose();
    refcodectrl.dispose();
    bankAccctrl.dispose();
    bankrefcodectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text('Cart', style: kSubTitle)),
            Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var cart = posCtrl.cartSale.cart;
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Card(
                            color: kGrey,
                            elevation: 7.0,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListTile(
                                    leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kDarkGreen),
                                        child: const Icon(Icons.edit,
                                            size: 20, color: Colors.white)),
                                    title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(cart[index].name,
                                            style: kCardTitle)),
                                    subtitle: Text(
                                        'Unit Price: Kes.${cart[index].unitPrice}',
                                        style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)),
                                    trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                  'Item No:${cart[index].quantity}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black))),
                                          Text(
                                            'Kes.${cart[index].total}',
                                            style: kCardTitle,
                                          )
                                        ]),
                                    onTap: () async {
                                      posCtrl.selectedCartItem.value =
                                          cart[index].id;
                                      posCtrl.setCartItem();
                                      Get.dialog(const CartItem());
                                    },
                                  )
                                ])));
                  },
                  itemCount: posCtrl.cartSale.cart.length),
            ),
            const Divider(
              color: kDarkGreen,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: kPageTitle),
                      Text('Kes.${posCtrl.cartSale.total}', style: kPageTitle)
                    ])),
            const Divider(
              color: kDarkGreen,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              priBtn(
                  label: 'Checkout',
                  txtColour: Colors.white,
                  bgColour: kDarkGreen,
                  isLoading: _isCheckoutLoading,
                  function: () {
                    posCtrl.checkout();
                  }),
              priBtn(
                  label: 'Create Bill',
                  txtColour: Colors.white,
                  bgColour: kDarkGreen,
                  isLoading: _isCreateLoading,
                  function: () {
                    posCtrl.createBill();
                  }),
              priBtn(
                  label: 'Cancel',
                  txtColour: Colors.white,
                  bgColour: kDarkGreen,
                  isLoading: _isCancelLoading,
                  function: () {
                    posCtrl.cancelSale();
                  })
            ]),
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Enter Checkout deatils', style: kTitle)),
                      formDropDownField(
                          label: 'Payment Method',
                          dropdownValue: posCtrl.payMthdDropdown.value,
                          dropItems: posCtrl.payMthdsStrs,
                          bgcolor: kGrey,
                          function: (String? newValue) {
                            setState(() {
                              posCtrl.payMthdDropdown.value = newValue!;
                              posCtrl.setCheckoutForm();
                            });
                          }),
                      Obx(() => posCtrl.isBankPay.value
                          ? Column(children: [
                              formDropDownField(
                                  label: 'Bank Account',
                                  dropdownValue: posCtrl.bankAccDropdown.value,
                                  dropItems: bankingCtrl.bankAccStrs,
                                  bgcolor: kGrey,
                                  function: (String? newValue) {
                                    posCtrl.setBankAcc();
                                    setState(() {
                                      posCtrl.bankAccDropdown.value = newValue!;
                                    });
                                  }),
                              formField(
                                  label: 'Transaction Reference Code',
                                  require: true,
                                  controller: bankrefcodectrl,
                                  type: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the reference code';
                                    }
                                    return null;
                                  })
                            ])
                          : posCtrl.isCashPay.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      formField(
                                          label: 'Amount Paid (in Kes)',
                                          require: true,
                                          controller: amountPaidctrl,
                                          type: TextInputType.number,
                                          validator: (value) {
                                            var bal =
                                                int.parse(amountPaidctrl.text) -
                                                    posCtrl.cartSale.total;

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the amount paid';
                                            } else if (bal < 0) {
                                              return 'Please enter the amount paid';
                                            } else {
                                              setState(() {
                                                balancectrl.text =
                                                    bal.toString();
                                              });
                                            }
                                            return null;
                                          }),
                                      formField(
                                          label: 'Balance (in Kes)',
                                          require: true,
                                          controller: balancectrl,
                                          readonly: true,
                                          type: TextInputType.number,
                                          validator: (value) {
                                            return null;
                                          }),
                                    ])
                              : posCtrl.isMpesaPay.value
                                  ? formField(
                                      label: 'M-pesa Reference Code',
                                      require: true,
                                      controller: refcodectrl,
                                      type: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the reference code';
                                        }
                                        return null;
                                      })
                                  : formField(
                                      label: 'Customer Name',
                                      require: true,
                                      controller: customerctrl,
                                      type: TextInputType.name,
                                      validator: (value) {
                                        setState(() {
                                          customerctrl.text =
                                              posCtrl.selectedCustAcc.value;
                                        });
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a customer Account';
                                        }
                                        return null;
                                      })),
                      Row(children: [
                        priBtn(
                          bgColour: kDarkGreen,
                          txtColour: Colors.white,
                          label: 'Checkout',
                          isLoading: _isLoading,
                          function: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              posCtrl.checkDetData.payMthd = paymthdctrl.text;
                              posCtrl.checkDetData.paid =
                                  int.parse(amountPaidctrl.text);
                              posCtrl.checkDetData.balance =
                                  int.parse(balancectrl.text);
                              posCtrl.checkDetData.bankAccId =
                                  posCtrl.selectedBankId.value;
                              posCtrl.checkDetData.custAccId =
                                  posCtrl.selectedCustAccId.value;
                              posCtrl.checkDetData.bankRefCode =
                                  bankrefcodectrl.text;
                              posCtrl.checkDetData.mpesaRefCode =
                                  refcodectrl.text;
                              posCtrl.completeSale();
                            }
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                        priBtn(
                            label: 'Remove Item',
                            txtColour: Colors.white,
                            bgColour: kPrimaryRed,
                            isLoading: _isLoading,
                            function: () {
                              posCtrl.cartSale.cart
                                  .where((element) =>
                                      element.id ==
                                      (posCtrl.selectedCartItem.value))
                                  .first;
                            })
                      ])
                    ]))
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitCtrl = TextEditingController();
  TextEditingController quantityCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    posCtrl.setCartItem();
    unitCtrl.text = posCtrl.selectedItem.unitPrice.toString();
    quantityCtrl.text = posCtrl.selectedItem.quantity.toString();
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
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  Row(children: [
                    priBtn(
                      bgColour: kDarkGreen,
                      txtColour: Colors.white,
                      label: 'Update Item',
                      isLoading: _isLoading,
                      function: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          posCtrl.selectedItem.quantity =
                              int.parse(quantityCtrl.text);
                          posCtrl.selectedItem.unitPrice =
                              int.parse(unitCtrl.text);
                          posCtrl.selectedItem.total =
                              int.parse(quantityCtrl.text) *
                                  int.parse(unitCtrl.text);
                          posCtrl.updateCart();
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    priBtn(
                        label: 'Remove Item',
                        txtColour: Colors.white,
                        bgColour: kPrimaryRed,
                        isLoading: _isLoading,
                        function: () {
                          posCtrl.cartSale.cart
                              .where((element) =>
                                  element.id ==
                                  (posCtrl.selectedCartItem.value))
                              .first;
                        })
                  ])
                ]))
      ])
    ]);
  }
}

class CustomerList extends StatefulWidget {
  static const routeName = "/_CustomerList";

  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchNamectrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchNamectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Select a Customer Account'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Form(
            key: _formKey,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  formField(
                      label: 'Enter Customer Name',
                      require: true,
                      controller: searchNamectrl,
                      type: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a search name';
                        }
                        return null;
                      }),
                  Row(children: [
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          posCtrl.filterCustomers(searchNamectrl.text);
                        }
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(left: 10, top: 35),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: kLightGreen),
                          child: const Icon(Icons.search,
                              size: 20, color: Colors.white)),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              posCtrl.resetCustomers();
                            }
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(left: 10, top: 35),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent),
                              child: const Icon(Icons.refresh,
                                  size: 20, color: Colors.white)),
                        )),
                    smallPriBtn(
                        label: 'Done',
                        txtColour: Colors.white,
                        bgColour: kDarkGreen,
                        isLoading: _isLoading,
                        function: () {
                          if (posCtrl.selectedCustAcc.value == '') {
                            posCtrl.isCustSet.value = false;
                          } else {
                            posCtrl.setCustAcc();
                          }
                        })
                  ])
                ])),
        Obx(() => !posCtrl.isCustSet.value
            ? const Text('Please select a customer Account',
                style: TextStyle(
                    color: kPrimaryRed,
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500))
            : const SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Obx(
            () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var customers = posCtrl.custList;
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: ListTile(
                          title: Text(customers[index].name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  color: kDarkGreen)),
                          leading: Radio(
                            value: customers[index].name,
                            groupValue: posCtrl.selectedCustAcc.value,
                            onChanged: (value) {
                              setState(() {
                                posCtrl.selectedCustAcc.value = value!;
                              });
                            },
                          )));
                },
                itemCount: posCtrl.custList.length),
          ),
        )
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      posCtrl.selectedProds.length.toString(),
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
