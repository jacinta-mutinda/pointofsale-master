import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/transactions/expense_form.dart';
import 'package:nawiri/core/home/transactions/transactions_ctrl.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/utils/functions.dart';

final transCtrl = Get.put(TransactionCtrl());

class ExpensesPage extends StatefulWidget {
  static const routeName = "/expenses";
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ScrollController _scrollctrl = ScrollController();
  TextEditingController searchCtrl = TextEditingController();
  final GlobalKey<FormState> _searchForm = GlobalKey<FormState>();
  bool _showBackToTopBtn = false;
  bool _isAddLoading = false;

  @override
  void initState() {
    super.initState();
    transCtrl.getExpesnses();
    _scrollctrl.addListener(() {
      if (_scrollctrl.position.pixels == _scrollctrl.position.maxScrollExtent) {
        listAppender(
            rangeList: transCtrl.rangeExpList, selectList: transCtrl.expenses);
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
        appBar: backAppBar(pageTitle: 'expenses', actions: <Widget>[]),
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
                          'All Expenses',
                          style: kTitle,
                        ),
                        smallPriBtn(
                            label: 'Add Expense',
                            txtColour: Colors.white,
                            bgColour: kDarkGreen,
                            isLoading: _isAddLoading,
                            function: () {
                              Get.to(const ExpenseForm());
                            }),
                      ])),
              Obx(() => transCtrl.showLoading.value
                  ? loadingWidget(label: 'Loading Expenses ...')
                  : transCtrl.showData.value
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
                                                    'Search by expense description',
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
                                                    transCtrl.searchFilter(
                                                        searchCtrl.text);
                                                  }
                                                })),
                                        GestureDetector(
                                            onTap: () {
                                              transCtrl.getExpesnses();
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
                                                    ' ${transCtrl.rangeExpList.length} ',
                                                style: kNeonTxt,
                                              ),
                                              const TextSpan(
                                                text: ' of ',
                                                style: kBlackTxt,
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${transCtrl.expenses.length} ',
                                                style: kDarkGreenTxt,
                                              ),
                                              const TextSpan(
                                                text: ' expenses',
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
                                      var expenses = transCtrl.rangeExpList;
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
                                                        expenses[index].payto,
                                                        style: kCardTitle)),
                                                subtitle: Text(
                                                    'Kes.${expenses[index].amount}',
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
                                                  transCtrl.singleExpense =
                                                      expenses[index];
                                                  Get.dialog(
                                                      const SingleExpense());
                                                },
                                              )));
                                    },
                                    itemCount: transCtrl.rangeExpList.length),
                              ),
                            ])
                      : noItemsWidget(label: 'No expenses Found'))
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

class SingleExpense extends StatefulWidget {
  static const routeName = "/SingleExpense";

  const SingleExpense({Key? key}) : super(key: key);

  @override
  _SingleExpenseState createState() => _SingleExpenseState();
}

class _SingleExpenseState extends State<SingleExpense> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Transaction Date: ${transCtrl.singleExpense.date}'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        labelSpan(
            mainLabel: 'Paid To', childLabel: transCtrl.singleExpense.payto),
        labelSpan(
            mainLabel: 'Reference Code',
            childLabel: transCtrl.singleExpense.ref),
        labelSpan(
            mainLabel: 'Description', childLabel: transCtrl.singleExpense.desc),
        labelSpan(
            mainLabel: 'Amount',
            childLabel: 'Kes${transCtrl.singleExpense.amount}'),
      ])
    ]);
  }
}
