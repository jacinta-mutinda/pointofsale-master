import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class WorkPeriodPage extends StatefulWidget {
  static const routeName = "/market";
  const WorkPeriodPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkPeriodPageState createState() => _WorkPeriodPageState();
}

class _WorkPeriodPageState extends State<WorkPeriodPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Work Period'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
