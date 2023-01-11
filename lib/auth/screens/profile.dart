import 'package:flutter/material.dart';
import 'package:nawiri/theme/global_widgets.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/market";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(pageTitle: 'Nawiri'),
      drawer: mainDrawer(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [])),
    );
  }
}
