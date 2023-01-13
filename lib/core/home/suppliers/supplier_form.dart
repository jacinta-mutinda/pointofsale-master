// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SupplierForm extends StatefulWidget {
  static const routeName = "/SupplierForm";

  const SupplierForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SupplierFormState createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  String pageTitle = '';
  Supplier supData = Supplier(
      id: 1,
      name: '',
      item: '',
      bankacc: 1,
      krapin: 1,
      address: '',
      cpperson: 1);
  final supplierCtrl = Get.put(SupplierCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController bankaccctrl = TextEditingController();
  TextEditingController itemctrl = TextEditingController();
  TextEditingController krapinctrl = TextEditingController();
  TextEditingController addressctrl = TextEditingController();
  TextEditingController cppersonctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _SupplierFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    krapinctrl.dispose();
    bankaccctrl.dispose();
    itemctrl.dispose();
    cppersonctrl.dispose();
    addressctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (supplierCtrl.isSupEdit.value) {
      pageTitle = 'Edit Supplier';
      namectrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .name;
      bankaccctrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .bankacc
          .toString();
      cppersonctrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .cpperson
          .toString();
      itemctrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .item;
      krapinctrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .krapin
          .toString();
      addressctrl.text = supplierCtrl.suppliers
          .where((element) => element.id == (supplierCtrl.supToEdit.value))
          .first
          .address;
    } else {
      pageTitle = 'Add Supplier';
      namectrl.clear();
      bankaccctrl.clear();
      itemctrl.clear();
      cppersonctrl.clear();
      addressctrl.clear();
      krapinctrl.clear();
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
                              label: 'Supplier Name',
                              require: true,
                              controller: namectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the supplier name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Item',
                              require: true,
                              controller: itemctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the item supplied';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Bank Account Number',
                              require: true,
                              controller: bankaccctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the account number';
                                }
                                return null;
                              }),
                          formField(
                              label: 'KRA Pin',
                              require: true,
                              controller: krapinctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the supplier's KRA pin";
                                }
                                return null;
                              }),
                          formField(
                              label: 'Address',
                              require: true,
                              controller: itemctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the supplier's address";
                                }
                                return null;
                              }),
                          formField(
                              label: 'Contact Person Phone Number',
                              require: true,
                              controller: cppersonctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Contact Person Phone Number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a 10-digit phone number';
                                }
                                return null;
                              }),
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
                        supData.name = namectrl.text;
                        supData.item = itemctrl.text;
                        supData.address = addressctrl.text;
                        supData.bankacc = int.parse(bankaccctrl.text);
                        supData.cpperson = int.parse(cppersonctrl.text);
                        supData.krapin = int.parse(krapinctrl.text);

                        if (supplierCtrl.isSupEdit.value) {
                          supplierCtrl.editSupplier(supData);
                        } else {
                          supplierCtrl.addSupplier(supData);
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
