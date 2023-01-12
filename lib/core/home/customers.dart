import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class CustomersPage extends StatefulWidget {
  static const routeName = "/customers";
  const CustomersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Customers'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
