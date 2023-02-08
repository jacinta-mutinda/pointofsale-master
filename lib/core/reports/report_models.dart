import 'package:flutter/src/material/data_table.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SupplierTransactionModel {
  String? supplierTransId;
  String? transactionRef;
  String? transactionDate;
  String? transactionAmount;
 String? transactionApproved;
 String? transactionPaymentType;
 String? transactionPaymentRef;
  String? transactionComment;
  String? transactionVatTotal;
  String? transactionDueDate;
  String? transBy;
  String? updatedBy;
 String? updatedOn;
  String? createdBy;
  String? createdOn;
  String? runningBal;
  String? updated;
  String? branchId;
  String? discount;
  String? supplier;
  String? transType;

  SupplierTransactionModel(
      {this.supplierTransId,
      this.transactionRef,
      this.transactionDate,
      this.transactionAmount,
      this.transactionApproved,
      this.transactionPaymentType,
      this.transactionPaymentRef,
      this.transactionComment,
      this.transactionVatTotal,
      this.transactionDueDate,
      this.transBy,
      this.updatedBy,
      this.updatedOn,
      this.createdBy,
      this.createdOn,
      this.runningBal,
      this.updated,
      this.branchId,
      this.discount,
      this.supplier,
      this.transType});

  SupplierTransactionModel.fromJson(Map<String, dynamic> json) {
    supplierTransId = json['supplier_trans_id'];
    transactionRef = json['transaction_ref'];
    transactionDate = json['transaction_date'];
    transactionAmount = json['transaction_amount'];
    transactionApproved = json['transaction_approved'];
    transactionPaymentType = json['transaction_payment_type'];
    transactionPaymentRef = json['transaction_payment_ref'];
    transactionComment = json['transaction_comment'];
    transactionVatTotal = json['transaction_vat_total'];
    transactionDueDate = json['transaction_due_date'];
    transBy = json['trans_by'];
    updatedBy = json['updated_by'];
    updatedOn = json['updated_on'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    runningBal = json['running_bal'];
    updated = json['updated'];
    branchId = json['branch_id'];
    discount = json['discount'];
    supplier = json['supplier'];
    transType = json['trans_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['supplier_trans_id'] = supplierTransId;
    data['transaction_ref'] = transactionRef;
    data['transaction_date'] = transactionDate;
    data['transaction_amount'] = transactionAmount;
    data['transaction_approved'] = transactionApproved;
    data['transaction_payment_type'] = transactionPaymentType;
    data['transaction_payment_ref'] = transactionPaymentRef;
    data['transaction_comment'] = transactionComment;
    data['transaction_vat_total'] = transactionVatTotal;
    data['transaction_due_date'] = transactionDueDate;
    data['trans_by'] = transBy;
    data['updated_by'] = updatedBy;
    data['updated_on'] = updatedOn;
    data['created_by'] = createdBy;
    data['created_on'] = createdOn;
    data['running_bal'] = runningBal;
    data['updated'] = updated;
    data['branch_id'] = branchId;
    data['discount'] = discount;
    data['supplier'] = supplier;
    data['trans_type'] = transType;
    return data;
  }

 // map(DataRow Function(dynamic saleRow) param0) {}
}

class Shiftsalereportmodel {
  RxString total;
  String mpesa;
  String cash;
  String card;
  String shiftId;

  Shiftsalereportmodel(
      {required this.total,
       required this.mpesa, 
       required this.cash, 
      required this.card, 
       required this.shiftId});}