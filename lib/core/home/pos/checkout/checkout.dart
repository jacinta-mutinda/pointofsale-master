import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/pos/checkout/checkout_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

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
  TextEditingController paymthdctrl = TextEditingController();
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
    checkoutCtrl.setCheckoutForm();
  }

  @override
  void dispose() {
    balancectrl.dispose();
    paymthdctrl.dispose();
    cashAmtCtrl.dispose();
    bankAmtCtrl.dispose();
    mobileAmtCtrl.dispose();
    onAccAmtCtrl.dispose();
    refcodectrl.dispose();
    bankAccctrl.dispose();
    bankrefcodectrl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: secAppBar(pageTitle: 'Checkout'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 25, left: 30, right: 30),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child:
                                  Text('Checkout details', style: kSubTitle)),
                          smallPriBtn(
                              label: 'Edit Pay Method',
                              txtColour: Colors.white,
                              bgColour: kDarkGreen,
                              isLoading: _isLoading,
                              function: () {
                                checkoutCtrl.reset();
                                Get.dialog(const SelectPayMethod());
                              })
                        ]),
                    Column(children: [
                      Obx(() => checkoutCtrl.isBankPay.value
                          ? Column(children: [
                              formDropDownField(
                                  label: 'Bank Account',
                                  dropdownValue:
                                      checkoutCtrl.bankAccDropdown.value,
                                  dropItems: bankingCtrl.bankAccStrs,
                                  bgcolor: kGrey,
                                  function: (String? newValue) {
                                    checkoutCtrl.setBankAcc();
                                    setState(() {
                                      checkoutCtrl.bankAccDropdown.value =
                                          newValue!;
                                    });
                                  }),
                              formField(
                                  label: 'Transaction Reference Code',
                                  require: true,
                                  controller: bankrefcodectrl,
                                  type: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
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
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the amount paid';
                                    }
                                    return null;
                                  }),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Divider(
                                    color: kDarkGreen,
                                  )),
                            ])
                          : const SizedBox()),
                      Obx(() => checkoutCtrl.isCashPay.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  formField(
                                      label: 'Amount Paid via cash (in Kes)',
                                      require: true,
                                      controller: cashAmtCtrl,
                                      type: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the amount paid';
                                        }
                                        return null;
                                      }),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Divider(
                                        color: kDarkGreen,
                                      ))
                                ])
                          : const SizedBox()),
                      Obx(() => checkoutCtrl.isMpesaPay.value
                          ? Column(children: [
                              formField(
                                  label: 'Mobile Money Reference Code',
                                  require: true,
                                  controller: refcodectrl,
                                  type: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the reference code';
                                    }
                                    return null;
                                  }),
                              formField(
                                  label:
                                      'Amount Paid via mobile money (in Kes)',
                                  require: true,
                                  controller: mobileAmtCtrl,
                                  type: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the amount paid';
                                    }
                                    return null;
                                  }),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Divider(
                                    color: kDarkGreen,
                                  )),
                            ])
                          : const SizedBox()),
                      Obx(() => checkoutCtrl.isOnAccPay.value
                          ? Column(children: [
                              formField(
                                  label: 'Customer Name',
                                  require: false,
                                  controller: checkoutCtrl.customerctrl,
                                  type: TextInputType.name,
                                  readonly: true,
                                  validator: (value) {
                                    setState(() {
                                      checkoutCtrl.customerctrl.text =
                                          checkoutCtrl.selectedCustAcc.value;
                                    });
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a customer Account';
                                    }
                                    return null;
                                  }),
                              formField(
                                  label:
                                      'Amount Paid on customer account (in Kes)',
                                  require: true,
                                  controller: onAccAmtCtrl,
                                  type: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the amount paid';
                                    }
                                    return null;
                                  }),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Divider(
                                    color: kDarkGreen,
                                  ))
                            ])
                          : const SizedBox()),
                      formField(
                          label: 'Balance (in Kes)',
                          require: false,
                          controller: balancectrl,
                          readonly: true,
                          type: TextInputType.number,
                          validator: (value) {
                            var bank = 0;
                            var onAcc = 0;
                            var mobile = 0;
                            var cash = 0;
                            if (cashAmtCtrl.text.isEmpty) {
                              cash = 0;
                            } else {
                              cash = int.parse(cashAmtCtrl.text);
                            }
                            if (bankAmtCtrl.text.isEmpty) {
                              bank = 0;
                            } else {
                              bank = int.parse(bankAmtCtrl.text);
                            }
                            if (mobileAmtCtrl.text.isEmpty) {
                              mobile = 0;
                            } else {
                              mobile = int.parse(mobileAmtCtrl.text);
                            }
                            if (onAccAmtCtrl.text.isEmpty) {
                              onAcc = 0;
                            } else {
                              onAcc = int.parse(onAccAmtCtrl.text);
                            }
                            var paidTotal = cash + bank + onAcc + mobile;
                            var bal = (paidTotal - posCtrl.cartSale.total.value) *-1;
                            if (bal < 0) {
                              setState(() {
                                balancectrl.text = 'Kes.$bal';
                              });
                            } else {
                              setState(() {
                                balancectrl.text = 'Kes.$bal';
                              });
                            }
                            return null;
                          }),
                    ]),
                    Row(
                      
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          Padding(
                              // padding: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.only(left: 220),
                              child:
                              Text("Total", style: kTitle))

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
                          checkoutCtrl.checkDetData.payMthd = paymthdctrl.text;
                          if (checkoutCtrl.isCashPay.value) {
                            checkoutCtrl.checkDetData.bankPaid =
                                bankAmtCtrl.text;
                            checkoutCtrl.checkDetData.cashPaid =
                                cashAmtCtrl.text;
                            checkoutCtrl.checkDetData.onAccPaid =
                                onAccAmtCtrl.text;
                            checkoutCtrl.checkDetData.mobilePaid =
                                mobileAmtCtrl.text;
                          } else if (checkoutCtrl.isBankPay.value) {
                            checkoutCtrl.checkDetData.bankAccId =
                                checkoutCtrl.selectedBankId.value.toString();
                            checkoutCtrl.checkDetData.bankRefCode =
                                bankrefcodectrl.text;
                          } else if (checkoutCtrl.isMpesaPay.value) {
                            checkoutCtrl.checkDetData.mpesaRefCode =
                                refcodectrl.text;
                          } else {
                            checkoutCtrl.checkDetData.custAccId =
                                checkoutCtrl.selectedCustAccId.value;
                          }
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

class SelectPayMethod extends StatefulWidget {
  static const routeName = "/_SelectPayMethod";

  const SelectPayMethod({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectPayMethodState createState() => _SelectPayMethodState();
}

class _SelectPayMethodState extends State<SelectPayMethod> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popupScaffold(children: [
      popupHeader(label: 'Select payment methods'),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var payMthds = checkoutCtrl.paymethods;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: CheckboxListTile(
                    title: Text(payMthds[index].name,
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                            color: kDarkGreen)),
                    checkColor: kDarkGreen,
                    activeColor: kLightGreen,
                    value: payMthds[index].selected.value,
                    onChanged: (value) {
                      setState(() {
                        if (checkoutCtrl.selectedMthds
                            .contains(payMthds[index].name)) {
                          checkoutCtrl.selectedMthds
                              .remove(payMthds[index].name);
                        } else {
                          checkoutCtrl.selectedMthds.add(payMthds[index].name);
                        }
                        checkoutCtrl.setCheckoutForm();
                        payMthds[index].selected.value = value!;
                      });
                    },
                  ),
                );
              },
              itemCount: checkoutCtrl.paymethods.length),
        )
      ])
    ]);
  }
}

class CustomerList extends StatefulWidget {
  static const routeName = "/_CustomerList";

  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
