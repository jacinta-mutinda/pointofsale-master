// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class CustomerForm extends StatefulWidget {
  static const routeName = "/CustomerForm";

  const CustomerForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  String pageTitle = '';
  Customer custData = Customer(
      id: 1,
      name: '',
      phoneno: 1,
      bankacc: 1,
      krapin: 1,
      address: '',
      cpperson: 1,
      creditlimit: 1);
  final customerCtrl = Get.put(CustomerCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController bankaccctrl = TextEditingController();
  TextEditingController itemctrl = TextEditingController();
  TextEditingController krapinctrl = TextEditingController();
  TextEditingController addressctrl = TextEditingController();
  TextEditingController cppersonctrl = TextEditingController();
  TextEditingController creditctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _CustomerFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    krapinctrl.dispose();
    phonectrl.dispose();
    bankaccctrl.dispose();
    itemctrl.dispose();
    cppersonctrl.dispose();
    addressctrl.dispose();
    creditctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (customerCtrl.isCustEdit.value) {
      pageTitle = 'Edit customer';
      namectrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .name;
      bankaccctrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .bankacc
          .toString();
      cppersonctrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .cpperson
          .toString();
      phonectrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .phoneno
          .toString();
      krapinctrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .krapin
          .toString();
      creditctrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .creditlimit
          .toString();
      addressctrl.text = customerCtrl.customers
          .where((element) => element.id == (customerCtrl.custToEdit.value))
          .first
          .address;
    } else {
      pageTitle = 'Add customer';
      namectrl.clear();
      bankaccctrl.clear();
      phonectrl.clear();
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
                              label: 'Customer Name',
                              require: true,
                              controller: namectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the customer name';
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
                                  return "Please enter the customer's KRA pin";
                                }
                                return null;
                              }),
                          formField(
                              label: 'Phone Number',
                              require: true,
                              controller: phonectrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Phone Number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a 10-digit phone number';
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
                          formField(
                              label: 'Credit Limit (in Kes)',
                              require: true,
                              controller: creditctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the customer's credit limit";
                                }
                                return null;
                              })
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
                        custData.name = namectrl.text;
                        custData.phoneno = int.parse(phonectrl.text);
                        custData.address = addressctrl.text;
                        custData.bankacc = int.parse(bankaccctrl.text);
                        custData.cpperson = int.parse(cppersonctrl.text);
                        custData.krapin = int.parse(krapinctrl.text);
                        custData.creditlimit = int.parse(creditctrl.text);

                        if (customerCtrl.isCustEdit.value) {
                          customerCtrl.editCustomer(custData);
                        } else {
                          customerCtrl.addCustomer(custData);
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
