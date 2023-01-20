import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/transactions/suppay_form.dart';
import 'package:nawiri/core/home/suppliers/supplier_form.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class SupplierPayments extends StatefulWidget {
  static const routeName = "/suppays";
  const SupplierPayments({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SupplierPaymentsState createState() => _SupplierPaymentsState();
}

class _SupplierPaymentsState extends State<SupplierPayments> {
  bool _isLoading = false;
  final supplierCtrl = Get.put(SupplierCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
          pageTitle: supplierCtrl.supPageName.value, actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Supplier Details', style: kTitle),
                          smallPriBtn(
                              label: 'Edit Supplier',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.to(const SupplierForm());
                              })
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  labelSpan(
                      mainLabel: 'Name',
                      childLabel: supplierCtrl.supToShow.name),
                  labelSpan(
                      mainLabel: 'Item Supplied',
                      childLabel: supplierCtrl.supToShow.item),
                  labelSpan(
                      mainLabel: 'Bank Account No',
                      childLabel: supplierCtrl.supToShow.bankacc.toString()),
                  labelSpan(
                      mainLabel: 'KRA Pin',
                      childLabel: supplierCtrl.supToShow.krapin.toString()),
                  labelSpan(
                      mainLabel: 'Address',
                      childLabel: supplierCtrl.supToShow.address),
                  labelSpan(
                      mainLabel: 'Contact Person Phone',
                      childLabel: supplierCtrl.supToShow.cpperson.toString()),
                ]),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Supplier Payments', style: kTitle),
                          smallPriBtn(
                              label: 'Add Payment',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                supplierCtrl.isSupPayEdit.value = false;
                                Get.to(const SuppPayForm());
                              })
                        ])),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var supPays = supplierCtrl.oneSupPayments;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                                color: kGrey,
                                elevation: 7.0,
                                child: ListTile(
                                  leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kLightGreen),
                                      child: const Icon(Icons.sticky_note_2,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                          '${supPays[index].quantity} ${supplierCtrl.suppliers.where((element) => element.id == (supplierCtrl.paysToShow.value)).first.item}',
                                          style: kCardTitle)),
                                  subtitle: Text('Kes.${supPays[index].total}',
                                      style: kCardTitle),
                                  trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkGreen),
                                      child: const Icon(Icons.edit,
                                          size: 25, color: Colors.white)),
                                  onTap: () {
                                    supplierCtrl.isSupPayEdit.value = true;
                                    supplierCtrl.supPayToEdit.value =
                                        supPays[index].id;
                                    Get.to(() => const SuppPayForm());
                                  },
                                )));
                      },
                      itemCount: supplierCtrl.oneSupPayments.length),
                )
              ]))),
    );
  }
}
