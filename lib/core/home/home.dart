// import 'package:flutter/material.dart';
// import 'package:nawiri/theme/global_widgets.dart';

// class HomePage extends StatefulWidget {
//   static const routeName = "/market";
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: mainAppBar(pageTitle: 'Nawiri'),
//       drawer: mainDrawer(),
//       body: SingleChildScrollView(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [])),
//     );
//   }
// }

// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Select an option",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
              ),
            ),
          ),
          Container(
              child: ListView(children: [
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.system_update),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('POS'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.account_balance_wallet),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Transaction'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.account_balance),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Banking'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.people),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Customers'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.local_shipping_rounded),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Suppliers'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.inventory_2),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Inventory'),
              ),
            ),
          ])),
        ],
      ),
    ));
  }
}
