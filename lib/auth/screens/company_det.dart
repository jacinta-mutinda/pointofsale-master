import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/auth/screens/personal_det.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class CompanyDetails extends StatefulWidget {
  static const routeName = "/companydetails";

  const CompanyDetails({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  TextEditingController busnamectrl = TextEditingController();
  TextEditingController addressctrl = TextEditingController();
  TextEditingController locctrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController tillnoctrl = TextEditingController();
  TextEditingController taglinectrl = TextEditingController();
  final auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final RegExp phoneNo = RegExp(r"^\+?0[0-9]{10}$");
  final RegExp tillNo = RegExp(r'^[0-9]+$');

  @override
  void initState() {
    super.initState();
  }

  bool isValidPhone(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return phoneNo.hasMatch(s);
  }

  bool isValidTill(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return tillNo.hasMatch(s);
  }

  void authCompanyDetails() {
    List userData = [
      busnamectrl.text,
      addressctrl.text,
      locctrl.text,
      phonectrl.text,
      tillnoctrl.text,
      taglinectrl
    ];
    Get.to(PersonalDetails(userData: userData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Create an Account', style: kPageTitle),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 22),
                    child: Text('Company Details', style: kTitle)),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: <Widget>[
                          formField(
                              label: 'Business Name',
                              require: true,
                              controller: busnamectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your business name';
                                }
                                return null;
                              }),
                          formField(
                              label: 'P.O BOX / Email Address',
                              require: true,
                              controller: addressctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Location',
                              require: true,
                              controller: locctrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your location';
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
                          formField(
                              label: 'Till Number',
                              require: true,
                              controller: phonectrl,
                              type: TextInputType.phone,
                              validator: (value) {
                                if (!isValidTill(value!)) {
                                  return 'Please enter a valid till Number';
                                }
                                return null;
                              }),
                          formField(
                              label: 'Receipt Footer',
                              require: true,
                              controller: taglinectrl,
                              type: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your receipt Footer';
                                }
                                return null;
                              }),
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
                      authCompanyDetails();
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