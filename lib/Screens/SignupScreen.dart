import 'package:cash_flow_app/Components/RoundButton.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const ROUTE = '/SIGNUP';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String name = '';
  String email = '';
  String password = '';
  String amount = '0';

  @override
  Widget build(BuildContext context) {
    void onSignup() async {
      Database db;
      try {
        // Get device path of the database
        var path = join((await getDatabasesPath()), 'expenses.db');
        // Initialize DB UserTable static method
        db = await initializeDB(path);
        // Insert Record using helper function
        var id = await db.insert(UserTable.tableName, {
          UserTable.columnName: name,
          UserTable.columnEmail: email,
          UserTable.columnPassword: password,
          UserTable.columnAmount: int.parse(amount)
        });
        db.close();
        // record creation returns a rowid as the primary key
        print(id.toString());
        setState(() {
          showSpinner = false;
          FocusScope.of(context).unfocus();
          Navigator.of(context).pushNamed(HomeScreen.ROUTE,
              arguments: UserData(email: email, name: name));
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Address Already Exists.')));
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        // backgroundColor: Colors.blueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48.0,
                ),
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 150,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.badge),
                    labelText: 'Name',
                    hintText: 'Enter your name.',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your Name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please Enter Email Address';
                    else {
                      RegExp regExp = new RegExp(
                          r'^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$');
                      if (!regExp.hasMatch(value.toString())) {
                        return 'Please Enter a valid Email Address.';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please Enter Password';
                    else if (value.toString().length < 6)
                      return 'Password length must be greater than 5.';

                    return null;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: 'Initial Amount',
                    hintText: 'Enter the initial deposit in your account.',
                  ),
                  onChanged: (value) {
                    amount = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please Enter an Amount';
                    else {
                      RegExp regExp = new RegExp(r'^[0-9]+$');

                      if (!regExp.hasMatch(value.toString()))
                        return 'Please Enter a valid Amount.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                Hero(
                  tag: 'signup',
                  child: RoundButton(
                    color: Colors.blueAccent,
                    title: 'Sign Up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // if form is validated successfully,
                        // show loading spinner and call signup method
                        setState(() {
                          showSpinner = true;
                        });
                        onSignup();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
