import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class BankingPage extends StatefulWidget {
  static const routeName = "/banking";
  const BankingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BankingPageState createState() => _BankingPageState();
}

class _BankingPageState extends State<BankingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Banking'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
