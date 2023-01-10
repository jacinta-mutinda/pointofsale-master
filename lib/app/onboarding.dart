import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nawiri/app/auth/login.dart';
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
      PageController(viewportFraction: 0.9, initialPage: 0);

  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/thrift-shop-bro.png',
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
    debugPrint("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () {
                _storeOnboardInfo();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                    color: kDarkGreen,
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
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
      Widget item = SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 120, bottom: 50),
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
                  padding: const EdgeInsets.all(20),
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
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? kDarkGreen
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ]);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index != screens.length - 1
                      ? Padding(
                          padding: const EdgeInsets.only(top: 120, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Image.asset(
                                      'lib/assets/images/nawiri-logo.png',
                                      width: 40,
                                      height: 40)),
                              const Text(
                                'Softbyte © 2023',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ))
                      : Container(),
                  index == screens.length - 1
                      ? priBtn(
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
                          })
                      : Container(),
                ],
              )
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
