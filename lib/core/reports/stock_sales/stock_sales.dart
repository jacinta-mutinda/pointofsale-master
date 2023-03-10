import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nawiri/core/reports/reports.dart';
import 'package:nawiri/core/work_period/drawer/drawer_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class StockSalesReport extends StatefulWidget {
  static const routeName = "/drawer";
  const StockSalesReport({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockSalesReportState createState() => _StockSalesReportState();
}

class _StockSalesReportState extends State<StockSalesReport> {
  bool _isLoading = false;
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final suppliertransactionCtrl = Get.put(SupplierTransactionReportCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.dispose();
  }
  List<DataRow> apiRows = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: mainAppBar(pageTitle: 'Reports'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Enter Filter Dates', style: kTitle)),
              Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      smallDateField(
                          label: 'Date',
                          controller: startDateCtrl,
                          showDate: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                startDateCtrl.text = formattedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the start date';
                            }
                            return null;
                          }),
                      smallDateField(
                          label: 'End Date',
                          controller: endDateCtrl,
                          showDate: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                endDateCtrl.text = formattedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the end date';
                            }
                            return null;
                          }),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            reportCtrl.filterReport();
                          }
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(left: 10, top: 35),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kLightGreen),
                            child: const Icon(Icons.filter_alt,
                                size: 20, color: Colors.white)),
                      )
                    ],
                  )),
              const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('Supplier Transaction', style: kTitle)),
               FutureBuilder<List>(
               // future:getSupplierTransactionReports(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List myList = snapshot.data!;
            print('FFFFFFFFFFFFFFFFFFFF');
            print(myList.runtimeType);
            print(myList);
            print('FFFFFFFFFFFFFFFFFFFF');
          
            return Column(
              children: [
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
                            DataColumn(label: Text('Supplier')),
                            DataColumn(label: Text('Product')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows:  myList
                            .map((saleRow) =>
                            DataRow(cells: [
                              DataCell(Text("${saleRow['transaction_ref']}")),
                               DataCell(Text("${saleRow['transaction_ref']}")),
                               DataCell(Text("${saleRow['transaction_amount']}")),
                             DataCell(Text("${saleRow['transaction_comment']}"))
                          
                            ]
                            )
                            ).toList()
                            ),
                
  
   
                    ),
                    Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: priBtn(
                      label: 'Download',
                      txtColour: Colors.white,
                      bgColour: kDarkGreen,
                      isLoading: _isLoading,
                      function: () {}))
              ],
            );
  }
   return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('This may take some time..')
              ],
            ),
          );
  })
                ]
            )
            ));
  }
 

Widget smallDateField(
    {required label,
    required controller,
    required void Function()? showDate,
    required final String? Function(String?) validator}) {
  return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: kDarkGreen)),
              const TextSpan(
                text: '*',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: kPrimaryRed),
              ),
            ]))),
        SizedBox(
          height: 50,
          child: TextFormField(
            cursorColor: kDarkGreen,
            controller: controller,
            validator: validator,
            readOnly: true,
            onTap: showDate,
            style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.black),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              suffix: Icon(
                Icons.calendar_today,
                color: kDarkGreen,
                size: 14,
              ),
            ),
          ),
        )
      ]));
}

 
}