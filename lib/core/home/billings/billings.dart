import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class BillingsPage extends StatefulWidget {
  static const routeName = "/market";
  const BillingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BillingsPageState createState() => _BillingsPageState();
}

class _BillingsPageState extends State<BillingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secAppBar(pageTitle: 'Billings and Payments'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
