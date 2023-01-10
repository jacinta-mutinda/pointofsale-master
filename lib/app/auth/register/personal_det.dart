import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/app/auth/auth_ctrl.dart';
import 'package:nawiri/app/auth/login/login.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class PersonalDetails extends StatefulWidget {
  static const routeName = "/personalDetails";

  const PersonalDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController firstnamectrl = TextEditingController();
  TextEditingController lastnamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController passctrl = TextEditingController();
  TextEditingController confirmpassctrl = TextEditingController();
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final _isHidden = false.obs;
  bool _isLoading = false;

  final RegExp safcomNo = RegExp(
      r'^(?:254|\+254|0)?(7(?:(?:[12][0-9])|(?:0[0-8])|(9[0-2]))[0-9]{6})$');

  bool isValidPhone(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return safcomNo.hasMatch(s);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstnamectrl.dispose();
    lastnamectrl.dispose();
    emailctrl.dispose();
    phonectrl.dispose();
    passctrl.dispose();
    confirmpassctrl.dispose();
    super.dispose();
  }

  void authPersonalDetails() {
    List userData = [
      firstnamectrl.text,
      lastnamectrl.text,
      emailctrl.text,
      phonectrl.text,
      passctrl.text,
    ];
    auth.signUp(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kDarkGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset('assets/images/walletlogo2.png',
                      width: 60, height: 60, fit: BoxFit.fill),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 22),
                    child: Text(
                      'Wavvy Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          formField(
                              label: 'First Name',
                              require: true,
                              controller: firstnamectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your  first name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Last Name',
                              require: true,
                              controller: lastnamectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your  last name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Email Address',
                              require: true,
                              controller: emailctrl,
                              type: TextInputType.emailAddress,
                              validator: (value) {
                                if (!GetUtils.isEmail(value!)) {
                                  return 'Please enter a Valid email';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Phone Number',
                              require: true,
                              controller: phonectrl,
                              type: TextInputType.phone,
                              validator: (value) {
                                if (!isValidPhone(value!)) {
                                  return 'Please enter a valid phone Number';
                                }
                                return null;
                              }),
                          passwordField(
                            isHidden: _isHidden,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password';
                              }
                              if (value.length < 6) {
                                return 'Password must be 6 characters or more';
                              }
                              return null;
                            },
                            controller: passctrl,
                            label: 'Password',
                          ),
                          passwordField(
                            isHidden: _isHidden,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your Password';
                              }
                              if (value != passctrl.text) {
                                return 'Passwords do not Match!';
                              }

                              return null;
                            },
                            controller: confirmpassctrl,
                            label: 'Confirm Password',
                          ),
                        ],
                      )),
                ),
                priBtn(
                  bgColour: kDarkGreen,
                  txtColour: Colors.white,
                  label: 'Next',
                  isLoading: _isLoading,
                  function: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      authPersonalDetails();
                    }
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: textSpan(
                      mainLabel: "Already have an account? ",
                      childLabel: 'Log In',
                      function: () {
                        Get.off(Login.routeName);
                      }),
                )
              ])),
    );
  }
}
