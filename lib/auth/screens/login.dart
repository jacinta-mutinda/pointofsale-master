import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/auth/screens/company_det.dart';
import 'package:nawiri/bottomnav.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final auth = Auth();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLock(
        // correctString: loginCtrl.passcode.toString(),
        correctString: '011234',
        digits: 6,
        customizedButtonTap: auth.bioAuth,
        didOpened: auth.bioAuth,
        didUnlocked: () {
          Get.offAll(() => NavigatorHandler(0));
        },
        maxRetries: 3,
        retryDelay: const Duration(seconds: 30),
        delayBuilder: (context, delay) => Text(
              'Try again in ${(delay.inMilliseconds / 1000).ceil()} seconds.',
              style: kBlackTxt,
            ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset('assets/images/nawiri-logo.png',
                  width: 100, height: 100, fit: BoxFit.fill)),
          const Text(
            'Enter your Nawiri Passcode',
            style: kSubTitle,
          ),
        ]),
        customizedButtonChild: const Icon(
          Icons.fingerprint,
          color: kLightGreen,
          size: 50,
        ),
        deleteButton: const Icon(
          FontAwesomeIcons.deleteLeft,
          size: 40,
          color: kLightGreen,
        ),
        screenLockConfig: const ScreenLockConfig(
          backgroundColor: Colors.white,
        ),
        secretsConfig: const SecretsConfig(
            spacing: 15,
            padding: EdgeInsets.all(40),
            secretConfig: SecretConfig(
                height: 40,
                width: 40,
                borderColor: kDarkGreen,
                enabledColor: kDarkGreen,
                disabledColor: kGrey)),
        keyPadConfig: KeyPadConfig(
            buttonConfig: StyledInputConfig(
          textStyle: kPageTitle,
          buttonStyle: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            backgroundColor: kDarkGreen,
          ),
        )),
        footer: textSpan(
            mainLabel: "Don't have an account? ",
            childLabel: 'Register',
            function: () {
              Get.toNamed(CompanyDetails.routeName);
            }));
  }
}
