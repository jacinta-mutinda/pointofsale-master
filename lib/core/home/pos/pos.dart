// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

import '../../../utils/functions.dart';

final posCtrl = Get.put(PoSCtrl());
final invtCtrl = Get.put(InventoryCtrl());

class Categories extends StatefulWidget {
  static const routeName = "/categories";
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final invtCtrl = Get.put(InventoryCtrl());
  final ScrollController _scrollctrl = ScrollController();
  @override
  void initState() {
    invtCtrl.getCategories();
    super.initState();
    _scrollctrl.addListener(() {
      if (_scrollctrl.position.pixels == _scrollctrl.position.maxScrollExtent) {
        listAppender(
            rangeList: invtCtrl.rangeCatList, selectList: invtCtrl.categories);
      }
      setState(() {
        if (_scrollctrl.offset >= 400) {
        } else {}
      });
    });
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
            posCtrl.addToCatProds(category.id);
          },
          child: Obx(() => invtCtrl.showCatLoading.value
              ? loadingWidget(label: 'Loading Category ...')
              : invtCtrl.showCatData.value
                  ? Card(
                      color: posCtrl.isCatSelected(category.id)
                          ? kDarkGreen
                          : kGrey,
                      elevation: 7.0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              color: posCtrl.isCatSelected(category.id)
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
                                      color: posCtrl.isCatSelected(category.id)
                                          ? kLightGreen
                                          : Colors.black),
                                ))
                          ]))
                  : noTransactionsWidget(label: 'No Category Found'))));
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
          child: Obx(() => Card(
              color: posCtrl.isSelected(product.id) ? kDarkGreen : kGrey,
              elevation: 7.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onLongPress: () {
                        posCtrl.updateCart();
                      },
                      child: Container(
                        child: Icon(
                          Icons.shopping_basket,
                          color: posCtrl.isSelected(product.id)
                              ? kLightGreen
                              : Colors.black,
                          size: 64,
                        ),
                      ),
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
  final bool _isCreateLoading = false;
  final bool _isCheckoutLoading = false;
  final bool _isCancelLoading = false;

  final bankingCtrl = Get.put(BankingCtrl());

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController paymthdctrl = TextEditingController();
  TextEditingController amountPaidctrl = TextEditingController();
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
          child: Column(children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text('Cart', style: kTitle)),
            Obx(() => ListView.builder(
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
                                            padding: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    posCtrl.selectedCartItem
                                                        .value = cart[index].id;
                                                    posCtrl.updateCart();
                                                    Get.dialog(
                                                        const CartItem());
                                                  },
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: kDarkGreen,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text('${cart[index].quantity}',
                                                    style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black)),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    //  var id= posCtrl.catProds ;
                                                    // posCtrl.addToCart(product.id);
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    color: kDarkGreen,
                                                  ),
                                                ),
                                              ],
                                            )),
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
                itemCount: posCtrl.cartSale.cart.length)),
            const Divider(
              color: kDarkGreen,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: kPageTitle),
                      Obx(() => Text('Kes.${posCtrl.cartSale.total}',
                          style: kPageTitle))
                    ])),
            const Divider(
              color: kDarkGreen,
            ),
            Obx(() => posCtrl.showCheckoutForm.value
                ? Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Enter Checkout deatils',
                                  style: kTitle)),
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
                                      dropdownValue:
                                          posCtrl.bankAccDropdown.value,
                                      dropItems: bankingCtrl.bankAccStrs,
                                      bgcolor: kGrey,
                                      function: (String? newValue) {
                                        posCtrl.setBankAcc();
                                        setState(() {
                                          posCtrl.bankAccDropdown.value =
                                              newValue!;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          formField(
                                              label: 'Amount Paid (in Kes)',
                                              require: true,
                                              controller: amountPaidctrl,
                                              type: TextInputType.number,
                                              validator: (value) {
                                                var bal = int.parse(
                                                        amountPaidctrl.text) -
                                                    int.parse(posCtrl
                                                        .cartSale.total.value);

                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the amount paid';
                                                } else if (bal < 0) {
                                                  return 'Amount paid cannot be less than Total Sale';
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
                                              require: false,
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the reference code';
                                            }
                                            return null;
                                          })
                                      : formField(
                                          label: 'Customer Name',
                                          require: false,
                                          controller: posCtrl.customerctrl,
                                          type: TextInputType.name,
                                          readonly: true,
                                          validator: (value) {
                                            setState(() {
                                              posCtrl.customerctrl.text =
                                                  posCtrl.selectedCustAcc.value;
                                            });
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a customer Account';
                                            }
                                            return null;
                                          })),
                          priBtn(
                            bgColour: kDarkGreen,
                            txtColour: Colors.white,
                            label: 'Complete Sale',
                            isLoading: _isLoading,
                            function: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                posCtrl.checkDetData.payMthd = paymthdctrl.text;
                                if (posCtrl.isCashPay.value) {
                                  posCtrl.checkDetData.paid =
                                      amountPaidctrl.text;
                                  posCtrl.checkDetData.balance =
                                      balancectrl.text.obs;
                                } else if (posCtrl.isBankPay.value) {
                                  posCtrl.checkDetData.bankAccId =
                                      posCtrl.selectedBankId.value.toString();
                                  posCtrl.checkDetData.bankRefCode =
                                      bankrefcodectrl.text;
                                } else if (posCtrl.isMpesaPay.value) {
                                  posCtrl.checkDetData.mpesaRefCode =
                                      refcodectrl.text;
                                } else {
                                  posCtrl.checkDetData.custAccId =
                                      posCtrl.selectedCustAccId.value;
                                }
                                posCtrl.completeSale();
                              }
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          )
                        ]))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            bgColour: kLightGreen,
                            isLoading: _isCreateLoading,
                            function: () {
                              posCtrl.createBill();
                            }),
                        priBtn(
                            label: 'Cancel',
                            txtColour: Colors.white,
                            bgColour: kPrimaryRed,
                            isLoading: _isCancelLoading,
                            function: () {
                              posCtrl.cancelSale();
                            })
                      ]))
          ])),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentOption = 'credit_card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: <Widget>[
          // Payment options radio buttons
          RadioListTile(
            title: const Text('Credit Card'),
            value: 'credit_card',
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value!;
              });
            },
          ),
          RadioListTile(
            title: const Text('PayPal'),
            value: 'paypal',
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value!;
              });
            },
          ),
          RadioListTile(
            title: const Text('Apple Pay'),
            value: 'apple_pay',
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value!;
              });
            },
          ),
          // Other checkout form fields
          // ...
          // Submit button
          ElevatedButton(
            onPressed: () {
              // Send the selected payment option to the server
              // ...
            },
            child: const Text('Submit'),
          ),
        ],
      ),
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
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        posCtrl.newCartItem.quantity = quantityCtrl.text;
                        posCtrl.newCartItem.unitPrice = unitCtrl.text;
                        posCtrl.newCartItem.total =
                            (int.parse(quantityCtrl.text) *
                                    int.parse(unitCtrl.text))
                                .toString()
                                .obs;
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
                      isLoading: _isRemoveLoading,
                      function: () {
                        posCtrl.cartSale.cart
                            .where((element) =>
                                element.id == (posCtrl.selectedCartItem.value))
                            .first;
                      })
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
  final bool _isLoading = false;
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
      popupHeader(label: 'Select an account'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  color: kDarkGreen)),
                          leading: Radio(
                            activeColor: kLightGreen,
                            value: customers[index].name,
                            groupValue: posCtrl.selectedCustAcc.value,
                            onChanged: (value) {
                              setState(() {
                                posCtrl.selectedCustAcc.value = value!;
                                posCtrl.setCustAcc();
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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
