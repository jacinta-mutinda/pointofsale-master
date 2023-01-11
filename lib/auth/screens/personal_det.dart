// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class PersonalDetails extends StatefulWidget {
  static const routeName = "/personalDetails";

  final List userData;

  const PersonalDetails({Key? key, required this.userData}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDetailsState createState() => _PersonalDetailsState(userData);
}

class _PersonalDetailsState extends State<PersonalDetails> {
  late List userData;
  TextEditingController usernamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController passctrl = TextEditingController();
  TextEditingController confirmpassctrl = TextEditingController();
  final RegExp phoneNo = RegExp(r"^\+?0[0-9]{10}$");
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final _isHidden = false.obs;
  bool _isLoading = false;

  _PersonalDetailsState(this.userData);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernamectrl.dispose();
    emailctrl.dispose();
    phonectrl.dispose();
    passctrl.dispose();
    confirmpassctrl.dispose();
    super.dispose();
  }

  bool isValidPhone(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return phoneNo.hasMatch(s);
  }

  void authPersonalDetails() {
    List persData = [
      usernamectrl.text,
      emailctrl.text,
      phonectrl.text,
      passctrl.text,
    ];
    for (final item in persData) {
      userData.add(item);
    }
    auth.signUp(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          iconTheme: const IconThemeData(color: kDarkGreen, size: 28),
          title: const Text('Create an Account',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen)),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child:
                                  Text('Personal Details', style: kSubTitle)),
                          formField(
                              label: 'Username',
                              require: true,
                              controller: usernamectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
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
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Phone Number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter your 10-digit phone number';
                                }
                                return null;
                              }),
                          passwordField(
                            isHidden: _isHidden,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your 4-digit Pin';
                              }
                              if (value.length != 4) {
                                return 'Your pin must be 4 characters';
                              }
                              return null;
                            },
                            controller: passctrl,
                            label: 'Pin',
                          ),
                          passwordField(
                            isHidden: _isHidden,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your Pin';
                              }
                              if (value != passctrl.text) {
                                return 'Pins do not Match!';
                              }

                              return null;
                            },
                            controller: confirmpassctrl,
                            label: 'Confirm Pin',
                          ),
                        ],
                      )),
                  priBtn(
                    bgColour: kDarkGreen,
                    txtColour: Colors.white,
                    label: 'Create Account',
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
                  )
                ])));
  }
}
