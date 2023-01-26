// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class BankTransForm extends StatefulWidget {
  static const routeName = "/BankTransForm";

  const BankTransForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankTransFormState createState() => _BankTransFormState();
}

class _BankTransFormState extends State<BankTransForm> {
  BankTransaction transData = BankTransaction(
      id: '',
      refCode: '',
      bankId: '',
      action: '',
      desc: '',
      branchId: '',
      amount: '');
  final bankingCtrl = Get.put(BankingCtrl());
  TextEditingController descctrl = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  TextEditingController refcodectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _BankTransFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descctrl.dispose();
    amountctrl.dispose();
    refcodectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: secAppBar(pageTitle: 'Add Bank Transaction'),
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
                          formDropDownField(
                              label: 'Transaction Type',
                              dropdownValue:
                                  bankingCtrl.transTypeDropdown.value,
                              dropItems: bankingCtrl.accActionStrs,
                              bgcolor: kGrey,
                              function: (String? newValue) {
                                setState(() {
                                  bankingCtrl.transTypeDropdown.value =
                                      newValue!;
                                });
                              }),
                          formField(
                              label: 'Reference Code',
                              require: true,
                              controller: refcodectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the transaction reference code';
                                }
                                return null;
                              }),
                          descFormField(
                              label: 'Description', controller: descctrl),
                          formField(
                              label: 'Amount(in Kes)',
                              require: true,
                              controller: amountctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the transaction amount';
                                }
                                return null;
                              }),
                        ],
                      )),
                  priBtn(
                    bgColour: kDarkGreen,
                    txtColour: Colors.white,
                    label: 'Add Transaction',
                    isLoading: _isLoading,
                    function: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        transData.amount = amountctrl.text;
                        transData.desc = descctrl.text;
                        transData.refCode = refcodectrl.text;
                        bankingCtrl.addBankTrans(transData);
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
