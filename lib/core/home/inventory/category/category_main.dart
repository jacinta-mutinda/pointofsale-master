import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/category/category_form.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class CategoriesPage extends StatefulWidget {
  static const routeName = "/category";
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final invtCtrl = Get.put(InventoryCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Categories', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Categories', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var categories = invtCtrl.categories;
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
                                      child: const Icon(Icons.category,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(categories[index].name,
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
                                    invtCtrl.isCatEdit.value = true;
                                    invtCtrl.catToEdit.value =
                                        categories[index].id;
                                    Get.to(() => const CategoryForm());
                                  },
                                )));
                      },
                      itemCount: invtCtrl.categories.length),
                )
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          invtCtrl.isCatEdit.value = false;
          Get.to(const CategoryForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
