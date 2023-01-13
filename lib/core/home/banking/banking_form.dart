// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class BankAccForm extends StatefulWidget {
  static const routeName = "/BankAccForm";

  const BankAccForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankAccFormState createState() => _BankAccFormState();
}

class _BankAccFormState extends State<BankAccForm> {
  String pageTitle = '';
  BankAccount bankAccData = BankAccount(
      id: 1,
      bankName: '',
      accno: 1,
      branchName: '',
      cpperson: 1,
      currentTotal: 1);
  final bankingCtrl = Get.put(BankingCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController accnoctrl = TextEditingController();
  TextEditingController branchctrl = TextEditingController();
  TextEditingController cppersonctrl = TextEditingController();
  TextEditingController totalctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _BankAccFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    accnoctrl.dispose();
    branchctrl.dispose();
    cppersonctrl.dispose();
    totalctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (bankingCtrl.isBankEdit.value) {
      pageTitle = 'Edit Bank Account';
      namectrl.text = bankingCtrl.bankAccounts
          .where((element) => element.id == (bankingCtrl.bankToEdit.value))
          .first
          .bankName;
      accnoctrl.text = bankingCtrl.bankAccounts
          .where((element) => element.id == (bankingCtrl.bankToEdit.value))
          .first
          .accno
          .toString();
      cppersonctrl.text = bankingCtrl.bankAccounts
          .where((element) => element.id == (bankingCtrl.bankToEdit.value))
          .first
          .cpperson
          .toString();
      branchctrl.text = bankingCtrl.bankAccounts
          .where((element) => element.id == (bankingCtrl.bankToEdit.value))
          .first
          .branchName;
      totalctrl.text = bankingCtrl.bankAccounts
          .where((element) => element.id == (bankingCtrl.bankToEdit.value))
          .first
          .currentTotal
          .toString();
    } else {
      pageTitle = 'Add Bank Account';
      namectrl.clear();
      accnoctrl.clear();
      branchctrl.clear();
      cppersonctrl.clear();
      totalctrl.clear();
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
                              label: 'Bank Name',
                              require: true,
                              controller: namectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the bank name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Branch Name',
                              require: true,
                              controller: branchctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the branch name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Account Number',
                              require: true,
                              controller: accnoctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the account number';
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
                              label: 'Current Account Balance (in Kes)',
                              require: true,
                              controller: totalctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the current Bank Balance';
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
                        bankAccData.bankName = namectrl.text;
                        bankAccData.branchName = branchctrl.text;
                        bankAccData.accno = int.parse(accnoctrl.text);
                        bankAccData.cpperson = int.parse(cppersonctrl.text);
                        bankAccData.currentTotal = int.parse(totalctrl.text);

                        if (bankingCtrl.isBankEdit.value) {
                          bankingCtrl.editBankAcc(bankAccData);
                        } else {
                          bankingCtrl.addBankAcc(bankAccData);
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
