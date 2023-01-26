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
  String id;
  String cashAmt;
  String mpesaAmt;
  String cardAmt;
  RxString total;

  ShiftFloat(
      {required this.id,
      required this.cashAmt,
      required this.mpesaAmt,
      required this.cardAmt,
      required this.total});
}
