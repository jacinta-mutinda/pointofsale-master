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
  String id;
  String name;
  String desc;
  String code;
  String retailMg;
  String wholesaleMg;
  String buyingPrice;
  String categoryid;
  String uomId;
  String blockingneg;
  String active;
  String cartQuantity;

  Product(
      {required this.id,
      required this.cartQuantity,
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
