import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/suppliers/supplier_form.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class SupplierPage extends StatefulWidget {
  static const routeName = "/suppliers";
  const SupplierPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final suppliersCtrl = Get.put(SupplierCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Suppliers', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Suppliers', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var suppliers = suppliersCtrl.suppliers;
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
                                      child: Text(suppliers[index].name,
                                          style: kCardTitle)),
                                  subtitle: Text(suppliers[index].item,
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
                                    suppliersCtrl.isSupEdit.value = true;
                                    suppliersCtrl.supToEdit.value =
                                        suppliers[index].id;
                                    suppliersCtrl.paysToShow.value =
                                        suppliers[index].id;
                                    await suppliersCtrl.getOneSupPayments();
                                  },
                                )));
                      },
                      itemCount: suppliersCtrl.suppliers.length),
                ),
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          suppliersCtrl.isSupEdit.value = false;
          Get.to(const SupplierForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
