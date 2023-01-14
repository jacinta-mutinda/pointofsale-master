import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ShiftPage extends StatefulWidget {
  static const routeName = "/shift";
  const ShiftPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShiftPageState createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(pageTitle: 'Shift', actions: []),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
