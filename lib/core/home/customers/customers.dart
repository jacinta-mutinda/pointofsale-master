import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/customers/customer_form.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/utils/functions.dart';

class CustomersPage extends StatefulWidget {
  static const routeName = "/customers";
  const CustomersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final customersCtrl = Get.put(CustomerCtrl());
  final ScrollController _scrollctrl = ScrollController();
  TextEditingController searchCtrl = TextEditingController();
  final GlobalKey<FormState> _searchForm = GlobalKey<FormState>();
  bool _showBackToTopBtn = false;
  bool _isAddLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollctrl.addListener(() {
      if (_scrollctrl.position.pixels == _scrollctrl.position.maxScrollExtent) {
        listAppender(
            rangeList: customersCtrl.rangeCustList,
            selectList: customersCtrl.customers);
      }
      setState(() {
        if (_scrollctrl.offset >= 400) {
          _showBackToTopBtn = true;
        } else {
          _showBackToTopBtn = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollctrl.dispose();
  }

  void _scrollToTop() {
    _scrollctrl.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(pageTitle: 'Customers', actions: <Widget>[]),
        body: SingleChildScrollView(
            controller: _scrollctrl,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Customers',
                          style: kTitle,
                        ),
                        smallPriBtn(
                            label: 'Add Customer',
                            txtColour: Colors.white,
                            bgColour: kDarkGreen,
                            isLoading: _isAddLoading,
                            function: () {
                              customersCtrl.isCustEdit.value = false;
                              customersCtrl.fieldsRequired.value = false;
                              Get.to(const CustomerForm());
                            }),
                      ])),
              Obx(() => customersCtrl.showLoading.value
                  ? loadingWidget(label: 'Loading Customers ...')
                  : customersCtrl.showData.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Form(
                                            key: _searchForm,
                                            child: searchForm(
                                                label:
                                                    'Search by customer name',
                                                controller: searchCtrl,
                                                suffix: true,
                                                inputType: TextInputType.text,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter search name';
                                                  }
                                                  return null;
                                                },
                                                searchFunction: () {
                                                  if (_searchForm.currentState!
                                                      .validate()) {
                                                    customersCtrl.searchFilter(
                                                        searchCtrl.text);
                                                  }
                                                })),
                                        GestureDetector(
                                            onTap: () {
                                              customersCtrl.getCustomers();
                                              searchCtrl.clear();
                                            },
                                            child: const Icon(
                                              Icons.refresh,
                                              color: kDarkGreen,
                                              size: 25,
                                            ))
                                      ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, right: 5),
                                        child: Obx(() => RichText(
                                                text: TextSpan(children: [
                                              const TextSpan(
                                                text: 'Showing ',
                                                style: kBlackTxt,
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${customersCtrl.rangeCustList.length} ',
                                                style: kNeonTxt,
                                              ),
                                              const TextSpan(
                                                text: ' of ',
                                                style: kBlackTxt,
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${customersCtrl.customers.length} ',
                                                style: kDarkGreenTxt,
                                              ),
                                              const TextSpan(
                                                text: ' customers',
                                                style: kBlackTxt,
                                              )
                                            ]))))
                                  ]),
                              Obx(
                                () => ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var customers =
                                          customersCtrl.rangeCustList;
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Card(
                                              color: kGrey,
                                              elevation: 7.0,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: kLightGreen),
                                                    child: const Icon(
                                                        Icons.person,
                                                        size: 20,
                                                        color: Colors.white)),
                                                title: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Text(
                                                        customers[index].name,
                                                        style: kCardTitle)),
                                                subtitle: Text(
                                                    customers[index].phoneno,
                                                    style: kCardTitle),
                                                trailing: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: kDarkGreen),
                                                    child: const Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                        size: 25,
                                                        color: Colors.white)),
                                                onTap: () async {
                                                  customersCtrl
                                                      .isCustEdit.value = true;
                                                  customersCtrl.fieldsRequired
                                                      .value = false;
                                                  customersCtrl
                                                          .custToEdit.value =
                                                      customers[index].id;
                                                  customersCtrl
                                                          .billsToShow.value =
                                                      customers[index].id;
                                                  await customersCtrl
                                                      .getCustSales();
                                                },
                                              )));
                                    },
                                    itemCount:
                                        customersCtrl.rangeCustList.length),
                              ),
                            ])
                      : noTransactionsWidget(label: 'No Customers Found'))
            ]))),
        floatingActionButton: _showBackToTopBtn
            ? FloatingActionButton(
                elevation: 2.0,
                backgroundColor: kDarkGreen,
                onPressed: _scrollToTop,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
              )
            : Container());
  }
}
