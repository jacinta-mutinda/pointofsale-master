// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/transactions/transactions_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ExpenseForm extends StatefulWidget {
  static const routeName = "/ExpenseForm";

  const ExpenseForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  String pageTitle = '';
  Expense expData = Expense(id: '', mode: '', type: '', desc: '', amount: '');
  final transCtrl = Get.put(TransactionCtrl());
  TextEditingController modectrl = TextEditingController();
  TextEditingController typectrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _ExpenseFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    modectrl.dispose();
    amountctrl.dispose();
    typectrl.dispose();
    descctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: secAppBar(pageTitle: 'Add Expense'),
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
                              label: 'Mode of Transaction',
                              dropdownValue: transCtrl.modeDropDown.value,
                              dropItems: transCtrl.expModeStr,
                              bgcolor: kGrey,
                              function: (String? newValue) {
                                setState(() {
                                  transCtrl.modeDropDown.value = newValue!;
                                });
                              }),
                          formField(
                              label: 'Type',
                              require: true,
                              controller: typectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the type of expense spent';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Amount (in Kes)',
                              require: true,
                              controller: amountctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the amount spent";
                                }
                                return null;
                              }),
                          descFormField(
                              label: 'Desription', controller: descctrl)
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
                        expData.mode = modectrl.text;
                        expData.type = typectrl.text;
                        expData.desc = descctrl.text;
                        expData.amount = amountctrl.text;

                        transCtrl.addExpense(expData);
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
