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
  final _isDialOpen = ValueNotifier(false);
  final bankingCtrl = Get.put(BankingCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_isDialOpen.value) {
            _isDialOpen.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            appBar: backAppBar(pageTitle: 'Bank Account', actions: <Widget>[]),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Obx(() => Text(bankingCtrl.bankPageName.value,
                              style: kTitle))),
                      Obx(
                        () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var accTrans = bankingCtrl.accBankTrans;
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Card(
                                      color: kGrey,
                                      elevation: 7.0,
                                      child: ListTile(
                                        leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    (accTrans[index].action ==
                                                            'Withdraw'
                                                        ? kPrimaryRed
                                                        : kLightGreen)),
                                            child: Icon(
                                                accTrans[index].action ==
                                                        'Withdraw'
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
            floatingActionButton: SpeedDial(
                icon: Icons.more_vert,
                activeIcon: Icons.close,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: kDarkGreen,
                overlayColor: kCreamTheme,
                overlayOpacity: 0.8,
                spacing: 10,
                openCloseDial: _isDialOpen,
                children: [
                  SpeedDialChild(
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: 'Edit Bank Account',
                      labelBackgroundColor: kCreamTheme,
                      backgroundColor: kDarkGreen,
                      onTap: () {
                        Get.to(const BankAccForm());
                      }),
                  SpeedDialChild(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: 'Add Bank Transaction',
                      labelBackgroundColor: kCreamTheme,
                      backgroundColor: kDarkGreen,
                      onTap: () {
                        bankingCtrl.isTransEdit.value = false;
                        Get.to(const BankTransForm());
                      })
                ])));
  }
}
