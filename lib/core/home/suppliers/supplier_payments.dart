import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/suppliers/suppay_form.dart';
import 'package:nawiri/core/home/suppliers/supplier_form.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SupplierPayments extends StatefulWidget {
  static const routeName = "/suppays";
  const SupplierPayments({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SupplierPaymentsState createState() => _SupplierPaymentsState();
}

class _SupplierPaymentsState extends State<SupplierPayments> {
  final _isDialOpen = ValueNotifier(false);
  final supplierCtrl = Get.put(SupplierCtrl());

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
            appBar: backAppBar(pageTitle: 'Supplier', actions: <Widget>[]),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Obx(() => Text(supplierCtrl.supPageName.value,
                              style: kTitle))),
                      Obx(
                        () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var supPays = supplierCtrl.oneSupPayments;
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
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kLightGreen),
                                            child: const Icon(
                                                Icons.sticky_note_2,
                                                size: 20,
                                                color: Colors.white)),
                                        title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                                supPays[index]
                                                    .quantity
                                                    .toString(),
                                                style: kCardTitle)),
                                        subtitle: Text(
                                            'Kes.${supPays[index].total}',
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
                                          supplierCtrl.isSupPayEdit.value =
                                              true;
                                          supplierCtrl.supPayToEdit.value =
                                              supPays[index].id;
                                          Get.to(() => const SuppPayForm());
                                        },
                                      )));
                            },
                            itemCount: supplierCtrl.oneSupPayments.length),
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
                      label: 'Edit Supplier',
                      labelBackgroundColor: kCreamTheme,
                      backgroundColor: kDarkGreen,
                      onTap: () {
                        Get.to(const SupplierForm());
                      }),
                  SpeedDialChild(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: 'Add Payment',
                      labelBackgroundColor: kCreamTheme,
                      backgroundColor: kDarkGreen,
                      onTap: () {
                        supplierCtrl.isSupPayEdit.value = false;
                        Get.to(const SuppPayForm());
                      })
                ])));
  }
}
