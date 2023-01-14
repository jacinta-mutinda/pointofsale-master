import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class PoSPage extends StatefulWidget {
  static const routeName = "/pos";
  const PoSPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PoSPageState createState() => _PoSPageState();
}

class _PoSPageState extends State<PoSPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Point of Sale', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
