import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/billings/billings_ctrl.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SingleUserBill extends StatefulWidget {
  static const routeName = "/SingleUserBill";

  const SingleUserBill({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SingleUserBillState createState() => _SingleUserBillState();
}

class _SingleUserBillState extends State<SingleUserBill> {
  final billingsCtrl = Get.put(BillingsCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Payment Details'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: billingsCtrl.singleBill.paid ? 'Receipt ' : 'Invoice ',
            childLabel: billingsCtrl.singleBill.name),
        labelSpan(mainLabel: 'Date', childLabel: billingsCtrl.singleBill.date),
        labelSpan(
            mainLabel: 'Status',
            childLabel: billingsCtrl.singleBill.paid ? 'Paid' : 'Unpaid'),
        labelSpan(
            mainLabel: 'Amount',
            childLabel: 'Kes${billingsCtrl.singleBill.amount}'),
      ])
    ]);
  }
}
