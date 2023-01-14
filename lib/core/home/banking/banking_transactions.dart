import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/banking/banking_form.dart';
import 'package:nawiri/core/home/banking/bankingtrans_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BankTransPage extends StatefulWidget {
  static const routeName = "/banking";
  const BankTransPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankTransPageState createState() => _BankTransPageState();
}

class _BankTransPageState extends State<BankTransPage> {
  bool _isLoading = false;
  final bankingCtrl = Get.put(BankingCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
          pageTitle: bankingCtrl.bankPageName.value, actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Account Details', style: kTitle),
                          smallPriBtn(
                              label: 'Edit Transaction',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                Get.to(const BankAccForm());
                              })
                        ])),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  labelSpan(
                      mainLabel: 'Bank Name',
                      childLabel: bankingCtrl.transAccToShow.bankName),
                  labelSpan(
                      mainLabel: 'Branch Name',
                      childLabel: bankingCtrl.transAccToShow.branchName),
                  labelSpan(
                      mainLabel: 'Bank Account No',
                      childLabel: bankingCtrl.transAccToShow.accno.toString()),
                  labelSpan(
                      mainLabel: 'Contact Person Phone',
                      childLabel:
                          bankingCtrl.transAccToShow.cpperson.toString()),
                  labelSpan(
                      mainLabel: 'Current Total',
                      childLabel:
                          'Kes${bankingCtrl.transAccToShow.currentTotal}'),
                ]),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Account Transactions', style: kTitle),
                          smallPriBtn(
                              label: 'Add Transaction',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                bankingCtrl.isTransEdit.value = false;
                                Get.to(const BankTransForm());
                              })
                        ])),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var accTrans = bankingCtrl.accBankTrans;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                                color: kGrey,
                                elevation: 7.0,
                                child: ListTile(
                                  leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (accTrans[index].action ==
                                                  'Withdraw'
                                              ? kPrimaryRed
                                              : kLightGreen)),
                                      child: Icon(
                                          accTrans[index].action == 'Withdraw'
                                              ? Icons.call_made
                                              : Icons.call_received,
                                          size: 20,
                                          color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(accTrans[index].action,
                                          style: kCardTitle)),
                                  subtitle: Text(
                                      'Kes.${accTrans[index].amount}',
                                      style: kCardTitle),
                                  trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkGreen),
                                      child: const Icon(Icons.edit,
                                          size: 25, color: Colors.white)),
                                  onTap: () {
                                    bankingCtrl.isTransEdit.value = true;
                                    bankingCtrl.transToEdit.value =
                                        accTrans[index].id;
                                    Get.to(() => const BankTransForm());
                                  },
                                )));
                      },
                      itemCount: bankingCtrl.accBankTrans.length),
                )
              ]))),
    );
  }
}
