import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_form.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/customers/custrec_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class CustomerReceipts extends StatefulWidget {
  static const routeName = "/CustomerReceipts";
  const CustomerReceipts({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerReceiptsState createState() => _CustomerReceiptsState();
}

class _CustomerReceiptsState extends State<CustomerReceipts> {
  final customerCtrl = Get.put(CustomerCtrl());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Customer Receipts', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Customer Details', style: kTitle),
                          smallPriBtn(
                              label: 'Edit Customer',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.to(const CustomerForm());
                              })
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  labelSpan(
                      mainLabel: 'Name',
                      childLabel: customerCtrl.custToShow.name),
                  labelSpan(
                      mainLabel: 'Phone Number',
                      childLabel: customerCtrl.custToShow.phoneno),
                  // labelSpan(
                  //     mainLabel: 'Bank Account No',
                  //     childLabel: customerCtrl.custToShow.bankacc),
                  // labelSpan(
                  //     mainLabel: 'KRA Pin',
                  //     childLabel: customerCtrl.custToShow.krapin),
                  // labelSpan(
                  //     mainLabel: 'Address',
                  //     childLabel: customerCtrl.custToShow.address),
                  labelSpan(
                      mainLabel: 'Contact Person Phone',
                      childLabel: customerCtrl.custToShow.cpperson),
                  labelSpan(
                      mainLabel: 'Account Balance',
                      childLabel: 'Kes.${customerCtrl.custToShow.runningBal}'),
                  // labelSpan(
                  //     mainLabel: 'Total Credit',
                  //     childLabel: 'Kes.${customerCtrl.custToShow.totalCredit}'),
                  // labelSpan(
                  //     mainLabel: 'Credit Limit',
                  //     childLabel: 'Kes.${customerCtrl.custToShow.creditlimit}'),
                ]),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Customer Payments', style: kTitle),
                          smallPriBtn(
                              label: 'Add Payment',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.to(const CustomerReceipt());
                              })
                        ])),
                Obx(() => customerCtrl.showRecLoading.value
                    ? loadingWidget(label: 'Loading Customer Payments ...')
                    : customerCtrl.showRecData.value
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
                                                      ' ${customerCtrl.rangeCustReceipts.length} ',
                                                  style: kNeonTxt,
                                                ),
                                                const TextSpan(
                                                  text: ' of ',
                                                  style: kBlackTxt,
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${customerCtrl.custReceipts.length} ',
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
                                        var custReceipts =
                                            customerCtrl.rangeCustReceipts;
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
                                                          custReceipts[index]
                                                              .date,
                                                          style: kCardTitle)),
                                                  subtitle: Text(
                                                      'Kes${custReceipts[index].amount}',
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
                                                    customerCtrl.singleRec =
                                                        custReceipts[index];
                                                    Get.dialog(
                                                        const SingleReceipt());
                                                  },
                                                )));
                                      },
                                      itemCount: customerCtrl
                                          .rangeCustReceipts.length),
                                ),
                              ])
                        : noItemsWidget(label: 'No Receipts Found'))
              ]))),
    );
  }
}

class SingleReceipt extends StatefulWidget {
  static const routeName = "/SingleReceipt";

  const SingleReceipt({Key? key}) : super(key: key);

  @override
  _SingleReceiptState createState() => _SingleReceiptState();
}

class _SingleReceiptState extends State<SingleReceipt> {
  final customerCtrl = Get.put(CustomerCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(
          label:
              'Payment Date: ${customerCtrl.singleRec.date.substring(0, 10)}'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: 'Transaction Type Method',
            childLabel: customerCtrl.singleRec.transtype),
        labelSpan(
            mainLabel: 'Reference Code',
            childLabel: customerCtrl.singleRec.ref),
        labelSpan(
            mainLabel: 'Comment', childLabel: customerCtrl.singleRec.comment),
        labelSpan(
            mainLabel: 'Discount',
            childLabel: 'Kes${customerCtrl.singleRec.discount}'),
        labelSpan(
            mainLabel: 'Account Balance',
            childLabel: 'Kes.${customerCtrl.custToShow.runningBal}'),
        labelSpan(
            mainLabel: 'Total',
            childLabel: 'Kes${customerCtrl.singleRec.amount}'),
      ])
    ]);
  }
}
