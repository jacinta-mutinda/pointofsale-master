import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/core/home/banking/banking.dart';
import 'package:nawiri/core/home/billings/billings.dart';
import 'package:nawiri/core/home/customers/customers.dart';
import 'package:nawiri/core/home/inventory/inventory.dart';
import 'package:nawiri/core/home/pos/pos.dart';
import 'package:nawiri/core/home/suppliers/suppliers.dart';
import 'package:nawiri/core/home/expenses/expenses.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/market";
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
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
                    label: 'Expenses',
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
  final auth = Get.put(AuthCtrl());
  RxString branchId = ''.obs;
  bool _isLoading = false;
  RxString methdSelcted = ''.obs;
  RxBool showPin = true.obs;
  RxBool showPackages = false.obs;
  RxBool showBillings = false.obs;
  List<Package> packages = [
    Package(
        title: 'Anually (once an year)',
        desc: 'Get a 30% discount on every month',
        amount: 60),
    Package(
        title: 'Semi anually (every 6 months)',
        desc: 'Get a 20% discount on every month',
        amount: 80),
    Package(title: 'Monthly', desc: 'Payable after every 30 days', amount: 100)
  ];

  @override
  void initState() {
    super.initState();
    getBranch();
  }

  void getBranch() async {
    var prefs = await SharedPreferences.getInstance();
    var branch = prefs.getString('branchId');
    branchId.value = branch!;
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Welcome to Nawiri'),
      Obx(() => showPin.value
          ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                '''
            Please note your 6-digit login pin starts with ${branchId.value} followed by your 4 digit pin.
            When logging in, key in your pin as: \n
          ''',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Obx(() => Text(
                    '${branchId.value} ****',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  )),
              priBtn(
                  label: 'Next',
                  txtColour: Colors.white,
                  bgColour: kDarkGreen,
                  isLoading: _isLoading,
                  function: () {
                    showPin.value = false;
                    showPackages.value = true;
                    showBillings.value = false;
                  })
            ])
          : showPackages.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const Text('Choose Billing Method',
                          textAlign: TextAlign.center, style: kTitle),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(
                                    title: Text(packages[index].title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreen)),
                                    subtitle: Text(packages[index].desc,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                    trailing: Text(
                                        'Kes.${packages[index].amount}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                            color: kDarkGreen)),
                                    leading: Radio(
                                      activeColor: kLightGreen,
                                      value: packages[index].title,
                                      groupValue: methdSelcted.value,
                                      onChanged: (value) {
                                        setState(() {
                                          methdSelcted.value = value!;
                                        });
                                      },
                                    )));
                          },
                          itemCount: packages.length),
                      priBtn(
                          label: 'Done',
                          txtColour: Colors.white,
                          bgColour: kDarkGreen,
                          isLoading: _isLoading,
                          function: () {
                            showPin.value = false;
                            showPackages.value = false;
                            showBillings.value = true;
                          })
                    ])
              : showBillings.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          const Text(
                            '''
           Kindly note that Kes.100 is due within the next 24 hours to continue using Nawiri. 
           Check the Billings Page to make your payment.
          ''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          priBtn(
                              label: 'Open Billings Page',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.off(const BillingsPage());
                              })
                        ])
                  : const SizedBox())
    ]);
  }
}

class Package {
  String title;
  String desc;
  int amount;

  Package({required this.title, required this.desc, required this.amount});
}
