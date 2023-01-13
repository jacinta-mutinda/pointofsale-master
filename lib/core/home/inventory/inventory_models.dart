class Category {
  int id;
  String name;
  int retailMg;
  int wholesaleMg;
  bool showInPos;

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
  int retailMg;
  int wholesaleMg;
  int categoryid;
  int uomId;

  Product(
      {required this.id,
      required this.name,
      required this.desc,
      required this.retailMg,
      required this.wholesaleMg,
      required this.categoryid,
      required this.uomId});
}

class UoM {
  int id;
  String name;

  UoM({
    required this.id,
    required this.name,
  });
}