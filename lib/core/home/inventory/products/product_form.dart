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
      id: 1,
      name: '',
      desc: '',
      categoryid: 1,
      uomId: 1,
      code: 1,
      buyingPrice: 1,
      blockingneg: true,
      active: true,
      retailMg: 100,
      wholesaleMg: 50);
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
      namectrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .name;
      descctrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .desc;
      retailMgctrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .retailMg
          .toString();

      wholesaleMgctrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .wholesaleMg
          .toString();
      codectrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .code
          .toString();
      buyingPricectrl.text = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .buyingPrice
          .toString();
      invtCtrl.catDropdown.value = invtCtrl.categories
          .where((element) =>
              element.id ==
              (invtCtrl.products
                  .where((element) => element.id == (invtCtrl.prodToEdit.value))
                  .first
                  .categoryid))
          .first
          .name;
      invtCtrl.uomDropdown.value = invtCtrl.uoms
          .where((element) =>
              element.id ==
              (invtCtrl.products
                  .where((element) => element.id == (invtCtrl.prodToEdit.value))
                  .first
                  .uomId))
          .first
          .name;
      blockingnegValue = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .blockingneg;
      activeValue = invtCtrl.products
          .where((element) => element.id == (invtCtrl.prodToEdit.value))
          .first
          .active;
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
                            descFormField(
                              label: 'Description',
                              controller: descctrl,
                            ),
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
                                label: 'Product Code',
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
                                label: 'Retail Margin (in Kes)',
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
                                label: 'Wholesale Margin (in Kes)',
                                require: true,
                                controller: wholesaleMgctrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the wholesale margin';
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
                                    return 'Please enter the buying prce';
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
                        prodData.desc = descctrl.text;
                        prodData.code = int.parse(codectrl.text);
                        prodData.retailMg = int.parse(retailMgctrl.text);
                        prodData.wholesaleMg = int.parse(wholesaleMgctrl.text);
                        prodData.blockingneg = blockingnegValue;
                        prodData.active = activeValue;

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
