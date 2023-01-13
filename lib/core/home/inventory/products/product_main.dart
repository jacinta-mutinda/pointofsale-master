import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/inventory/products/product_form.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = "/products";
  const ProductsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final invtCtrl = Get.put(InventoryCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Inventory', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Products', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var products = invtCtrl.products;
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
                                      child: const Icon(Icons.shopping_basket,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(products[index].name,
                                          style: kCardTitle)),
                                  subtitle: Text(
                                      'Kes.${products[index].retailMg}',
                                      style: kBlackTxt),
                                  trailing: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kDarkGreen),
                                      child: const Icon(Icons.edit,
                                          size: 25, color: Colors.white)),
                                  onTap: () {
                                    invtCtrl.isProdEdit.value = true;
                                    invtCtrl.prodToEdit.value =
                                        products[index].id;
                                    Get.to(() => const ProductForm());
                                  },
                                )));
                      },
                      itemCount: invtCtrl.products.length),
                )
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          invtCtrl.isProdEdit.value = false;
          Get.to(const ProductForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
