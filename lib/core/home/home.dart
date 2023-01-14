import 'package:flutter/material.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/inventory/inventory.dart';
import 'package:nawiri/core/home/pos.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/core/home/transactions/transactions.dart';
import 'package:nawiri/theme/global_widgets.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/market";
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: mainAppBar(pageTitle: 'Nawiri'),
        drawer: mainDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: SizedBox(
              height: double.maxFinite,
              child: navMenu(navItems: [
                navItem(
                    iconPath: Icons.point_of_sale,
                    label: 'Point of Sale',
                    goTo: const PoSPage()),
                navItem(
                    iconPath: Icons.sticky_note_2,
                    label: 'Transactions',
                    goTo: const TransactionsPage()),
                navItem(
                    iconPath: Icons.account_balance,
                    label: 'Banking',
                    goTo: const BankingPage()),
                navItem(
                    iconPath: Icons.people,
                    label: 'Customers',
                    goTo: const CustomersPage()),
                navItem(
                    iconPath: Icons.local_shipping_rounded,
                    label: 'Suppliers',
                    goTo: const SupplierPage()),
                navItem(
                    iconPath: Icons.inventory_2,
                    label: 'Inventory',
                    goTo: const InventoryPage()),
              ])),
        ));
  }
}
