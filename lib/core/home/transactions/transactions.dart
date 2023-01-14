import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/transactions/transaction_ctrl.dart';
import 'package:nawiri/core/home/transactions/transaction_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Expenses', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var expenses = transCtrl.expenses;
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
                                      child: const Icon(Icons.local_shipping,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(expenses[index].type,
                                          style: kCardTitle)),
                                  subtitle: Text('Kes${expenses[index].amount}',
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
                                    transCtrl.isTransEdit.value = true;
                                    transCtrl.transToEdit.value =
                                        expenses[index].id;
                                    Get.to(const TransactionForm());
                                  },
                                )));
                      },
                      itemCount: transCtrl.expenses.length),
                ),
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          transCtrl.isTransEdit.value = false;
          Get.to(const TransactionForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
