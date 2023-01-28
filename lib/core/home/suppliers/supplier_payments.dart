import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/home/suppliers/suppay_form.dart';
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
      appBar: backAppBar(pageTitle: 'Suppliers', actions: <Widget>[]),
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
                      mainLabel: 'Running balance',
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
                                Get.to(const SuppPayForm());
                              })
                        ])),
                Obx(() => supplierCtrl.showPayLoading.value
                    ? loadingWidget(label: 'Loading Supplier Payments ...')
                    : supplierCtrl.showPayData.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, right: 5),
                                          child: Obx(() => RichText(
                                                  text: TextSpan(children: [
                                                const TextSpan(
                                                  text: 'Showing ',
                                                  style: kBlackTxt,
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${supplierCtrl.ranegSupPayments.length} ',
                                                  style: kNeonTxt,
                                                ),
                                                const TextSpan(
                                                  text: ' of ',
                                                  style: kBlackTxt,
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${supplierCtrl.supPayments.length} ',
                                                  style: kDarkGreenTxt,
                                                ),
                                                const TextSpan(
                                                  text: ' payments',
                                                  style: kBlackTxt,
                                                )
                                              ]))))
                                    ]),
                                Obx(
                                  () => ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var supPayments =
                                            supplierCtrl.ranegSupPayments;
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Card(
                                                color: kGrey,
                                                elevation: 7.0,
                                                child: ListTile(
                                                  leading: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kLightGreen),
                                                      child: const Icon(
                                                          Icons.person,
                                                          size: 20,
                                                          color: Colors.white)),
                                                  title: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                          supPayments[index]
                                                              .date,
                                                          style: kCardTitle)),
                                                  subtitle: Text(
                                                      'Kes${supPayments[index].amount}',
                                                      style: kCardTitle),
                                                  trailing: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kDarkGreen),
                                                      child: const Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          size: 25,
                                                          color: Colors.white)),
                                                  onTap: () async {
                                                    supplierCtrl.singleSupPay =
                                                        supPayments[index];
                                                    Get.dialog(
                                                        const SingleSupPayment());
                                                  },
                                                )));
                                      },
                                      itemCount:
                                          supplierCtrl.ranegSupPayments.length),
                                ),
                              ])
                        : noItemsWidget(label: 'No Receipts Found'))
              ]))),
    );
  }
}

class SingleSupPayment extends StatefulWidget {
  static const routeName = "/SingleSupPayment";

  const SingleSupPayment({Key? key}) : super(key: key);

  @override
  _SingleSupPaymentState createState() => _SingleSupPaymentState();
}

class _SingleSupPaymentState extends State<SingleSupPayment> {
  final supplierCtrl = Get.put(SupplierCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(
          label:
              'Payment Date: ${supplierCtrl.singleSupPay.date.substring(0, 10)}'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: 'Transaction Type Method',
            childLabel: supplierCtrl.singleSupPay.transtype),
        labelSpan(
            mainLabel: 'Reference Code',
            childLabel: supplierCtrl.singleSupPay.ref),
        labelSpan(
            mainLabel: 'Comment',
            childLabel: supplierCtrl.singleSupPay.comment),
        labelSpan(
            mainLabel: 'Discount',
            childLabel: 'Kes${supplierCtrl.singleSupPay.discount}'),
        labelSpan(
            mainLabel: 'Total',
            childLabel: 'Kes${supplierCtrl.singleSupPay.amount}'),
      ])
    ]);
  }
}
