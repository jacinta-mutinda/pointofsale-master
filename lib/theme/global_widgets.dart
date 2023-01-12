import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/auth/screens/profile.dart';
import 'package:nawiri/core/home/billings.dart';
import 'package:nawiri/theme/constants.dart';

final auth = Auth();

void showSnackbar({required String title, required String subtitle, path}) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: kDarkGreen,
    colorText: Colors.white,
    icon: Icon(path, size: 28, color: kNeonGreen),
    snackPosition: SnackPosition.BOTTOM,
  );
}

Widget priBtn(
    {required String label,
    required Color txtColour,
    required Color bgColour,
    required bool isLoading,
    required void Function()? function}) {
  return Container(
    width: 250,
    height: 70,
    padding: const EdgeInsets.symmetric(vertical: 10),
    alignment: Alignment.center,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 70),
        backgroundColor: bgColour,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: (isLoading)
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              ))
          : Text(label,
              style: TextStyle(
                  color: txtColour,
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
    ),
  );
}

PreferredSizeWidget mainAppBar({required String pageTitle}) {
  return AppBar(
      backgroundColor: kDarkGreen,
      elevation: 4,
      toolbarHeight: 80,
      title: Text(pageTitle, style: kAppBarTitle),
      centerTitle: true,
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Get.to(const BillingsPage());
              },
              child: const Icon(
                Icons.wallet,
                color: Colors.white,
                size: 24,
              ),
            ))
      ]);
}

PreferredSizeWidget secAppBar({required String pageTitle}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 80,
    iconTheme: const IconThemeData(color: kDarkGreen, size: 28),
    title: Text(pageTitle, style: kPageTitle),
  );
}

Widget mainDrawer() {
  return Drawer(
      child: Column(
    children: [
      Expanded(
          child: ListView(children: <Widget>[
        SizedBox(
            child: DrawerHeader(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'nawiri',
                  style: TextStyle(
                      color: kDarkGreen,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 48),
                )),
            Text(
              'Growing with you',
              style: TextStyle(
                  color: kNeonGreen,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: <Widget>[
            ListTile(
                leading: const Icon(Icons.person, color: kDarkGreen, size: 26),
                title: const Text('Profile', style: kDrawerTxt),
                selectedTileColor: kDarkGreen,
                selectedColor: Colors.white,
                tileColor: const Color(0xFFD5D5D5),
                textColor: kDarkGreen,
                onTap: () {
                  Get.to(const ProfilePage());
                }),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                    leading:
                        const Icon(Icons.logout, color: kDarkGreen, size: 26),
                    title: const Text('Sign Out', style: kDrawerTxt),
                    selectedTileColor: kDarkGreen,
                    selectedColor: Colors.white,
                    tileColor: const Color(0xFFD5D5D5),
                    textColor: kDarkGreen,
                    onTap: () {
                      auth.logout();
                    })),
          ]),
        ),
      ])),
      SizedBox(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Image.asset('assets/images/nawiri-logo.png',
                          width: 40, height: 40)),
                  const Text(
                    'Softbyte © 2023',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ],
              )))
    ],
  ));
}

Widget navMenu({required navItems}) {
  return ListView(
    children: <Widget>[
      const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text('Select an option:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500))),
      SizedBox(
        child: Column(children: navItems),
      ),
    ],
  );
}

Widget navItem({required iconPath, required label, required dynamic goTo}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
          leading: Icon(iconPath, color: Colors.white, size: 22),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
            size: 22,
          ),
          title: Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito')),
          tileColor: kDarkGreen,
          textColor: Colors.white,
          selectedTileColor: kNeonGreen,
          onTap: () {
            Get.to(goTo);
          }));
}

// ---------------- Auth Widgets

Widget formField(
    {required label,
    required require,
    required controller,
    type,
    required final String? Function(String?) validator}) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: kDarkGreen)),
              TextSpan(
                text: require ? ' *' : '',
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: kPrimaryRed),
              ),
            ]))),
        SizedBox(
          height: 50,
          child: TextFormField(
            cursorColor: kDarkGreen,
            controller: controller,
            keyboardType: type,
            validator: validator,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.black),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        )
      ]));
}

Widget passwordField(
    {required label,
    required = true,
    required RxBool isHidden,
    type,
    required controller,
    required final String? Function(String?) validator}) {
  return Obx(() => Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: kPrimaryRed),
              ),
            ]))),
        SizedBox(
          height: 50,
          child: TextFormField(
            keyboardType: type,
            cursorColor: kDarkGreen,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.black),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              suffix: InkWell(
                onTap: () {
                  isHidden.toggle();
                },
                child: Icon(
                  isHidden.value ? Icons.visibility : Icons.visibility_off,
                  color: kDarkGreen,
                ),
              ),
            ),
            obscureText: !isHidden.value,
            controller: controller,
            validator: validator,
          ),
        )
      ])));
}

Widget textSpan(
    {required mainLabel,
    required childLabel,
    required final void Function()? function}) {
  return Container(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
          onTap: function,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: mainLabel,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: childLabel,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: kDarkGreen)),
              ],
            ),
          )));
}

Widget otpField({required controller, required context}) {
  return SizedBox(
    height: 50,
    width: 40,
    child: TextFormField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: controller,
      maxLength: 1,
      cursorColor: kDarkGreen,
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '_';
        }
        return null;
      },
      decoration: const InputDecoration(
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: kPrimaryRed)),
        border: OutlineInputBorder(borderSide: BorderSide(color: kLightGreen)),
        counterText: '',
      ),
    ),
  );
}
