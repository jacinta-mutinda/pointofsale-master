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
  String pageTitle = '';
  Product prodData = Product(
      id: 1,
      name: '',
      desc: '',
      categoryid: 1,
      uomId: 1,
      retailMg: 100,
      wholesaleMg: 50);
  final invtCtrl = Get.put(InventoryCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
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
                          // formField(
                          // label: 'Retail Margin',
                          // require: true,
                          // controller: phonectrl,
                          // type: TextInputType.number,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your Phone Number';
                          //   }
                          //   if (value.length != 10) {
                          //     return 'Please enter your 10-digit phone number';
                          //   }
                          //   return null;
                          // }),
                        ],
                      )),
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