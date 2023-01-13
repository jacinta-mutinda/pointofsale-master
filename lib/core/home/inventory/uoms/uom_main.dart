import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/uoms/uom_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class UoMsPage extends StatefulWidget {
  static const routeName = "/uom";
  const UoMsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UoMsPageState createState() => _UoMsPageState();
}

class _UoMsPageState extends State<UoMsPage> {
  final invtCtrl = Get.put(InventoryCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Unit of Measurement', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Units of Measurement', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var uoms = invtCtrl.uoms;
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
                                      child: const Icon(Icons.scale,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(uoms[index].name,
                                          style: kCardTitle)),
                                  trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkGreen),
                                      child: const Icon(Icons.edit,
                                          size: 25, color: Colors.white)),
                                  onTap: () {
                                    invtCtrl.isUoMEdit.value = true;
                                    invtCtrl.uoMToEdit.value = uoms[index].id;
                                    Get.to(() => const UomForm());
                                  },
                                )));
                      },
                      itemCount: invtCtrl.uoms.length),
                )
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          invtCtrl.isUoMEdit.value = false;
          Get.to(const UomForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
