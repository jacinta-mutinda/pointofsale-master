import 'package:flutter/material.dart';
import 'package:nawiri/core/home/inventory/category/category_main.dart';
import 'package:nawiri/core/home/inventory/products/product_main.dart';
import 'package:nawiri/core/home/inventory/uoms/uom_main.dart';
import 'package:nawiri/theme/global_widgets.dart';

class InventoryPage extends StatefulWidget {
  static const routeName = "/inventory";
  const InventoryPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(pageTitle: 'Inventory', actions: <Widget>[]),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: SizedBox(
              height: double.maxFinite,
              child: navMenu(navItems: [
                navItem(
                    iconPath: Icons.category,
                    label: 'Category',
                    goTo: const CategoriesPage()),
                navItem(
                    iconPath: Icons.shopping_basket,
                    label: 'Product',
                    goTo: const ProductsPage()),
                navItem(
                    iconPath: Icons.scale,
                    label: 'Unit of Measure',
                    goTo: const UoMsPage()),
              ])),
        ));
  }
}
