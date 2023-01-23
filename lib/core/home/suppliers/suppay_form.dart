// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/home/home_models.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SuppPayForm extends StatefulWidget {
  static const routeName = "/SuppPayForm";

  const SuppPayForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SuppPayFormState createState() => _SuppPayFormState();
}

class _SuppPayFormState extends State<SuppPayForm> {
  SupplierPayment supPayData = SupplierPayment(
      id: '',
      supId: '',
      date: '',
      transtype: '',
      discount: '',
      ref: '',
      comment: '',
      amount: '');
  final supplierCtrl = Get.put(SupplierCtrl());
  TextEditingController discountctrl = TextEditingController();
  TextEditingController transtypectrl = TextEditingController();
  TextEditingController refctrl = TextEditingController();
  TextEditingController commentctrl = TextEditingController();
  TextEditingController amountctrl = TextEditingController();
  TextEditingController datectrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _SuppPayFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    discountctrl.dispose();
    datectrl.dispose();
    transtypectrl.dispose();
    amountctrl.dispose();
    refctrl.dispose();
    commentctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: secAppBar(pageTitle: 'Add Supplier Payment'),
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
                              dropdownValue: supplierCtrl.transtyeDrop.value,
                              dropItems: supplierCtrl.transtypes,
                              bgcolor: kGrey,
                              function: (String? newValue) {
                                setState(() {
                                  supplierCtrl.transtyeDrop.value = newValue!;
                                });
                              }),
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
                              label: 'Discount (in Kes)',
                              require: true,
                              controller: discountctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the discount given';
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
                              label: 'Comment', controller: commentctrl)
                        ],
                      )),
                  priBtn(
                    bgColour: kDarkGreen,
                    txtColour: Colors.white,
                    label: 'Add Customer Payment',
                    isLoading: _isLoading,
                    function: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        supPayData.transtype = transtypectrl.text;
                        supPayData.date = datectrl.text;
                        supPayData.ref = refctrl.text;
                        supPayData.comment = commentctrl.text;
                        supPayData.amount = amountctrl.text;
                        supPayData.discount = discountctrl.text.toString();

                        supplierCtrl.addSupPay(supPayData);
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
