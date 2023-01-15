import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/reports/single_report.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ReportCtrl extends GetxController {
  RxString reportTitle = ''.obs;
  RxBool isStockSale = false.obs;
  RxBool isByStaff = false.obs;
  RxBool isShiftSale = false.obs;
  RxBool isSupTrans = false.obs;

  RxList<bool> pageBools = RxList<bool>();
  RxList<DataColumn> cols = RxList<DataColumn>();
  RxList<DataRow> rows = RxList<DataRow>();

  @override
  void onInit() {
    super.onInit();
    pageBools.add(isStockSale.value);
    pageBools.add(isByStaff.value);
    pageBools.add(isShiftSale.value);
    pageBools.add(isSupTrans.value);
  }

  setReport(String reportType) {
    if (reportType == 'Stock Sales') {
      isStockSale.value = true;
      isByStaff.value = false;
      isShiftSale.value = false;
      isSupTrans.value = false;
      cols.value = const [
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Amount')),
      ];
      rows.value = const [
        DataRow(cells: [
          DataCell(Text('Product 01')),
          DataCell(Text('5')),
          DataCell(Text('20')),
          DataCell(Text('200'))
        ]),
        DataRow(cells: [
          DataCell(Text('Product 02')),
          DataCell(Text('5')),
          DataCell(Text('20')),
          DataCell(Text('200'))
        ]),
      ];
    } else if (reportType == 'Sales by Staff') {
      isStockSale.value = false;
      isByStaff.value = true;
      isShiftSale.value = false;
      isSupTrans.value = false;
      cols.value = const [
        DataColumn(label: Text('Staff')),
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Amount')),
      ];
      rows.value = const [
        DataRow(cells: [
          DataCell(Text('Staff 01')),
          DataCell(Text('Product 01')),
          DataCell(Text('28/12/2022')),
          DataCell(Text('200'))
        ]),
        DataRow(cells: [
          DataCell(Text('Staff 02')),
          DataCell(Text('Product 02')),
          DataCell(Text('12/01/2023')),
          DataCell(Text('200'))
        ]),
      ];
    } else if (reportType == 'Shift Sales') {
      isStockSale.value = false;
      isByStaff.value = false;
      isShiftSale.value = true;
      isSupTrans.value = false;
      cols.value = const [
        DataColumn(label: Text('Desc.')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Opening')),
        DataColumn(label: Text('Closing')),
      ];
      rows.value = const [
        DataRow(cells: [
          DataCell(Text('ShiftA')),
          DataCell(Text('12/01/23')),
          DataCell(Text('200')),
          DataCell(Text('800'))
        ]),
      ];
    } else {
      isStockSale.value = false;
      isByStaff.value = false;
      isShiftSale.value = false;
      isSupTrans.value = true;
      cols.value = const [
        DataColumn(label: Text('Supplier')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Status')),
      ];
      rows.value = const [];
    }
    reportTitle.value = reportType;
    Get.to(const SingleReport());
  }

  filterReport({String start = '', String end = ''}) {
    showSnackbar(title: 'Report FIltered', subtitle: '');
  }
}
