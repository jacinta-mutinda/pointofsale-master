import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/reports/report_ctrl.dart';
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
            padding: const EdgeInsets.all(15),
            child: SizedBox(
                height: double.maxFinite,
                child: navMenu(navItems: [
                  navItemFunc(
                      iconPath: Icons.shopping_basket, label: 'Stock Sales'),
                  navItemFunc(iconPath: Icons.people, label: 'Sales by Staff'),
                  navItemFunc(iconPath: Icons.lock_clock, label: 'Shift Sales'),
                  navItemFunc(
                      iconPath: Icons.local_shipping,
                      label: 'Supplier Transactions'),
                ]))));
  }
}

Widget navItemFunc({required iconPath, required label}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
          leading: Icon(iconPath, color: Colors.white, size: 22),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
            size: 22,
          ),
          title: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito')),
          tileColor: kDarkGreen,
          textColor: Colors.white,
          selectedTileColor: kNeonGreen,
          onTap: () {
            reportCtrl.setReport(label);
          }));
}
