import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/auth_ctrl.dart';
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/auth/screens/onboarding.dart';
import 'package:nawiri/core/home/banking/banking_ctrl.dart';
import 'package:nawiri/core/home/billings/billings_ctrl.dart';
import 'package:nawiri/core/home/customers/customers_ctrl.dart';
import 'package:nawiri/core/home/inventory/inventory_ctrl.dart';
import 'package:nawiri/core/home/pos/pos_ctrl.dart';
import 'package:nawiri/core/home/suppliers/suppliers_ctrl.dart';
import 'package:nawiri/core/home/transactions/transactions_ctrl.dart';
import 'package:nawiri/core/reports/report_ctrl.dart';
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
    Get.lazyPut(() => AuthCtrl(), fenix: true);
    Get.lazyPut(() => InventoryCtrl(), fenix: true);
    Get.lazyPut(() => BankingCtrl(), fenix: true);
    Get.lazyPut(() => CustomerCtrl(), fenix: true);
    Get.lazyPut(() => SupplierCtrl(), fenix: true);
    Get.lazyPut(() => PoSCtrl(), fenix: true);
    Get.lazyPut(() => BillingsCtrl(), fenix: true);
    Get.lazyPut(() => TransactionCtrl(), fenix: true);
    Get.lazyPut(() => ReportCtrl(), fenix: true);
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

  Future<bool> startApp() async {
    Get.put(InventoryCtrl());
    return true;
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
                      return const Login();
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
