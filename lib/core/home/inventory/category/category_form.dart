// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class CategoryForm extends StatefulWidget {
  static const routeName = "/categoryForm";

  const CategoryForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  bool posValue = false;
  String pageTitle = '';
  Category catData =
      Category(id: 1, name: '', retailMg: 0, wholesaleMg: 0, showInPos: true);
  final invtCtrl = Get.put(InventoryCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController retailMgctrl = TextEditingController();
  TextEditingController wholesaleMgctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _CategoryFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    retailMgctrl.dispose();
    wholesaleMgctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (invtCtrl.isCatEdit.value) {
      pageTitle = 'Edit Category';
      namectrl.text = invtCtrl.categories
          .where((element) => element.id == (invtCtrl.catToEdit.value))
          .first
          .name;
      retailMgctrl.text = invtCtrl.categories
          .where((element) => element.id == (invtCtrl.catToEdit.value))
          .first
          .retailMg
          .toString();

      wholesaleMgctrl.text = invtCtrl.categories
          .where((element) => element.id == (invtCtrl.catToEdit.value))
          .first
          .wholesaleMg
          .toString();
    } else {
      pageTitle = 'Add Category';
      namectrl.clear();
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
                                    return 'Please enter the category name';
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
                            CheckboxListTile(
                              title: const Text('Show in Point of Sale',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      color: kDarkGreen)),
                              checkColor: kDarkGreen,
                              activeColor: kLightGreen,
                              value: posValue,
                              onChanged: (value) {
                                setState(() {
                                  posValue = value!;
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
                        catData.name = namectrl.text;
                        catData.retailMg = int.parse(retailMgctrl.text);
                        catData.wholesaleMg = int.parse(wholesaleMgctrl.text);
                        catData.showInPos = posValue;

                        if (invtCtrl.isCatEdit.value) {
                          invtCtrl.editCategory(catData);
                        } else {
                          invtCtrl.addCategory(catData);
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
