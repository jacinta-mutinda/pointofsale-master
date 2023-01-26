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
  String pageTitle = '';
  BankTransaction bankTransData = BankTransaction(
      id: 1, action: '', bankId: 1, desc: '', amount: 1, date: '2023-01-14');
  final bankingCtrl = Get.put(BankingCtrl());
  TextEditingController descctrl = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  TextEditingController datectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _BankTransFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    descctrl.dispose();
    amountctrl.dispose();
    datectrl.dispose();
    super.dispose();
  }

  setForm() {
    if (bankingCtrl.isTransEdit.value) {
      pageTitle = 'Edit Bank Transaction';
      descctrl.text = bankingCtrl.accBankTrans
          .where((element) => element.id == (bankingCtrl.transToEdit.value))
          .first
          .desc;
      bankingCtrl.accDropdown.value = bankingCtrl.bankAccounts
          .where((element) =>
              element.id ==
              (bankingCtrl.accBankTrans
                  .where((element) =>
                      element.id == (bankingCtrl.transToEdit.value))
                  .first
                  .bankId))
          .first
          .bankName;
      bankingCtrl.transTypeDropdown.value = bankingCtrl.accBankTrans
          .where((element) => element.id == (bankingCtrl.transToEdit.value))
          .first
          .action
          .toString();
      amountctrl.text = bankingCtrl.accBankTrans
          .where((element) => element.id == (bankingCtrl.transToEdit.value))
          .first
          .amount
          .toString();
      datectrl.text = bankingCtrl.accBankTrans
          .where((element) => element.id == (bankingCtrl.transToEdit.value))
          .first
          .date;
    } else {
      pageTitle = 'Add Bank Transaction';
      descctrl.clear();
      amountctrl.clear();
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
                          Obx(() => !bankingCtrl.isTransEdit.value
                              ? formDropDownField(
                                  label: 'Bank Account',
                                  dropdownValue: bankingCtrl.accDropdown.value,
                                  dropItems: bankingCtrl.bankAccStrs,
                                  bgcolor: kGrey,
                                  function: (String? newValue) {
                                    setState(() {
                                      bankingCtrl.accDropdown.value = newValue!;
                                    });
                                  })
                              : const SizedBox()),
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
                          descFormField(
                              label: 'Description', controller: descctrl),
                          dateFormField(
                              label: 'Date of Payment',
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
                        bankTransData.desc = descctrl.text;
                        bankTransData.action = bankingCtrl.transTypeDropdown.value;
                        bankTransData.bankId=bankingCtrl.transAccToShow.id as int;
                        // bankTransData.bankId = int.parse(bankingCtrl
                        //     .bankAccounts
                        //     .where((element) =>
                        //         element.bankName ==
                        //         (bankingCtrl.accDropdown.value))
                        //     .first
                        //     .id);
                        bankTransData.amount = int.parse(amountctrl.text);
                        bankTransData.date = datectrl.text;
                        print(bankTransData);

                        if (bankingCtrl.isBankEdit.value) {
                          bankingCtrl.editBankTrans(bankTransData);
                        } else {
                          bankingCtrl.addBankTrans(bankTransData);
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
