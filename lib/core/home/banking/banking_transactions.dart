import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/banking/banking_form.dart';
import 'package:nawiri/core/home/banking/bankingtrans_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

final bankingCtrl = Get.put(BankingCtrl());

class BankTransPage extends StatefulWidget {
  static const routeName = "/banking";
  const BankTransPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankTransPageState createState() => _BankTransPageState();
}

class _BankTransPageState extends State<BankTransPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Bank Transactions', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                              label: 'Edit Account',
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
                      childLabel: bankingCtrl.accToShow.bankName),
                  labelSpan(
                      mainLabel: 'Running Balance',
                      childLabel: bankingCtrl.accToShow.running_bal),
                  labelSpan(
                      mainLabel: 'Branch Name',
                      childLabel: bankingCtrl.accToShow.branchName),
                  labelSpan(
                      mainLabel: 'Bank Account No',
                      childLabel: bankingCtrl.accToShow.accno),
                  labelSpan(
                      mainLabel: 'Contact Person Phone',
                      childLabel: bankingCtrl.accToShow.cpperson)

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
                                Get.to(const BankTransForm());
                              })
                        ])),
                Obx(() => bankingCtrl.showTransLoading.value
                    ? loadingWidget(label: 'Loading Account Transactions ...')
                    : bankingCtrl.showTransData.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, right: 5),
                                          child: Obx(() => RichText(
                                                  text: TextSpan(children: [
                                                const TextSpan(
                                                  text: 'Showing ',
                                                  style: kBlackTxt,
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${bankingCtrl.rangeBankTrans.length} ',
                                                  style: kNeonTxt,
                                                ),
                                                const TextSpan(
                                                  text: ' of ',
                                                  style: kBlackTxt,
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${bankingCtrl.accBankTrans.length} ',
                                                  style: kDarkGreenTxt,
                                                ),
                                                const TextSpan(
                                                  text: ' transactions',
                                                  style: kBlackTxt,
                                                )
                                              ]))))
                                    ]),
                                Obx(
                                  () => ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var accBankTrans =
                                            bankingCtrl.rangeBankTrans;
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Card(
                                                color: kGrey,
                                                elevation: 7.0,
                                                child: ListTile(
                                                  leading: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kLightGreen),
                                                      child: const Icon(
                                                          Icons.person,
                                                          size: 20,
                                                          color: Colors.white)),
                                                  title: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                          accBankTrans[index]
                                                              .refCode,
                                                          style: kCardTitle)),
                                                  subtitle: Text(
                                                      'Kes${accBankTrans[index].amount}',
                                                      style: kCardTitle),
                                                  trailing: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  kDarkGreen),
                                                      child: const Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          size: 25,
                                                          color: Colors.white)),
                                                  onTap: () async {
                                                    bankingCtrl.singleTrans =
                                                        accBankTrans[index];
                                                    Get.dialog(
                                                        const SingleTransaction());
                                                  },
                                                )));
                                      },
                                      itemCount:
                                          bankingCtrl.rangeBankTrans.length),
                                ),
                              ])
                        : noItemsWidget(label: 'No Transactions Found'))
              ]))),
    );
  }
}

class SingleTransaction extends StatefulWidget {
  static const routeName = "/SingleTransaction";

  const SingleTransaction({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SingleTransactionState createState() => _SingleTransactionState();
}

class _SingleTransactionState extends State<SingleTransaction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Reference Code: ${bankingCtrl.singleTrans.refCode}'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: 'Comment', childLabel: bankingCtrl.singleTrans.desc),
        labelSpan(
            mainLabel: 'Amount',
            childLabel: 'Kes${bankingCtrl.singleTrans.amount}'),
      ])
    ]);
  }
}
