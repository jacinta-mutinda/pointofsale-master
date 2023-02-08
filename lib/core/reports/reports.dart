import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/reports/report_ctrl.dart';
import 'package:nawiri/core/reports/sales_by_staff/salesbystaff.dart';
import 'package:nawiri/core/reports/shift_sales/shift_sales.dart';
import 'package:nawiri/core/reports/stock_sales/stock_sales.dart';
import 'package:nawiri/core/reports/supplier_transaction/supplier_transaction.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

final reportCtrl = Get.put(ReportCtrl());

class ReportPage extends StatefulWidget {
  static const routeName = "/market";
  const ReportPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: mainAppBar(pageTitle: 'Reports'),
        drawer: mainDrawer(),
        body: SingleChildScrollView(


padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
child: SizedBox(
height: double.maxFinite,
child: navMenu(navItems: [
navItem(
iconPath: Icons.shopping_basket,
label: 'Stock Sales',
goTo: const StockSalesReport()),
navItem(
iconPath: Icons.people,
label: 'Sales by Staff',
goTo: const SalesByStaffReport()),
navItem(
iconPath: Icons.lock_clock,
label: 'Shift Sales',
goTo: const ShiftSalesReport()),
navItem(
iconPath: Icons.local_shipping,
label: 'Supplier Transaction',
goTo: const SupplierTransactionReport()),
])),
));
}
}
