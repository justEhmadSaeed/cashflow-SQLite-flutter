import 'package:cash_flow_app/Components/RoundButton.dart';
import 'package:cash_flow_app/Screens/HomeScreen.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const ROUTE = '/SIGNUP';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
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
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.badge),
                    labelText: 'Name',
                    hintText: 'Enter your name.',
                  ),
                  onChanged: (value) {},
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
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                  ),
                  onChanged: (value) {},
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
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  onChanged: (value) {},
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
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: 'Initial Amount',
                    hintText: 'Enter the initial deposit in your account.',
                  ),
                  onChanged: (value) {},
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          setState(() {
                            showSpinner = false;
                            Navigator.of(context).pushNamed(HomeScreen.ROUTE);
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          print(e);
                        }
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
