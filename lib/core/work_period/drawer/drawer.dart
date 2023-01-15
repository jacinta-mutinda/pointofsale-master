import 'package:flutter/material.dart';
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
            SizedBox(
              width: 600,
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
                  DataColumn(label: Text('Income')),
                  DataColumn(label: Text('Cash')),
                  DataColumn(label: Text('Mpesa')),
                  DataColumn(label: Text('Card')),
                  DataColumn(label: Text('On Acc.')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Shift sales')),
                    DataCell(Text('200')),
                    DataCell(Text('2000')),
                    DataCell(Text('200')),
                    DataCell(Text('20')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Float')),
                    DataCell(Text('240')),
                    DataCell(Text('2000')),
                    DataCell(Text('20')),
                    DataCell(Text('200')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Total')),
                    DataCell(Text('240')),
                    DataCell(Text('2000')),
                    DataCell(Text('20')),
                    DataCell(Text('200')),
                  ]),
                ],
              ),
            ),
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
