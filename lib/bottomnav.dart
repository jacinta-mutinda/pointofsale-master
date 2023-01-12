import 'package:flutter/material.dart';
import 'package:nawiri/core/home/home.dart';
import 'package:nawiri/core/market/market.dart';
import 'package:nawiri/core/reports/reports.dart';
import 'package:nawiri/core/work_period/work_period.dart';
import 'package:nawiri/theme/constants.dart';

// ignore: must_be_immutable
class NavigatorHandler extends StatefulWidget {
  static const routeName = "/NavigatorHandler";
  int index;

  NavigatorHandler(this.index, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _NavigatorHandlerState createState() => _NavigatorHandlerState(index);
}

class _NavigatorHandlerState extends State<NavigatorHandler> {
  int index;

  _NavigatorHandlerState(this.index);

  final screens = [
    const HomePage(),
    const WorkPeriodPage(),
    const MarketPage(),
    const ReportPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: kNeonGreen,
                labelTextStyle: MaterialStateProperty.all(const TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500))),
            child: NavigationBar(
                backgroundColor: kDarkGreen,
                height: 68,
                selectedIndex: index,
                onDestinationSelected: (index) {
                  setState(() {
                    this.index = index;
                  });
                },
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                animationDuration: const Duration(seconds: 1),
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined,
                          size: 30, color: Colors.white),
                      label: 'Home'),
                  NavigationDestination(
                      icon:
                          Icon(Icons.lock_clock, size: 30, color: Colors.white),
                      label: 'Work Period'),
                  NavigationDestination(
                      icon: Icon(Icons.store, size: 30, color: Colors.white),
                      label: 'Market'),
                  NavigationDestination(
                      icon: Icon(Icons.bar_chart_outlined,
                          size: 30, color: Colors.white),
                      label: 'Reports'),
                ])));
  }
}
