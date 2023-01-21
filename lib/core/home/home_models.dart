import 'package:get/get.dart';

class BankAccount {
  String id;
  String bankName;
  String accno;
  String branchName; // account_details
  String cpperson; //account_manager

  BankAccount(
      {required this.id,
      required this.bankName,
      required this.accno,
      required this.branchName,
      required this.cpperson});
}

class BankTransaction {
  int id;
  int bankId;
  String action;
  String desc;
  int amount;
  String date;

  BankTransaction(
      {required this.id,
      required this.bankId,
      required this.action,
      required this.desc,
      required this.date,
      required this.amount});
}

class Supplier {
  String id;
  String name;
  String item;
  String bankacc;
  String krapin;
  String address;
  String cpperson;
  String phoneno;

  Supplier(
      {required this.id,
      required this.name,
      required this.item,
      required this.bankacc,
      required this.krapin,
      required this.address,
      required this.phoneno,
      required this.cpperson});
}

class SupplierPayment {
  int id;
  int supplierId;
  int quantity;
  int unitPrice;
  int total;
  String date;

  SupplierPayment(
      {required this.id,
      required this.supplierId,
      required this.quantity,
      required this.unitPrice,
      required this.date,
      required this.total});
}

class Customer {
  String id;
  String name;
  String runningBal;
  String totalCredit;
  String phoneno;
  String bankacc;
  String krapin;
  String address;
  String cpperson;
  String creditlimit;

  Customer(
      {required this.id,
      required this.name,
      required this.runningBal,
      required this.totalCredit,
      required this.phoneno,
      required this.bankacc,
      required this.krapin,
      required this.address,
      required this.cpperson,
      required this.creditlimit});
}

class CartItem {
  int id;
  String name;
  int prodId;
  int quantity;
  int unitPrice;
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
  int id;
  RxList<CartItem> cart;
  RxInt total;
  String payMethod;
  String refCode;
  int custId;
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

class Expense {
  int id;
  String mode;
  String desc;
  int amount;
  String type;

  Expense(
      {required this.id,
      required this.mode,
      required this.desc,
      required this.amount,
      required this.type});
}

class User {
  int id;
  String busname;
  String busaddress;
  String location;
  int phone;
  int till;
  String recFooter;
  String username;
  String address;
  int phoneno;
  int pin;

  User(
      {required this.id,
      required this.busname,
      required this.busaddress,
      required this.location,
      required this.phone,
      required this.till,
      required this.recFooter,
      required this.username,
      required this.address,
      required this.phoneno,
      required this.pin});
}

class Billing {
  int id;
  String name;
  String date;
  bool paid;
  int amount = 250;

  Billing(
      {required this.id,
      required this.name,
      required this.date,
      required this.paid});
}
