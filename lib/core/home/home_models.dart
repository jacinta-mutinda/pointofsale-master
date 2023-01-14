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
  int id;
  String name;
  String item;
  int bankacc;
  int krapin;
  String address;
  int cpperson;

  Supplier(
      {required this.id,
      required this.name,
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
  int id;
  String name;
  int phoneno;
  int bankacc;
  int krapin;
  String address;
  int cpperson;
  int creditlimit;

  Customer(
      {required this.id,
      required this.name,
      required this.phoneno,
      required this.bankacc,
      required this.krapin,
      required this.address,
      required this.cpperson,
      required this.creditlimit});
}

class CartItem {
  int id;
  int prodId;
  int quantity;
  int total;

  CartItem({
    required this.id,
    required this.prodId,
    required this.quantity,
    required this.total,
  });
}

class Sale {
  int id;
  List<CartItem> cart;
  int total;
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
