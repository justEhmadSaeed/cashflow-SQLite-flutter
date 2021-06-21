import 'package:cash_flow_app/Components/RoundButton.dart';
import 'package:cash_flow_app/Components/UserData.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const ROUTE = '/LOGIN';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    void onLogin() async {
      Database db;
      try {
        var path = join((await getDatabasesPath()), 'expenses.db');
        db = await initializeDB(path);
        var name = await db.query(
          UserTable.tableName,
          columns: [UserTable.columnName],
          where:
              '${UserTable.columnEmail} = ? AND ${UserTable.columnPassword} = ?',
          whereArgs: [email, password],
        );
        db.close();
        print(name);
        if (name.length < 1)
          throw Exception();
        else {
          setState(() {
            showSpinner = false;
            FocusScope.of(context).unfocus();

            Navigator.of(context).pushNamed(
              HomeScreen.ROUTE,
              arguments: UserData(
                  email: email, name: name[0][UserTable.columnName].toString()),
            );
          });
        }
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email and Password do not match.')));
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        // backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  height: 24.0,
                ),
                Hero(
                  tag: 'login',
                  child: RoundButton(
                    color: Colors.lightBlueAccent,
                    title: 'Login',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        onLogin();
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
