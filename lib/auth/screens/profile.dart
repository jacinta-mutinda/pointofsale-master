import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController busphonectrl = TextEditingController();
  TextEditingController passctrl = TextEditingController();

  TextEditingController busnamectrl = TextEditingController();
  TextEditingController addressctrl = TextEditingController();
  TextEditingController locctrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController tillnoctrl = TextEditingController();
  TextEditingController taglinectrl = TextEditingController();

  final auth = Get.put(AuthCtrl());
  final _formKey = GlobalKey<FormState>();
  final _isHidden = false.obs;
  bool _isLoading = false;

  _ProfilePageState();

  @override
  void initState() {
    super.initState();
    usernamectrl.text = auth.profile.username;
    emailctrl.text = auth.profile.address;
    addressctrl.text = auth.profile.busaddress;
    busphonectrl.text = auth.profile.phoneno.toString();
    passctrl.text = auth.profile.pin.toString();
    busnamectrl.text = auth.profile.busname;
    locctrl.text = auth.profile.location;
    phonectrl.text = auth.profile.phone.toString();
    tillnoctrl.text = auth.profile.till.toString();
    taglinectrl.text = auth.profile.recFooter;
  }

  @override
  void dispose() {
    busnamectrl.dispose();
    addressctrl.dispose();
    locctrl.dispose();
    busphonectrl.dispose();
    tillnoctrl.dispose();
    taglinectrl.dispose();
    usernamectrl.dispose();
    emailctrl.dispose();
    phonectrl.dispose();
    passctrl.dispose();
    super.dispose();
  }

  void authPersonalDetails() {
    List userData = [
      busnamectrl.text,
      addressctrl.text,
      locctrl.text,
      busphonectrl.text,
      tillnoctrl.text,
      taglinectrl.text,
      usernamectrl.text,
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
        appBar: secAppBar(pageTitle: 'Create Account'),
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
                              child: Text('Company Details', style: kSubTitle)),
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
                              controller: busphonectrl,
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
                          formField(
                              label: 'Till Number',
                              require: true,
                              controller: tillnoctrl,
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
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
                          descFormField(
                              label: 'Receipt Footer', controller: taglinectrl),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
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
                          )
                        ],
                      )),
                  priBtn(
                    bgColour: kDarkGreen,
                    txtColour: Colors.white,
                    label: 'Update Profile',
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
