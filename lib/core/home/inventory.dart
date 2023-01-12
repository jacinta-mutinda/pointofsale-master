import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class InventoryPage extends StatefulWidget {
  static const routeName = "/inventory";
  const InventoryPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Inventory', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
