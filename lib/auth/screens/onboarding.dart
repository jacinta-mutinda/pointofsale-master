import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/auth/screens/login.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  bool _isLoading = false;
  int currentIndex = 0;
  final PageController _swipectrl =
      PageController(viewportFraction: 0.8, initialPage: 0);

  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/thrift-shop.png',
      text: "Custom Point of Sales",
      desc:
          "Make sales quickly and easily with our easy to use Point of Sales service",
    ),
    OnboardModel(
      img: 'assets/images/E-Wallet-bro.png',
      text: "Track Cash Flow Easily",
      desc:
          "Manage your customer bills, supplier payments and all your money transactions from one place",
    ),
    OnboardModel(
      img: 'assets/images/Metrics-bro.png',
      text: "Manage Your Profits",
      desc: "View your business insights and sales reports more conveniently",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _swipectrl.dispose();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () {
                _storeOnboardInfo();
                Get.offAll(const Login());
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                    color: kDarkGreen,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
        body: PageView(
          controller: _swipectrl,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: onboardScreens(setState),
        ));
  }

  List<Widget> onboardScreens(StateSetter setState) {
    List<Widget> pages = [];

    for (int index = 0; index < screens.length; index++) {
      Widget item = Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 30),
                child: Image.asset(
                  screens[index].img,
                  width: 250,
                ),
              ),
              Text(
                screens[index].text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: kDarkGreen,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Nunito',
                      color: Colors.black,
                    ),
                  )),
              SizedBox(
                height: 10.0,
                child: ListView.builder(
                  itemCount: screens.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? kDarkGreen
                                  : kLightGreen,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ]);
                  },
                ),
              ),
              index == screens.length - 1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: priBtn(
                          label: 'Get Started',
                          txtColour: Colors.white,
                          bgColour: kDarkGreen,
                          isLoading: _isLoading,
                          function: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await _storeOnboardInfo();
                            setState(() {
                              _isLoading = false;
                            });
                            Get.offAll(const Login());
                          }))
                  : Container(),
              Padding(
                  padding: const EdgeInsets.only(top: 80, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
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
                  )),
            ],
          ));
      pages.add(item);
    }
    return pages;
  }
}

class OnboardModel {
  String img;
  String text;
  String desc;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
  });
}
