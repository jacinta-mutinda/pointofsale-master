import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_form.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/customers/custrec_form.dart';
import 'package:nawiri/core/home/pos/pos.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class CustomerBills extends StatefulWidget {
  static const routeName = "/customerbills";
  const CustomerBills({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerBillsState createState() => _CustomerBillsState();
}

class _CustomerBillsState extends State<CustomerBills> {
  final customerCtrl = Get.put(CustomerCtrl());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
          pageTitle: customerCtrl.custPageName.value, actions: <Widget>[]),
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
                  labelSpan(
                      mainLabel: 'Bank Account No',
                      childLabel: customerCtrl.custToShow.bankacc),
                  labelSpan(
                      mainLabel: 'KRA Pin',
                      childLabel: customerCtrl.custToShow.krapin),
                  labelSpan(
                      mainLabel: 'Address',
                      childLabel: customerCtrl.custToShow.address),
                  labelSpan(
                      mainLabel: 'Contact Person Phone',
                      childLabel: customerCtrl.custToShow.cpperson),
                  labelSpan(
                      mainLabel: 'Running Balance',
                      childLabel: 'Kes.${customerCtrl.custToShow.runningBal}'),
                  labelSpan(
                      mainLabel: 'Total Credit',
                      childLabel: 'Kes.${customerCtrl.custToShow.totalCredit}'),
                  labelSpan(
                      mainLabel: 'Credit Limit',
                      childLabel: 'Kes.${customerCtrl.custToShow.creditlimit}'),
                ]),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Customer Receipts', style: kTitle),
                          smallPriBtn(
                              label: 'Add Payment',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.to(const CustomerReceipt());
                              })
                        ])),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const SizedBox();
                        // return list of customer receipts

                        // var custBills = customerCtrl.oneCustSales;
                        // return Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 3),
                        //     child: Card(
                        //         color: kGrey,
                        //         elevation: 7.0,
                        //         child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             children: [
                        //               ListTile(
                        //                 leading: Container(
                        //                     width: 40,
                        //                     height: 40,
                        //                     decoration: BoxDecoration(
                        //                         shape: BoxShape.circle,
                        //                         color: (custBills[index].paid
                        //                             ? kLightGreen
                        //                             : kPrimaryRed)),
                        //                     child: const Icon(Icons.receipt,
                        //                         size: 20, color: Colors.white)),
                        //                 title: Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         vertical: 5),
                        //                     child: Text(custBills[index].date,
                        //                         style: kCardTitle)),
                        //                 subtitle: Text(
                        //                     custBills[index].total.toString(),
                        //                     style: kCardTitle),
                        //                 trailing: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.end,
                        //                     children: [
                        //                       Padding(
                        //                           padding: const EdgeInsets
                        //                               .symmetric(vertical: 5),
                        //                           child: Text(
                        //                               custBills[index].paid
                        //                                   ? 'Paid'
                        //                                   : 'Unpaid',
                        //                               style: TextStyle(
                        //                                   fontFamily: 'Nunito',
                        //                                   fontSize: 12,
                        //                                   fontWeight:
                        //                                       FontWeight.w400,
                        //                                   color: custBills[
                        //                                               index]
                        //                                           .paid
                        //                                       ? kDarkGreen
                        //                                       : kPrimaryRed))),
                        //                       Text(
                        //                         'Kes.${custBills[index].total}',
                        //                         style: kCardTitle,
                        //                       )
                        //                     ]),
                        //                 onTap: () async {
                        //                   customerCtrl.singleBillId.value =
                        //                       custBills[index].id;
                        //                   customerCtrl.getSingleBill();
                        //                 },
                        //               ),
                        //               Obx(() => !custBills[index].paid
                        //                   ? priBtn(
                        //                       label: 'Clear Bill',
                        //                       txtColour: Colors.white,
                        //                       bgColour: kDarkGreen,
                        //                       isLoading: _isLoading,
                        //                       function: () {
                        //                         Get.to(const PoSPage());
                        //                       })
                        //                   : const SizedBox())
                        //             ])));
                      },
                      itemCount: customerCtrl.oneCustSales.length),
                ),
              ]))),
    );
  }
}
