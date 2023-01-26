import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/work_period/drawer/drawer_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class DrawerPage extends StatefulWidget {
  static const routeName = "/drawer";
  const DrawerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final drawerCtrl = Get.put(DrawerCtrl());
  final ScrollController _scrollctrl = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Cash Drawer', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text('Income', style: kTitle)),
            Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                controller: _scrollctrl,
                radius: const Radius.circular(20),
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollctrl,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: DataTable(
                          headingRowColor:
                              MaterialStateColor.resolveWith((states) => kGrey),
                          dividerThickness: 3,
                          columns: const [
                            DataColumn(label: Text('Income')),
                            DataColumn(label: Text('Cash')),
                            DataColumn(label: Text('M-pesa')),
                            DataColumn(label: Text('Card')),
                            DataColumn(label: Text('On Acc.')),
                          ],
                          rows: [
                            const DataRow(cells: [
                              DataCell(Text('Sales')),
                              // DataCell(Text(drawerCtrl.saleRow.cashAmt)),
                              // DataCell(Text(drawerCtrl.saleRow.mpesaAmt)),
                              // DataCell(Text(drawerCtrl.saleRow.cardAmt)),
                              // DataCell(Text(drawerCtrl.saleRow.total.value))
                              DataCell(Text('240')),
                              DataCell(Text('20')),
                              DataCell(Text('20')),
                              DataCell(Text('200'))
                            ]),
                            const DataRow(cells: [
                              DataCell(Text('Float')),
                              // DataCell(Text(drawerCtrl.floatRow.cashAmt)),
                              // DataCell(Text(drawerCtrl.floatRow.mpesaAmt)),
                              // DataCell(Text(drawerCtrl.saleRow.cardAmt)),
                              // DataCell(Text(drawerCtrl.floatRow.total.value)),
                              DataCell(Text('240')),
                              DataCell(Text('20')),
                              DataCell(Text('20')),
                              DataCell(Text('200'))
                            ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => kLightGreen),
                                cells: const [
                                  DataCell(Text('Total')),
                                  DataCell(Text('240')),
                                  DataCell(Text('20')),
                                  DataCell(Text('20')),
                                  DataCell(Text('200')),
                                ]),
                          ],
                        )))),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Income SubTotal:'),
                const SizedBox(
                  width: 10,
                ),

                // ignore: sized_box_for_whitespace
                Container(
                  width: 100, // do it in both Container
                  child: const TextField(decoration: InputDecoration()),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text('Expenses', style: kTitle)),
            SizedBox(
              width: 550,
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: true,
                showCheckboxColumn: true,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(179, 223, 212, 212)),
                dividerThickness: 3,
                dataRowColor: MaterialStateColor.resolveWith(
                    (Set<MaterialState> states) =>
                        states.contains(MaterialState.selected)
                            ? Colors.green
                            : Colors.white),
                columns: const [
                  DataColumn(label: Text('Expenses')),
                  DataColumn(label: Text('Cash')),
                  DataColumn(label: Text('M-Pesa')),
                  DataColumn(label: Text('Card')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Stationary')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Total')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                    DataCell(Text('0')),
                  ]),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 10,
                ),
                Text('Expenses SubTotal:'),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100, // do it in both Container
                  child: TextField(decoration: InputDecoration()),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('GrandTotal:'),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(decoration: InputDecoration()),
                ),
              ],
            )
          ])),
    );
  }
}
