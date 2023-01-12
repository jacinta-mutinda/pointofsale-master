import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/auth/screens/company_det.dart';
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/auth/screens/onboarding.dart';
import 'package:nawiri/auth/screens/personal_det.dart';
import 'package:nawiri/auth/screens/verify.dart';
import 'package:nawiri/navigator.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Get.lazyPut(() => LoginCtrl(), fenix: true);
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

  // bool authCheck = false;
  bool authCheck = true;
  final auth = Auth();
  Future<bool> startApp() async {
    // var loggedIn = await auth.getStorageToken();
    // bool foundToken = false;
    bool foundToken = true;
    await auth.getPasscode();
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
                      if (authCheck) {
                        debugPrint("... logged in");
                        // return NavigatorHandler(0);
                        return const Login();
                      } else {
                        debugPrint("not logged in ");
                        return const Login();
                      }
                    }
                }
              },
            ),
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
