import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/banking/banking_form.dart';
import 'package:nawiri/core/home/banking/banking_transactions.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class BankingPage extends StatefulWidget {
  static const routeName = "/banking";
  const BankingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankingPageState createState() => _BankingPageState();
}

class _BankingPageState extends State<BankingPage> {
  final bankingCtrl = Get.put(BankingCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Banking', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Bank Accounts', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var bankAccounts = bankingCtrl.bankAccounts;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                                color: kGrey,
                                elevation: 7.0,
                                child: ListTile(
                                  leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kLightGreen),
                                      child: const Icon(Icons.account_balance,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(bankAccounts[index].bankName,
                                          style: kCardTitle)),
                                  subtitle: Text(
                                      ('Kes.${bankAccounts[index].currentTotal}'),
                                      style: kCardTitle),
                                  trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkGreen),
                                      child: const Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 25,
                                          color: Colors.white)),
                                  onTap: () async {
                                    bankingCtrl.isBankEdit.value = true;
                                    bankingCtrl.bankToEdit.value =
                                        bankAccounts[index].id;
                                    bankingCtrl.transToShow.value =
                                        bankAccounts[index].id;
                                    await bankingCtrl.getAccBankTrans();
                                  },
                                )));
                      },
                      itemCount: bankingCtrl.bankAccounts.length),
                ),
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          bankingCtrl.isBankEdit.value = false;
          Get.to(const BankAccForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
