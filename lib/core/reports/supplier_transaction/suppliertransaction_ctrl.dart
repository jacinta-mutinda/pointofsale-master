import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nawiri/core/reports/report_models.dart';
import 'package:http/http.dart' as http;
import 'package:nawiri/core/reports/report_models.dart';
import 'package:nawiri/utils/urls.dart';
// import 'package:nawiri/utils/urls.dart';
// import 'package:nawiri/theme/global_widgets.dart';
// import 'package:nawiri/utils/functions.dart';
// import 'package:nawiri/utils/urls.dart';

// class SupplierTransactionReportCtrl extends GetxController {
//   RxString branch_id = ''.obs;
//   SupplierTransactionModel saleRow = SupplierTransactionModel(
//    supplierTransId: '',
//   transactionRef:'',
//  transactionDate:'',
//  transactionAmount:'',
// transactionApproved:'',
//  transactionPaymentType:'',
//  transactionPaymentRef:'',
//  transactionComment:'',
//  transactionVatTotal:'',
// transactionDueDate:'',
//   transBy:'',
//  updatedBy:'',
//   updatedOn:'',
//   createdBy:'',
//   createdOn:'',
//  runningBal:'',
// updated:'',
//    branchId:'',
//  discount:'',
//   supplier:'',
// transType:'',
// );


//   @override
//   void onInit() {
//     super.onInit();
//     getBranchId();
    
//   }

//   getBranchId() {
//     branch_id.value = '11';
//   }

//   getSupplierTransactionReports() async {
//     saleRow = SupplierTransactionModel(
//    supplierTransId: '',
//   transactionRef:'',
//  transactionDate:'',
//  transactionAmount:'',
// transactionApproved:'',
//  transactionPaymentType:'',
//  transactionPaymentRef:'',
//  transactionComment:'',
//  transactionVatTotal:'',
// transactionDueDate:'',
//   transBy:'',
//  updatedBy:'',
//   updatedOn:'',
//   createdBy:'',
//   createdOn:'',
//  runningBal:'',
// updated:'',
//    branchId:'',
//  discount:'',
//   supplier:'',
// transType:'',
// );
//     var body = jsonEncode({
//       'branch_id': 11,
//     });
//     try {
//       final response = await http.post(Uri.parse(getSupplierTransactionReportUrl),
//           body: body, headers: headers);
            
//       if (response.statusCode == 200) {
//         var resData = json.decode(response.body);
//         print(resData);
      
//         if (resData is Map) {
//           saleRow. supplierTransId = resData['supplier_trans_id'];
//     saleRow.transactionRef = resData['transaction_ref'];
//     saleRow.transactionDate = resData['transaction_date'];
//    saleRow. transactionAmount = resData['transaction_amount'];
//     saleRow.transactionApproved = resData['transaction_approved'];
//     saleRow.transactionPaymentType = resData['transaction_payment_type'];
//     saleRow.transactionPaymentRef = resData['transaction_payment_ref'];
//     saleRow.transactionComment = resData['transaction_comment'];
//    saleRow. transactionVatTotal = resData['transaction_vat_total'];
//     saleRow.transactionDueDate = resData['transaction_due_date'];
//     saleRow.transBy = resData['trans_by'];
//     saleRow.updatedBy = resData['updated_by'];
//     saleRow.updatedOn = resData['updated_on'];
//     saleRow.createdBy = resData['created_by'];
//    saleRow. createdOn = resData['created_on'];
//    saleRow. runningBal = resData['running_bal'];
//    saleRow. updated = resData['updated'];
//     saleRow.branchId = resData['branch_id'];
//     saleRow.discount = resData['discount'];
//     saleRow.supplier = resData['supplier'];
//    saleRow. transType = resData['trans_type'];
//         }
//       }
//       update();
//       return;
//     } catch (error) {
//       debugPrint("$error");
//       showSnackbar(
//           path: Icons.close_rounded,
//           title: "Failed to load Supplier Transaction Report!",
//           subtitle: "Please check your internet connection or try again later");
//     }
//   }


// }
Future<List> getSupplierTransactionReports() async {
  final uri = Uri.parse(getSupplierTransactionReportUrl);
  var body = jsonEncode({
'branch_id':11
  });
  

  http.Response response = await http.post(
    uri,
    body: body,
  );

  return json.decode(response.body);
  
}