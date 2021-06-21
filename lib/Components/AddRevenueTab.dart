import 'package:cash_flow_app/Components/RoundButton.dart';
import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddRevenueTab extends StatefulWidget {
  const AddRevenueTab({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  _AddRevenueTabState createState() => _AddRevenueTabState();
}

class _AddRevenueTabState extends State<AddRevenueTab> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  String title = '';
  String amount = '0';

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    // Add Revenue Data into record
    void addRevenue() async {
      try {
        // Get device path of the database
        var path = join((await getDatabasesPath()), 'expenses.db');
        // Initialize DB UserTable static method
        Database db = await initializeDB(path);
        // Transaction to rollback in case of an error
        await db.transaction((txn) async {
          // Insert Record using helper function
          var id = await txn.insert(RevenueTable.tableName, {
            RevenueTable.columnUserEmail: email,
            RevenueTable.columnTitle: title,
            RevenueTable.columnAmount: int.parse(amount),
            RevenueTable.columnTimestamp:
                (new DateTime.now().millisecondsSinceEpoch)
          });
          print(id.toString());
          var userAmount = await txn.query(UserTable.tableName,
              columns: [UserTable.columnAmount],
              where: '${UserTable.columnEmail} = ?',
              whereArgs: [email]);
          double totalAmount = double.parse(userAmount[0]['amount'].toString());
          double remainder = totalAmount + double.parse(amount);
          print(remainder.toString());
          await txn.update(
            UserTable.tableName,
            {UserTable.columnAmount: remainder},
            where: '${UserTable.columnEmail} = ?',
            whereArgs: [email],
          );
        });
        // record creation returns a rowid as the primary key
        setState(() {
          showSpinner = false;
        });
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Revenue Transaction added successfully.')));
        db.close();
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could Not Complete the Transaction.')));
        print(e);
      }
    }

    return Form(
      key: _formKey,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                ),
                Text(
                  'Add Revenue Transaction',
                  textAlign: TextAlign.center,
                  style: kTabViewHeadingStyle,
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.title),
                    labelText: 'Transaction Title',
                    hintText: 'Enter Transaction Title',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Transaction Title';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.attach_money),
                    labelText: 'Amount',
                    hintText: 'Enter an Amount',
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
                  height: 20,
                ),
                RoundButton(
                  color: Colors.blueAccent,
                  title: 'Add Revenue',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });
                      addRevenue();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
