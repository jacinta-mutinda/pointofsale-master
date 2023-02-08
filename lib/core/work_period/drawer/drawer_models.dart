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
    String payRef;
  String payTo;
  String payAmount;
  String cashAmount;
  String mobileAmount;
  RxString payDescription;

  ShiftFloat(
      {required this.payRef,
      required this.payTo,
      required this.payAmount,
      required  this.cashAmount,
      required this.mobileAmount,
      required this.payDescription});
}

class Shiftexpense {
  String payRef;
  String payTo;
  String payAmount;
  String cashAmount;
  String mobileAmount;
  RxString payDescription;

  Shiftexpense(
      {required this.payRef,
      required this.payTo,
      required this.payAmount,
      required this.cashAmount,
      required this.mobileAmount,
      required this.payDescription, 
    });

  
      }