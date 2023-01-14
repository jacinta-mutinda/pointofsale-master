import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/pos.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class CustomerBills extends StatefulWidget {
  static const routeName = "/customerbills";
  const CustomerBills({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerBillsState createState() => _CustomerBillsState();
}

class _CustomerBillsState extends State<CustomerBills> {
  final customerCtrl = Get.put(CustomerCtrl());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Customer', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Customer Bills', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var custBills = customerCtrl.oneCustSales;
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
                                                color: (custBills[index].paid
                                                    ? kLightGreen
                                                    : kPrimaryRed)),
                                            child: const Icon(Icons.receipt,
                                                size: 20, color: Colors.white)),
                                        title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(custBills[index].date,
                                                style: kCardTitle)),
                                        subtitle: Text(
                                            custBills[index].total.toString(),
                                            style: kCardTitle),
                                        trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                      custBills[index].paid
                                                          ? 'Paid'
                                                          : 'Unpaid',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: custBills[
                                                                      index]
                                                                  .paid
                                                              ? kLightGreen
                                                              : kPrimaryRed))),
                                              Text(
                                                'Kes${custBills[index].total}',
                                                style: kCardTitle,
                                              )
                                            ]),
                                        onTap: () async {
                                          customerCtrl.singleBillId.value =
                                              custBills[index].id;
                                          customerCtrl.getSingleBill();
                                        },
                                      ),
                                      priBtn(
                                          label: 'Clear Bill',
                                          txtColour: Colors.white,
                                          bgColour: kDarkGreen,
                                          isLoading: _isLoading,
                                          function: () {
                                            Get.to(const PoSPage());
                                          })
                                    ])));
                      },
                      itemCount: customerCtrl.oneCustSales.length),
                ),
              ]))),
    );
  }
}
