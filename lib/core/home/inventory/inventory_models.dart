class Category {
  String id;
  String name;
  String retailMg;
  String wholesaleMg;
  String showInPos;

  Category(
      {required this.id,
      required this.name,
      required this.retailMg,
      required this.wholesaleMg,
      required this.showInPos});
}

class Product {
  int id;
  String name;
  String desc;
  int code;
  int retailMg;
  int wholesaleMg;
  int buyingPrice;
  int categoryid;
  int uomId;
  bool blockingneg;
  bool active;

  Product(
      {required this.id,
      required this.name,
      required this.desc,
      required this.code,
      required this.retailMg,
      required this.wholesaleMg,
      required this.buyingPrice,
      required this.categoryid,
      required this.uomId,
      required this.blockingneg,
      required this.active});
}

class UoM {
  String id;
  String name;
  String uomCode;

  UoM({required this.id, required this.name, required this.uomCode});
}
