// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_models.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class UomForm extends StatefulWidget {
  static const routeName = "/uomForm";

  const UomForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UomFormState createState() => _UomFormState();
}

class _UomFormState extends State<UomForm> {
  String pageTitle = '';
  UoM uomData = UoM(id: '', name: '', uomCode: '');
  final invtCtrl = Get.put(InventoryCtrl());
  TextEditingController namectrl = TextEditingController();
  TextEditingController uomCodeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  _UomFormState();

  @override
  void initState() {
    super.initState();
    setForm();
  }

  @override
  void dispose() {
    namectrl.dispose();
    uomCodeCtrl.dispose();
    super.dispose();
  }

  setForm() {
    if (invtCtrl.isUoMEdit.value) {
      pageTitle = 'Edit Unit';
      namectrl.text = invtCtrl.uoms
          .where((element) => element.id == (invtCtrl.uoMToEdit.value))
          .first
          .name;
      uomCodeCtrl.text = invtCtrl.uoms
          .where((element) => element.id == (invtCtrl.uoMToEdit.value))
          .first
          .uomCode;
    } else {
      pageTitle = 'Add Unit';
      namectrl.clear();
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
                              label: 'Name',
                              require: invtCtrl.fieldsUoMRequired.value,
                              controller: namectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Unit of Measurement name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'UoM Code (short form)',
                              require: invtCtrl.fieldsUoMRequired.value,
                              controller: uomCodeCtrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Unit of Measurement code';
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
                        uomData.name = namectrl.text;

                        if (invtCtrl.isUoMEdit.value) {
                          invtCtrl.editUOM(uomData);
                        } else {
                          invtCtrl.addUoM(uomData);
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
