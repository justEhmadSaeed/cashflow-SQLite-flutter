import 'package:cash_flow_app/Components/CustomDrawerHeader.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/Screens/TransactionScreen.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  static const ROUTE = '/HOME';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String amount = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;
    void getUserAmount() async {
      // Get device path of the database
      var path = join((await getDatabasesPath()), 'expenses.db');
      // Initialize DB UserTable static method
      Database db = await initializeDB(path);
      var userAmount = await db.query(UserTable.tableName,
          columns: [UserTable.columnAmount],
          where: '${UserTable.columnEmail} = ?',
          whereArgs: [userData.email]);
      setState(() {
        amount = userAmount[0]['amount'].toString();
      });
    }

    getUserAmount();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blueAccent,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: amount.length > 0
                  ? Text(
                      '\$$amount',
                      style: TextStyle(
                          fontSize: 25,
                          color: double.parse(amount) < 0
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[400],
                          fontWeight: FontWeight.bold),
                    )
                  : CircularProgressIndicator(
                      color: Colors.greenAccent[400],
                    ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Expenses',
            ),
            Tab(
              text: 'Revenue',
            ),
            Tab(
              text: 'Summary',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomDrawerHeader(
              userData: userData,
            ),
            ListTile(
              title: Text('Transaction Operations'),
              leading: Icon(
                Icons.edit,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                Navigator.pushNamed(context, TransactionScreen.ROUTE,
                    arguments: userData);
              },
              dense: true,
            ),
            ListTile(
              title: Text('Sign Out'),
              leading: Icon(
                Icons.logout,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(WelcomeScreen.ROUTE));
              },
              dense: true,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(),
          Center(),
          Center(),
        ],
      ),
    );
  }
}
