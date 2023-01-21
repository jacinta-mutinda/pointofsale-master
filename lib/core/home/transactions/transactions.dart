import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/core/home/transactions/expense_main.dart';
import 'package:nawiri/core/home/transactions/transactions_ctrl.dart';
import 'package:nawiri/core/home/transactions/expense_form.dart';
import 'package:nawiri/theme/global_widgets.dart';

class TransactionsPage extends StatefulWidget {
  static const routeName = "/transactions";
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final transCtrl = Get.put(TransactionCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Transactions', actions: <Widget>[]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: SizedBox(
            height: double.maxFinite,
            child: navMenu(navItems: [
              navItem(
                  iconPath: Icons.sticky_note_2,
                  label: 'Add Daily Expense',
                  goTo: const ExpensesPage()),
              navItem(
                  iconPath: Icons.account_balance,
                  label: 'Add Bank Transaction',
                  goTo: const BankingPage()),
              navItem(
                  iconPath: Icons.people,
                  label: 'Add Customer Receipt',
                  goTo: const CustomersPage()),
              navItem(
                  iconPath: Icons.local_shipping_rounded,
                  label: 'Add Supplier Payment',
                  goTo: const SupplierPage())
            ])),
      ),
    );
  }
}
