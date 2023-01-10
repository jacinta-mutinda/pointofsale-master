import 'package:flutter/material.dart';

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
    // const HomePage(),
    // const TrackerPage(),
    // const Reports(),
    // const AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      // bottomNavigationBar: NavigationBarTheme(
      //     data: NavigationBarThemeData(
      //         indicatorColor: kPrimaryBlue,
      //         labelTextStyle: MaterialStateProperty.all(const TextStyle(
      //             fontFamily: 'Montserrat',
      //             color: kCreamTheme,
      //             fontSize: 12,
      //             fontWeight: FontWeight.w500))),
      //     child: NavigationBar(
      //         backgroundColor: kPrimaryPurple,
      //         height: 68,
      //         selectedIndex: index,
      //         onDestinationSelected: (index) {
      //           setState(() {
      //             this.index = index;
      //           });
      //         },
      //         labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      //         animationDuration: const Duration(seconds: 1),
      //         destinations: const [
      //           NavigationDestination(
      //               selectedIcon: Icon(
      //                 Icons.home_filled,
      //                 size: 30,
      //                 color: kCreamTheme,
      //               ),
      //               icon: Icon(Icons.home_outlined,
      //                   size: 30, color: kCreamTheme),
      //               label: 'Home'),
      //           NavigationDestination(
      //               selectedIcon: Icon(
      //                 Icons.track_changes_rounded,
      //                 size: 30,
      //                 color: kCreamTheme,
      //               ),
      //               icon: Icon(Icons.track_changes_outlined,
      //                   size: 30, color: kCreamTheme),
      //               label: 'Trackers'),
      //           NavigationDestination(
      //               selectedIcon: Icon(
      //                 Icons.bar_chart_rounded,
      //                 size: 30,
      //                 color: kCreamTheme,
      //               ),
      //               icon: Icon(Icons.bar_chart_outlined,
      //                   size: 30, color: kCreamTheme),
      //               label: 'Reports'),
      //           NavigationDestination(
      //               selectedIcon: Icon(
      //                 Icons.person_rounded,
      //                 size: 30,
      //                 color: kCreamTheme,
      //               ),
      //               icon: Icon(Icons.person_outline,
      //                   size: 30, color: kCreamTheme),
      //               label: 'Profile')
      //         ]))
    );
  }
}
