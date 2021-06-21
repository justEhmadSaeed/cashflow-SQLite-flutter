import 'package:cash_flow_app/Components/AddExpenseTab.dart';
import 'package:cash_flow_app/Components/AddRevenueTab.dart';
import 'package:cash_flow_app/Components/CustomDrawerHeader.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionScreen extends StatefulWidget {
  static const ROUTE = '/TRANSACTIONS';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String amount = '';
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get arguments from Navigation Route
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

    if (amount.length == 0) getUserAmount();
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Operations'),
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
              title: Text('Home'),
              leading: Icon(
                Icons.visibility,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, HomeScreen.ROUTE,
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
          AddExpenseTab(
            email: userData.email,
            getAmountCallback: getUserAmount,
          ),
          AddRevenueTab(
            email: userData.email,
            getAmountCallback: getUserAmount,
          ),
        ],
      ),
    );
  }
}
