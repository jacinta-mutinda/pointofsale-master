import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class TransactionsPage extends StatefulWidget {
  static const routeName = "/transactions";
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Transactions', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
