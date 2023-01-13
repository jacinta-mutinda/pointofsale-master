class BankAccount {
  int id;
  String bankName;
  int accno;
  String branchName;
  int cpperson;
  int currentTotal;

  BankAccount(
      {required this.id,
      required this.bankName,
      required this.accno,
      required this.branchName,
      required this.cpperson,
      required this.currentTotal});
}

class BankTransaction {
  int id;
  int bankId;
  String action;
  String desc;
  int amount;

  BankTransaction(
      {required this.id,
      required this.bankId,
      required this.action,
      required this.desc,
      required this.amount});
}

class Supplier {
  int id;
  String name;
  String item;
  int code;
  String bankacc;
  int krapin;
  String address;
  int cpperson;

  Supplier(
      {required this.id,
      required this.name,
      required this.code,
      required this.item,
      required this.bankacc,
      required this.krapin,
      required this.address,
      required this.cpperson});
}

class SupplierPayment {
  int id;
  int supplierId;
  int quantity;
  int unitPrice;
  int total;

  SupplierPayment(
      {required this.id,
      required this.supplierId,
      required this.quantity,
      required this.unitPrice,
      required this.total});
}

class Customer {
  int id;
  String name;
  String item;
  int phoneno;
  String bankacc;
  int krapin;
  String address;
  int cpperson;
  int creditlimit;

  Customer(
      {required this.id,
      required this.name,
      required this.phoneno,
      required this.item,
      required this.bankacc,
      required this.krapin,
      required this.address,
      required this.cpperson,
      required this.creditlimit});
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
