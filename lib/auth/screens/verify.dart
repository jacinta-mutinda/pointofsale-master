import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class VerifyAccount extends StatefulWidget {
  static const routeName = "/verifyaccount";

  const VerifyAccount({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  RxBool mthdSelected = false.obs;
  bool _isLoading = false;
  bool _isEmailLoading = false;
  bool _isSmsLoading = false;
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  TextEditingController passctrl = TextEditingController();
  TextEditingController confirmpassctrl = TextEditingController();
  int? otp;

  Auth auth = Get.put(Auth());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();
    _fieldFive.dispose();
    _fieldSix.dispose();
    passctrl.dispose();
    confirmpassctrl.dispose();
  }

  void verifyMthd(String method) {
    // send message to the chosen destination
    mthdSelected.value = true;
  }

  void verifyAccount() {
    final isValid = otpFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    otpFormKey.currentState!.save();
    otp = int.parse(
        _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text);
    auth.verifyAccount(otp!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
            padding:
                const EdgeInsets.only(top: 30, bottom: 10, left: 25, right: 25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Image.asset('assets/images/nawiri-logo.png',
                          width: 100, height: 100, fit: BoxFit.fill)),
                  Obx(() => mthdSelected.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Text(
                                "Verify Account",
                                style: kPageTitle,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    "How would you like to receive your verification code?",
                                    style: kBlackTxt,
                                  )),
                              priBtn(
                                  label: 'Send me an email',
                                  txtColour: Colors.white,
                                  bgColour: kDarkGreen,
                                  isLoading: _isEmailLoading,
                                  function: () async {
                                    setState(() {
                                      _isEmailLoading = true;
                                    });
                                    verifyMthd('email');
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    setState(() {
                                      _isEmailLoading = false;
                                    });
                                  }),
                              priBtn(
                                  label: 'Send me an sms',
                                  txtColour: Colors.white,
                                  bgColour: kDarkGreen,
                                  isLoading: _isSmsLoading,
                                  function: () async {
                                    setState(() {
                                      _isSmsLoading = true;
                                    });
                                    verifyMthd('sms');
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    setState(() {
                                      _isSmsLoading = false;
                                    });
                                  })
                            ])
                      : Form(
                          key: otpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Enter the otp code sent to your inbox",
                                style: kSubTitle,
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      otpField(
                                          controller: _fieldOne,
                                          context: context),
                                      otpField(
                                          controller: _fieldTwo,
                                          context: context),
                                      otpField(
                                          controller: _fieldThree,
                                          context: context),
                                      otpField(
                                          controller: _fieldFour,
                                          context: context),
                                      otpField(
                                          controller: _fieldFive,
                                          context: context),
                                      otpField(
                                          controller: _fieldSix,
                                          context: context),
                                    ],
                                  )),
                              priBtn(
                                bgColour: kDarkGreen,
                                txtColour: Colors.white,
                                label: 'Verify Account',
                                isLoading: _isLoading,
                                function: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  verifyAccount();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            ],
                          )))
                ])));
  }
}