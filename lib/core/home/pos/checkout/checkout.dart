import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/pos/checkout/checkout_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/utils/functions.dart';

final checkoutCtrl = Get.put(CheckoutCtrl());
final bankingCtrl = Get.put(BankingCtrl());

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  RxInt paidTotal = 0.obs;
  TextEditingController cashAmtCtrl = TextEditingController();
  TextEditingController bankAmtCtrl = TextEditingController();
  TextEditingController onAccAmtCtrl = TextEditingController();
  TextEditingController mobileAmtCtrl = TextEditingController();
  TextEditingController refcodectrl = TextEditingController();
  TextEditingController bankAccctrl = TextEditingController();
  TextEditingController bankrefcodectrl = TextEditingController();
  TextEditingController balancectrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bankingCtrl.getBanks();
    mobileAmtCtrl.text = '0';
    onAccAmtCtrl.text = '0';
    bankAmtCtrl.text = '0';
    cashAmtCtrl.text = '0';
    refcodectrl.text = '';
    bankAccctrl.text = '';
    balancectrl.text = '';
    bankrefcodectrl.text = '';
  }

  @override
  void dispose() {
    balancectrl.dispose();
    cashAmtCtrl.dispose();
    bankAmtCtrl.dispose();
    mobileAmtCtrl.dispose();
    onAccAmtCtrl.dispose();
    refcodectrl.dispose();
    bankAccctrl.dispose();
    bankrefcodectrl.dispose();
    super.dispose();
  }

  void setBalance() {
    var bank = 0;
    var onAcc = 0;
    var mobile = 0;
    var cash = 0;
    if (cashAmtCtrl.text == '') {
      cash = 0;
    } else {
      cash = int.parse(cashAmtCtrl.text);
    }
    if (bankAmtCtrl.text == '') {
      bank = 0;
    } else {
      bank = int.parse(bankAmtCtrl.text);
    }
    if (mobileAmtCtrl.text == '') {
      mobile = 0;
    } else {
      mobile = int.parse(mobileAmtCtrl.text);
    }
    if (onAccAmtCtrl.text == '') {
      onAcc = 0;
    } else {
      onAcc = int.parse(onAccAmtCtrl.text);
    }
    paidTotal.value = cash + bank + onAcc + mobile;
    var bal = (paidTotal.value - posCtrl.cartSale.total.value);
    if (bal < 0) {
      balancectrl.text = 'Kes.$bal';
    } else {
      balancectrl.text = 'Kes.$bal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: secAppBar(pageTitle: 'Checkout'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 25, left: 30, right: 30),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Divider(
                      color: kDarkGreen,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: kPageTitle),
                              Obx(() => Text(
                                  'Kes.${formatAmount((posCtrl.cartSale.total).toString())}',
                                  style: kPageTitle))
                            ])),
                    const Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Divider(
                          color: kDarkGreen,
                        )),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child:
                            Text('Enter Checkout details', style: kSubTitle)),
                    Column(children: [
                      Column(children: [
                        formDropDownField(
                            label: 'Bank Account',
                            dropdownValue: checkoutCtrl.bankAccDropdown.value,
                            dropItems: bankingCtrl.bankAccStrs,
                            bgcolor: kGrey,
                            function: (String? newValue) {
                              checkoutCtrl.setBankAcc();
                              setState(() {
                                checkoutCtrl.bankAccDropdown.value = newValue!;
                              });
                            }),
                        formField(
                            label: 'Transaction Reference Code',
                            require: true,
                            controller: bankrefcodectrl,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter the reference code';
                              }
                              return null;
                            }),
                        formField(
                            label: 'Amount Paid via bank (in Kes)',
                            require: true,
                            controller: bankAmtCtrl,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter the amount paid';
                              } else {
                                setBalance();
                              }
                              return null;
                            }),
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Divider(
                              color: kDarkGreen,
                            )),
                      ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formField(
                                label: 'Amount Paid via cash (in Kes)',
                                require: true,
                                controller: cashAmtCtrl,
                                type: TextInputType.number,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please enter the amount paid';
                                  } else {
                                    setBalance();
                                  }
                                  return null;
                                }),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Divider(
                                  color: kDarkGreen,
                                ))
                          ]),
                      Column(children: [
                        formField(
                            label: 'Mobile Money Reference Code',
                            require: true,
                            controller: refcodectrl,
                            type: TextInputType.name,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter the reference code';
                              }
                              return null;
                            }),
                        formField(
                            label: 'Amount Paid via mobile money (in Kes)',
                            require: true,
                            controller: mobileAmtCtrl,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter the amount paid';
                              } else {
                                setBalance();
                              }
                              return null;
                            }),
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Divider(
                              color: kDarkGreen,
                            )),
                      ]),
                      Column(children: [
                        formField(
                            label: 'Customer Name',
                            require: false,
                            controller: checkoutCtrl.customerctrl,
                            type: TextInputType.name,
                            readonly: true,
                            validator: (value) {
                              checkoutCtrl.customerctrl.text =
                                  checkoutCtrl.selectedCustAcc.value;
                              if (value == null) {
                                return 'Please select a customer Account';
                              }
                              return null;
                            }),
                        formField(
                            label: 'Amount Paid on customer account (in Kes)',
                            require: true,
                            controller: onAccAmtCtrl,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter the amount paid';
                              } else {
                                setBalance();
                              }
                              return null;
                            }),
                        const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Divider(
                              color: kDarkGreen,
                            ))
                      ]),
                      formField(
                          label: 'Balance (in Kes)',
                          require: false,
                          controller: balancectrl,
                          readonly: true,
                          type: TextInputType.number,
                          validator: (value) {
                            return null;
                          }),
                    ]),
                    priBtn(
                      bgColour: kDarkGreen,
                      txtColour: Colors.white,
                      label: 'Complete Sale',
                      isLoading: _isLoading,
                      function: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          checkoutCtrl.checkDetData.bankPaid = bankAmtCtrl.text;
                          checkoutCtrl.checkDetData.cashPaid = cashAmtCtrl.text;
                          checkoutCtrl.checkDetData.onAccPaid =
                              onAccAmtCtrl.text;
                          checkoutCtrl.checkDetData.mobilePaid =
                              mobileAmtCtrl.text;

                          checkoutCtrl.checkDetData.bankAccId =
                              checkoutCtrl.selectedBankId.value.toString();
                          checkoutCtrl.checkDetData.bankRefCode =
                              bankrefcodectrl.text;

                          checkoutCtrl.checkDetData.mpesaRefCode =
                              refcodectrl.text;

                          checkoutCtrl.checkDetData.custAccId =
                              checkoutCtrl.selectedCustAccId.value;
                          checkoutCtrl.checkDetData.totalPaid =
                              paidTotal.value.toString();
                          checkoutCtrl.checkDetData.balance = balancectrl.text;

                          checkoutCtrl.completeSale();
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    )
                  ]))),
    );
  }
}

class CustomerList extends StatefulWidget {
  static const routeName = "/_CustomerList";

  const CustomerList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  // ignore: unused_field
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchNamectrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchNamectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Select an account'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Obx(
            () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var customers = checkoutCtrl.custList;
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: ListTile(
                          title: Text(customers[index].name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  color: kDarkGreen)),
                          leading: Radio(
                            activeColor: kLightGreen,
                            value: customers[index].name,
                            groupValue: checkoutCtrl.selectedCustAcc.value,
                            onChanged: (value) {
                              setState(() {
                                checkoutCtrl.selectedCustAcc.value = value!;
                                checkoutCtrl.setCustAcc();
                              });
                            },
                          )));
                },
                itemCount: checkoutCtrl.custList.length),
          ),
        )
      ])
    ]);
  }
}
