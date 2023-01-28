// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ProductForm extends StatefulWidget {
  static const routeName = "/productForm";

  const ProductForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  bool blockingnegValue = false;
  bool activeValue = false;
  String pageTitle = '';
  Product prodData = Product(
      id: '',
      cartQuantity: '',
      name: '',
      desc: '',
      categoryid: '',
      uomId: '',
      code: '',
      buyingPrice: '',
      blockingneg: '',
      active: '',
      retailMg: '',
      wholesaleMg: '');
  final invtCtrl = Get.put(InventoryCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
  TextEditingController retailMgctrl = TextEditingController();
  TextEditingController wholesaleMgctrl = TextEditingController();
  TextEditingController buyingPricectrl = TextEditingController();
  TextEditingController codectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _ProductFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    descctrl.dispose();
    retailMgctrl.dispose();
    wholesaleMgctrl.dispose();
    buyingPricectrl.dispose();
    codectrl.dispose();
    super.dispose();
  }

  setForm() {
    if (invtCtrl.isProdEdit.value) {
      pageTitle = 'Edit Product';
      Product selectedProd = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first;
      namectrl.text = selectedProd.name;
      descctrl.text = selectedProd.desc;
      retailMgctrl.text = selectedProd.retailMg;
      wholesaleMgctrl.text = selectedProd.wholesaleMg;
      codectrl.text = selectedProd.code;
      buyingPricectrl.text = selectedProd.buyingPrice;
      invtCtrl.catDropdown.value = '';
      // invtCtrl.catDropdown.value = invtCtrl.categories
      //     .where((element) => element.id == (selectedProd.categoryid))
      //     .first
      //     .name;
      // invtCtrl.uomDropdown.value = invtCtrl.uoms
      //     .where((element) => element.uomCode == (selectedProd.uomId))
      //     .first
      //     .name;
      invtCtrl.uomDropdown.value = '';
      var blockNeg = selectedProd.blockingneg;
      if (blockNeg == 'Y') {
        blockingnegValue = true;
      } else {
        blockingnegValue = false;
      }
      var activeVal = selectedProd.active;
      if (activeVal == 'Y') {
        activeValue = true;
      } else {
        activeValue = false;
      }
    } else {
      pageTitle = 'Add Product';
      namectrl.clear();
      descctrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: secAppBar(pageTitle: pageTitle),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 25, left: 30, right: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            formField(
                                label: 'Name',
                                require: true,
                                controller: namectrl,
                                type: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Product name';
                                  }
                                  return null;
                                }),

                            formDropDownField(
                                label: 'Category',
                                dropdownValue: invtCtrl.catDropdown.value,
                                dropItems: invtCtrl.catStrs,
                                bgcolor: kGrey,
                                function: (String? newValue) {
                                  setState(() {
                                    invtCtrl.catDropdown.value = newValue!;
                                  });
                                }),
                            formDropDownField(
                                label: 'Unit of Measurement',
                                dropdownValue: invtCtrl.uomDropdown.value,
                                dropItems: invtCtrl.uomStr,
                                bgcolor: kGrey,
                                function: (String? newValue) {
                                  setState(() {
                                    invtCtrl.uomDropdown.value = newValue!;
                                  });
                                }),
                            formField(
                                label: 'Scan Code',
                                require: true,
                                controller: codectrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the product code';
                                  }
                                  return null;
                                }),
                            formField(
                                label: 'Buying Price (in Kes)',
                                require: true,
                                controller: buyingPricectrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the buying price';
                                  }
                                  return null;
                                }),
                            formField(
                                label: 'Retail Margin (in %)',
                                require: true,
                                controller: retailMgctrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the retail margin';
                                  }
                                  return null;
                                }),
                            formField(
                                label: 'Wholesale Margin (in %)',
                                require: true,
                                controller: wholesaleMgctrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the wholesale margin';
                                  }
                                  return null;
                                }),

                            CheckboxListTile(
                              title: const Text('Block Negative',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      color: kDarkGreen)),
                              checkColor: kDarkGreen,
                              activeColor: kLightGreen,
                              value: blockingnegValue,
                              onChanged: (value) {
                                setState(() {
                                  blockingnegValue = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text('Activate Product',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      color: kDarkGreen)),
                              checkColor: kDarkGreen,
                              activeColor: kLightGreen,
                              value: activeValue,
                              onChanged: (value) {
                                setState(() {
                                  activeValue = value!;
                                });
                              },
                            )
                          ])),
                  priBtn(
                    bgColour: kDarkGreen,
                    txtColour: Colors.white,
                    label: pageTitle,
                    isLoading: _isLoading,
                    function: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        prodData.name = namectrl.text;
                        prodData.code = codectrl.text;
                        prodData.buyingPrice=buyingPricectrl.text;
                        prodData.categoryid = invtCtrl.categories
                            .where((element) =>
                        element.name == (invtCtrl.catDropdown.value))
                            .first
                            .id;
                        prodData.uomId = invtCtrl.uoms
                            .where((element) =>
                        element.name == (invtCtrl.uomDropdown.value))
                            .first
                            .id;
                        prodData.retailMg = retailMgctrl.text;
                        prodData.wholesaleMg = wholesaleMgctrl.text;
                        if (blockingnegValue) {
                          prodData.blockingneg = 'Y';
                        } else {
                          prodData.blockingneg = 'N';
                        }
                        if (activeValue) {
                          prodData.active = 'Y';
                        } else {
                          prodData.active = 'N';
                        }
                        if (invtCtrl.isProdEdit.value) {
                          invtCtrl.editProduct(prodData);
                        } else {
                          invtCtrl.addProduct(prodData);
                        }
                      }
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  )
                ])));
  }
}
