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
      id: '',
      name: '',
      item: '',
      bankacc: '',
      krapin: '',
      address: '',
      cpperson: '',
      phoneno: '');
  final supplierCtrl = Get.put(SupplierCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController bankaccctrl = TextEditingController();
  TextEditingController krapinctrl = TextEditingController();
  TextEditingController addressctrl = TextEditingController();
  TextEditingController phonenoctrl = TextEditingController();
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
    phonenoctrl.dispose();
    krapinctrl.dispose();
    bankaccctrl.dispose();
    cppersonctrl.dispose();
    addressctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (supplierCtrl.isSupEdit.value) {
      pageTitle = 'Edit Supplier';
      namectrl.text = supplierCtrl.supToShow.name;
      bankaccctrl.text = supplierCtrl.supToShow.bankacc;
      cppersonctrl.text = supplierCtrl.supToShow.cpperson;

      krapinctrl.text = supplierCtrl.supToShow.krapin;
      addressctrl.text = supplierCtrl.supToShow.address;
    } else {
      pageTitle = 'Add Supplier';
      namectrl.clear();
      phonenoctrl.clear();
      bankaccctrl.clear();
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
                              require: supplierCtrl.fieldsRequired.value,
                              controller: namectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the supplier name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Bank Account Number',
                              require: supplierCtrl.fieldsRequired.value,
                              controller: bankaccctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the account number';
                                // }
                                return null;
                              }),
                          formField(
                              label: 'KRA Pin',
                              require: supplierCtrl.fieldsRequired.value,
                              controller: krapinctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return "Please enter the supplier's KRA pin";
                                // }
                                return null;
                              }),
                          formField(
                              label: 'Address',
                              require: supplierCtrl.fieldsRequired.value,
                              controller: addressctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return "Please enter the supplier's address";
                                // }
                                return null;
                              }),
                          formField(
                              label: 'Phone Number',
                              require: supplierCtrl.fieldsRequired.value,
                              controller: phonenoctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the supplier's Phone Number";
                                }
                                if (value.length != 10) {
                                  return 'Please enter a 10-digit phone number';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Conatct Person Phone Number',
                              require: supplierCtrl.fieldsRequired.value,
                              controller: cppersonctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return "Please enter the contact person's Phone Number";
                                // }
                                // if (value.length != 10) {
                                //   return 'Please enter a 10-digit phone number';
                                // }
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
                        supData.address = addressctrl.text;
                        supData.bankacc = bankaccctrl.text;
                        supData.cpperson = cppersonctrl.text;
                        supData.phoneno = phonenoctrl.text;
                        supData.krapin = krapinctrl.text;

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
