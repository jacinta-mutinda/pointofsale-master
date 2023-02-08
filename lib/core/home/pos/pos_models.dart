import 'package:get/get.dart';

class CartItem {
  String id;
  String name;
  String prodId;
  RxInt quantity;
  RxInt unitPrice;
  RxInt total;

  CartItem({
    required this.id,
    required this.name,
    required this.prodId,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

class Sale {
  String id;
  RxList<CartItem> cart;
  RxInt total;
  String payMethod;
  String refCode;
  String custId;
  bool paid;
  String date;

  Sale(
      {required this.id,
      required this.cart,
      required this.total,
      required this.payMethod,
      required this.custId,
      required this.refCode,
      required this.date,
      required this.paid});
}

class CheckOutDet {
  String payMthd;
  String mpesaRefCode;
  String bankRefCode;
  String cashPaid;
  String bankPaid;
  String mobilePaid;
  String onAccPaid;
  String custAccId;
  String bankAccId;
  String totalPaid;
  String balance;

  CheckOutDet(
      {required this.payMthd,
      required this.mpesaRefCode,
      required this.bankRefCode,
      required this.onAccPaid,
      required this.cashPaid,
      required this.bankPaid,
      required this.mobilePaid,
      required this.custAccId,
      required this.bankAccId,
      required this.totalPaid,
      required this.balance});
}

class PayMethod {
  String name;
  RxBool selected;

  PayMethod({required this.name, required this.selected});
}
