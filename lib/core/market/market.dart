import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';
import 'package:nawiri/theme/constants.dart';
import 'package:lottie/lottie.dart';

class MarketPage extends StatefulWidget {
  static const routeName = "/market";
  const MarketPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Market'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 30),
                  child: Lottie.asset('assets/images/market.json', width: 300),
                ),
                const Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    color: kDarkGreen,
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Lorem ipsum dolor sit amet, consecuture adipscing elit. Nam quis felis magna. Phasellus sed libero nn felis venenatis bendit. Phaselys varius libero ac mi suscpit dapibus.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        color: Colors.black,
                      ),
                    ))
              ]))),
    );
  }
}
