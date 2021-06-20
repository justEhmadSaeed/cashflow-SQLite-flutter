import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/Screens/LoginScreen.dart';
import 'package:cash_flow_app/Screens/SignupScreen.dart';
import 'package:cash_flow_app/Screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Expense Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          // custom theme data
          ),
      initialRoute: WelcomeScreen.ROUTE,
      routes: {
        WelcomeScreen.ROUTE: (context) => WelcomeScreen(),
        SignupScreen.ROUTE: (context) => SignupScreen(),
        LoginScreen.ROUTE: (context) => LoginScreen(),
        HomeScreen.ROUTE: (context) => HomeScreen(),
      },
    );
  }
}
