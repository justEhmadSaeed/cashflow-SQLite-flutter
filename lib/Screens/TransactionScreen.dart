import 'package:cash_flow_app/Components/AddExpenseTab.dart';
import 'package:cash_flow_app/Components/AddRevenue.dart';
import 'package:cash_flow_app/Components/CustomDrawerHeader.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get arguments from Navigation Route
    final userData = ModalRoute.of(context)!.settings.arguments as UserData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Operations'),
        backgroundColor: Colors.blueAccent,
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
                Navigator.popUntil(
                    context, ModalRoute.withName(HomeScreen.ROUTE));
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
          AddExpenseTab(email: userData.email),
          AddRevenueTab(email: userData.email),
        ],
      ),
    );
  }
}
