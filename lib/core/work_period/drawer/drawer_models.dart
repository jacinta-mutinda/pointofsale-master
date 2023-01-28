import 'package:get/get.dart';

class ShiftSale {
  String id;
  String cashAmt;
  String mpesaAmt;
  String cardAmt;
  RxString total;

  ShiftSale(
      {required this.id,
      required this.cashAmt,
      required this.mpesaAmt,
      required this.cardAmt,
      required this.total});
}

class ShiftFloat {
  String? payRef;
  String? payDate;
  String? payAmount;
  String? cashAmount;
  String? mobileAmount;
  String? payDescription;

  ShiftFloat(  
      {this.payRef,
      this.payDate,
       this.payAmount,
      this.cashAmount,
      this.mobileAmount,
      this.payDescription});
}
