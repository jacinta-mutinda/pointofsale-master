import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/billings/billings_ctrl.dart';
import 'package:nawiri/core/home/pos/pos.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class BillingsPage extends StatefulWidget {
  static const routeName = "/BillingsPage";
  const BillingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BillingsPageState createState() => _BillingsPageState();
}

class _BillingsPageState extends State<BillingsPage> {
  final billingCtrl = Get.put(BillingsCtrl());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          backAppBar(pageTitle: 'Billings and Payments', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var userBills = billingCtrl.billings;
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                                color: kGrey,
                                elevation: 7.0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (userBills[index].paid
                                                    ? kLightGreen
                                                    : kPrimaryRed)),
                                            child: const Icon(Icons.receipt,
                                                size: 20, color: Colors.white)),
                                        title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                                userBills[index].paid
                                                    ? 'Receipt ${userBills[index].name}'
                                                    : 'Invoice ${userBills[index].name}',
                                                style: kCardTitle)),
                                        subtitle: Text(userBills[index].date,
                                            style: kCardTitle),
                                        trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                      userBills[index].paid
                                                          ? 'Paid'
                                                          : 'Due in 24 hours',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: userBills[
                                                                      index]
                                                                  .paid
                                                              ? kDarkGreen
                                                              : kPrimaryRed))),
                                              Text(
                                                'Kes.${userBills[index].amount}',
                                                style: kCardTitle,
                                              )
                                            ]),
                                        onTap: () async {
                                          billingCtrl.singleBillId.value =
                                              userBills[index].id;
                                          billingCtrl.getSingleBill();
                                        },
                                      ),
                                      Obx(() => !userBills[index].paid
                                          ? priBtn(
                                              label: 'Make Payment',
                                              txtColour: Colors.white,
                                              bgColour: kDarkGreen,
                                              isLoading: _isLoading,
                                              function: () {
                                                showSnackbar(
                                                    title:
                                                        'Opening M-pesa STK Push Prompt',
                                                    subtitle: '');
                                              })
                                          : const SizedBox())
                                    ])));
                      },
                      itemCount: billingCtrl.billings.length),
                ),
              ]))),
    );
  }
}
