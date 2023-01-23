// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  Expense expData =
      Expense(id: '', date: '', payto: '', ref: '', desc: '', amount: '', branch_id: '');
  final transCtrl = Get.put(TransactionCtrl());
  TextEditingController paytoctrl = TextEditingController();
  TextEditingController refctrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  TextEditingController datectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _ExpenseFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    datectrl.dispose();
    paytoctrl.dispose();
    amountctrl.dispose();
    refctrl.dispose();
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
                          dateFormField(
                              label: 'Date of Transaction',
                              controller: datectrl,
                              showDate: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

                                  setState(() {
                                    datectrl.text = formattedDate;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the date of payment';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Paid To',
                              require: true,
                              controller: paytoctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the account paid to';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Referenec Code',
                              require: true,
                              controller: refctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the reference code';
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
                    label: 'Add Expense',
                    isLoading: _isLoading,
                    function: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        expData.payto = paytoctrl.text;
                        expData.date = datectrl.text;
                        expData.ref = refctrl.text;
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
