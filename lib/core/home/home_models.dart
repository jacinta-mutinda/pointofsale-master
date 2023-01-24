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
  String id;
  String supId;
  String ref;
  String date;
  String transtype;
  String discount;
  String amount;
  String comment;

  SupplierPayment(
      {required this.id,
      required this.supId,
      required this.ref,
      required this.date,
      required this.amount,
      required this.discount,
      required this.transtype,
      required this.comment});
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

class Expense {
  String id;
  String date;
  String payto;
  String ref;
  String desc;
  String amount;
  String branch_id;

  Expense(
      {required this.id,
      required this.date,
      required this.desc,
      required this.amount,
      required this.ref,
      required this.payto,
      required this.branch_id,});
}

class CustReceipt {
  String id;
  String custId;
  String ref;
  String date;
  String transtype;
  String discount;
  String amount;
  String comment;

  CustReceipt(
      {required this.id,
      required this.custId,
      required this.ref,
      required this.date,
      required this.amount,
      required this.discount,
      required this.transtype,
      required this.comment});
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
