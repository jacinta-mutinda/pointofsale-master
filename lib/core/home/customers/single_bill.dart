import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SingleBill extends StatefulWidget {
  static const routeName = "/SingleBill";

  const SingleBill({Key? key}) : super(key: key);

  @override
  _SingleBillState createState() => _SingleBillState();
}

class _SingleBillState extends State<SingleBill> {
  final customerCtrl = Get.put(CustomerCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Bill Date: ${customerCtrl.singleBill.date}'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: 'Payment Method',
            childLabel: customerCtrl.singleBill.payMethod),
        labelSpan(
            mainLabel: 'Reference Code',
            childLabel: customerCtrl.singleBill.refCode),
        labelSpan(
            mainLabel: 'Status',
            childLabel: customerCtrl.singleBill.paid ? 'Paid' : 'Unpaid'),
        labelSpan(
            mainLabel: 'Total',
            childLabel: 'Kes${customerCtrl.singleBill.total}'),
      ])
    ]);
  }
}
