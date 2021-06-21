import 'package:cash_flow_app/Components/DrawerHeader.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const ROUTE = '/HOME';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
            Tab(
              text: 'Expenses & Revenue',
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            kDrawerHeader,
            ListTile(
              title: Text('Transaction Operations'),
              leading: Icon(
                Icons.visibility,
                color: Colors.blueAccent,
                size: 30,
              ),
              onTap: () {
                // Navigator.pushNamed(context, Screen2.route);
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
