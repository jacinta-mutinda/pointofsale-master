import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:nawiri/app/auth/login.dart';
import 'package:nawiri/app/navigator.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/onboarding.dart';

const mpesaFilter = r"^[A-Z]{2}[\dA-Z]{8}\sConfirmed";

int? isviewed;
void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
  debugPrint('Hello there...');
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => LocalAuthApi(), fenix: true);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool authCheck = false;
  // final auth = Auth();
  // final lockCtrl = LocalAuthApi();
  Future<bool> startApp() async {
    // var loggedIn = await auth.getStorageToken();
    // bool foundToken = false;
    bool foundToken = true;
    // if (loggedIn) {
    //   auth.doGetProfile();
    //   authCheck = true;
    //   foundToken = true;
    //   await lockCtrl.getPasscode();
    // }
    return foundToken;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nawiri',
      initialBinding: InitialBinding(),
      home: isviewed != 0
          ? const OnBoard()
          : FutureBuilder(
              future: startApp(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Scaffold(
                      body: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      debugPrint('$snapshot.error');
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return NavigatorHandler(0);
                      // if (authCheck) {
                      //   debugPrint("... logged in");

                      //   return ScreenLock(
                      //       correctString: lockCtrl.passcode.toString(),
                      //       customizedButtonTap: lockCtrl.bioAuth,
                      //       didOpened: lockCtrl.bioAuth,
                      //       didUnlocked: () {
                      //         Get.offAll(() => NavigatorHandler(0));
                      //       },
                      //       maxRetries: 3,
                      //       retryDelay: const Duration(seconds: 30),
                      //       delayBuilder: (context, delay) => Text(
                      //             'Try again in ${(delay.inMilliseconds / 1000).ceil()} seconds.',
                      //             style: kCardTitle,
                      //           ),
                      //       title: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Padding(
                      //                 padding:
                      //                     const EdgeInsets.only(bottom: 20),
                      //                 child: Image.asset(
                      //                     'assets/images/walletlogo2.png',
                      //                     width: 60,
                      //                     height: 60,
                      //                     fit: BoxFit.fill)),
                      //             const Text(
                      //               'Enter your Wavvy Wallet Passcode',
                      //               style: kCardTitle,
                      //             ),
                      //           ]),
                      //       customizedButtonChild: const Icon(
                      //         Icons.fingerprint,
                      //         size: 30,
                      //       ),
                      //       deleteButton:
                      //           const Icon(FontAwesomeIcons.deleteLeft),
                      //       screenLockConfig: const ScreenLockConfig(
                      //         backgroundColor: kDarkTheme,
                      //       ),
                      //       secretsConfig: const SecretsConfig(
                      //           spacing: 15,
                      //           padding: EdgeInsets.all(40),
                      //           secretConfig:
                      //               SecretConfig(height: 30, width: 30)),
                      //       keyPadConfig: KeyPadConfig(
                      //           buttonConfig: StyledInputConfig(
                      //         textStyle: kPageTitle,
                      //         buttonStyle: OutlinedButton.styleFrom(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(50)),
                      //           backgroundColor: kPrimaryPurple,
                      //         ),
                      //       )));
                      // } else {
                      //   debugPrint("not logged in ");
                      //   return const Login();
                      // }
                    }
                }
              },
            ),
      getPages: [
        GetPage(
            name: NavigatorHandler.routeName, page: () => NavigatorHandler(0)),
        GetPage(
          name: Login.routeName,
          page: () => const Login(),
        )
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        primaryColor: kDarkGreen,
        colorScheme: const ColorScheme.light(),
        fontFamily: 'Nunito',
      ),
    );
  }
}
