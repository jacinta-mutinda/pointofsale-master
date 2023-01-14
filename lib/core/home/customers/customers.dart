import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_form.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';

class CustomersPage extends StatefulWidget {
  static const routeName = "/customers";
  const CustomersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final customersCtrl = Get.put(CustomerCtrl());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Customers', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('All Customers', style: kTitle)),
                Obx(
                  () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var customers = customersCtrl.customers;
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
                                      child: const Icon(Icons.person,
                                          size: 20, color: Colors.white)),
                                  title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(customers[index].name,
                                          style: kCardTitle)),
                                  subtitle: Text(
                                      customers[index].phoneno.toString(),
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
                                    customersCtrl.isCustEdit.value = true;
                                    customersCtrl.custToEdit.value =
                                        customers[index].id;
                                    customersCtrl.billsToShow.value =
                                        customers[index].id;
                                    await customersCtrl.getCustSales();
                                  },
                                )));
                      },
                      itemCount: customersCtrl.customers.length),
                ),
              ]))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDarkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          customersCtrl.isCustEdit.value = false;
          Get.to(const CustomerForm());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
