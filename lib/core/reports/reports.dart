import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ReportPage extends StatefulWidget {
  static const routeName = "/market";
  const ReportPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Reports'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
