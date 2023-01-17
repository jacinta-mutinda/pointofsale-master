import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/billings/billings.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/inventory/inventory.dart';
import 'package:nawiri/core/home/pos/pos.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/core/home/transactions/transactions.dart';
import 'package:nawiri/theme/constants.dart';
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

class WelcomePrompt extends StatefulWidget {
  static const routeName = "/WelcomePrompt";

  const WelcomePrompt({Key? key}) : super(key: key);

  @override
  _WelcomePromptState createState() => _WelcomePromptState();
}

class _WelcomePromptState extends State<WelcomePrompt> {
  bool _isLoading = false;
  RxBool showBillings = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Welcome to Nawiri'),
      Obx(() => showBillings.value
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                '''
            Please note your 6-digit login pin starts with 01 followed by your 4 digit pin.
            When logging in, key in your pin as: \n
            01****
          ''',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              priBtn(
                  label: 'Next',
                  txtColour: Colors.black,
                  bgColour: kGrey,
                  isLoading: _isLoading,
                  function: () {
                    showBillings.value = true;
                  })
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                '''
           Kindly note that Kes.100 is due within the next 24 hours to continue using Nawiri. 
           Check the Billings Page to make your payment.
          ''',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              priBtn(
                  label: 'Open Billings Page',
                  txtColour: Colors.black,
                  bgColour: kGrey,
                  isLoading: _isLoading,
                  function: () {
                    Get.back();
                    Get.to(const BillingsPage());
                  })
            ]))
    ]);
  }
}
