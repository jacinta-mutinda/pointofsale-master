import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class SuppliersPage extends StatefulWidget {
  static const routeName = "/suppliers";
  const SuppliersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Suppliers', actions: <Widget>[]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
