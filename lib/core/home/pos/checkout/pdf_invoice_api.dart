import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/pos/checkout/checkout_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/utils/file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final posCtrl = Get.put(PoSCtrl());
final checkoutCtrl = Get.put(CheckoutCtrl());

class PdfInvoiceApi extends GetxController {
  List<List<dynamic>> tableData = [];

  Future<File> generate(String balance, String totalPaid) async {
    final pdf = pw.Document();

    final iconImage = (await rootBundle.load('assets/images/nawiri-logo.png'))
        .buffer
        .asUint8List();
    final tableHeaders = [
      'Description',
      'Quantity',
      'Unit Price',
      'Total',
    ];
    tableData = [];
    for (var item in posCtrl.cartSale.cart) {
      tableData.add([
        item.name,
        item.quantity.value.toString(),
        item.unitPrice.value.toString(),
        item.total.value.toString()
      ]);
    }
    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(
            8 * PdfPageFormat.cm, 20 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm),
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 35,
                  width: 35,
                ),
                pw.SizedBox(width: 3 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Jojo Fruits',
                      style: pw.TextStyle(
                        fontSize: 14.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Customer receipt',
                      style: const pw.TextStyle(
                        fontSize: 10.0,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.Text(
                      DateTime.now().toString().substring(0, 10),
                      style: const pw.TextStyle(
                        fontSize: 10.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                )
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            // pw.Text(
            //   'Dear John,\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error',
            //   textAlign: pw.TextAlign.justify,
            // ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: null,
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.0),
              cellStyle: const pw.TextStyle(fontSize: 7.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.green400),
              cellHeight: 25.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.BarcodeWidget(
                    height: 40,
                    width: 40,
                    color: PdfColor.fromHex("#000000"),
                    barcode: pw.Barcode.qrCode(),
                    data: "My data",
                  ),
                  pw.Spacer(flex: 4),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Net total',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              'Kes.${posCtrl.cartSale.total.value}.00',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Paid',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              'Kes.$totalPaid.00',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Balance',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              '$balance.00',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'Thank you for Shopping with us',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                    color: PdfColors.green400),
              ),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'Jojo Fruits',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Text(
                'Kimathi, house',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Text(
                'jojofruits@gmail.com | 0712 345 678',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(
        name: '${DateTime.now().toString()}.pdf', pdf: pdf);
  }
}
