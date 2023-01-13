// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String pageTitle = '';
  SupplierPayment supPayData = SupplierPayment(
      id: 1, supplierId: 1, quantity: 1, unitPrice: 1, total: 1);
  final supplierCtrl = Get.put(SupplierCtrl());
  TextEditingController quantityctrl = TextEditingController();
  TextEditingController unitpricectrl = TextEditingController();
  TextEditingController totalctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _SuppPayFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    quantityctrl.dispose();
    unitpricectrl.dispose();
    totalctrl.dispose();
    super.dispose();
  }

  setForm() {
    if (supplierCtrl.isSupPayEdit.value) {
      pageTitle = 'Edit Supplier Payment';
      quantityctrl.text = supplierCtrl.oneSupPayments
          .where((element) => element.id == (supplierCtrl.supPayToEdit.value))
          .first
          .quantity
          .toString();
      unitpricectrl.text = supplierCtrl.oneSupPayments
          .where((element) => element.id == (supplierCtrl.supPayToEdit.value))
          .first
          .unitPrice
          .toString();
      totalctrl.text = supplierCtrl.oneSupPayments
          .where((element) => element.id == (supplierCtrl.supPayToEdit.value))
          .first
          .total
          .toString();
    } else {
      pageTitle = 'Add Supplier Payment';
      quantityctrl.clear();
      unitpricectrl.clear();
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
                              label: 'Quantity',
                              require: true,
                              controller: quantityctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the quantity';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Unit Price(in Kes)',
                              require: true,
                              controller: unitpricectrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the unit price';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Total Cost(in Kes)',
                              require: true,
                              controller: totalctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total cost';
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
                        supPayData.quantity = int.parse(quantityctrl.text);
                        supPayData.unitPrice = int.parse(quantityctrl.text);
                        supPayData.total = int.parse(quantityctrl.text);
                        supPayData.supplierId = supplierCtrl.paysToShow.value;

                        if (supplierCtrl.isSupPayEdit.value) {
                          supplierCtrl.editSupPay(supPayData);
                        } else {
                          supplierCtrl.addSupPay(supPayData);
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
