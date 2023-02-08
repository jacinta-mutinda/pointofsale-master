import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/urls.dart';

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
  bool _isChangeLoading = false;
  String companyName='';
  String companyEmail='';
  String companyPhone='';
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

  final auth = Get.put(AuthCtrl());
  @override
  void initState() {
    super.initState();
    auth.getCompanyName().then((value) {
      setState(() {
        companyName = value;
        print(companyName);
      });
    });
    auth.getCompanyEmail().then((value) {
      setState(() {
        companyEmail = value;
        print(companyEmail);
      });
    });
    auth.getCompanyPhone().then((value) {
      setState(() {
        companyPhone = value;
        print(companyPhone);
      });
    });
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
    otpFormKey.currentState!.save();
    otp = int.parse(_fieldOne.text +
        _fieldTwo.text +
        _fieldThree.text +
        _fieldFour.text +
        _fieldFive.text +
        _fieldSix.text);
    auth.verifyAccount(otp!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 80, bottom: 10),
                      child: Image.asset('assets/images/nawiri-logo.png',
                          width: 150, height: 150, fit: BoxFit.fill)),
                  Obx(() => mthdSelected.value
                      ? Form(
                          key: otpFormKey,
                          child: Column(
                            children: <Widget>[
                              const Text(
                                "Enter the OTP code sent to your inbox",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
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
                                  if (otpFormKey.currentState!.validate()) {
                                    verifyAccount();
                                  }
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                              priBtn(
                                bgColour: kDarkGreen,
                                txtColour: Colors.white,
                                label: 'Change Verification Method',
                                isLoading: _isChangeLoading,
                                function: () async {
                                  setState(() {
                                    _isChangeLoading = true;
                                  });
                                  otpFormKey.currentState!.reset();
                                  mthdSelected.value = false;
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  setState(() {
                                    _isChangeLoading = false;
                                  });
                                },
                              ),
                            ],
                          ))
                      : Column(
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
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
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
                                      final random = Random();
                                      int otp=random.nextInt(1000000);
                                      storeOTP(otp);
                                      print(otp);
                                      sendEmail(companyName,companyEmail,"Your One time pin is "+otp.toString());
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
                                      final random = Random();
                                      int otp=random.nextInt(1000000);
                                      storeOTP(otp);
                                      print(otp);
                                      sendSms("Hello "+companyName+" your one time pin is "+otp.toString(),companyPhone);
                                      _isSmsLoading = true;
                                    });
                                    verifyMthd('sms');
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    setState(() {
                                      _isSmsLoading = false;
                                    });
                                  })
                            ]))
                ])));
  }
  Future sendEmail(String name, String email, String message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_cg2v1hd';
    const templateId = 'template_dtxy227';
    const userId = 'w9qTOqmVrugi8SSwF';
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},//This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_name': name,
            'to':email,
            'from_email': 'okombakevin@gmail.com',
            'message': message
          }
        }));
    print(response.body);
    return response.statusCode;
  }
  Future sendSms(String message,String phoneNumber) async {
    var body = jsonEncode({
      "api_key":"c24275a1a5c64c9c8835076fab40e2d7",
      "sender_id":"SOFTBYTE",
      "message":message,
      "phone":phoneNumber
    });
    try {
      final response =
      await http.post(Uri.parse(sendSmsUrl), body:body,headers: {'Content-Type': 'application/json'});
      print(response.body);
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        showSnackbar(
            path: Icons.close_rounded,
            title: "Sms sent ",
            subtitle: "");

        return;
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed to load cash drawer float details!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  Future<void> storeOTP(int otp) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("otp", otp.toString());
  }
}
