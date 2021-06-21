import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class ExpenseViewTable extends StatefulWidget {
  const ExpenseViewTable(
      {Key? key,
      required this.expensesList,
      required this.email,
      required this.userAmount,
      required this.getDataFromDB})
      : super(key: key);
  final List expensesList;
  final String email;
  final String userAmount;
  final Function getDataFromDB;

  @override
  _ExpenseViewTableState createState() => _ExpenseViewTableState();
}

class _ExpenseViewTableState extends State<ExpenseViewTable> {
  DateTime? startingTime;
  DateTime? endingTime;
  @override
  Widget build(BuildContext context) {
    if (widget.expensesList.isEmpty)
      return Center(
        child: Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      );
    List filteredList = new List.from(widget.expensesList);
    // If Starting time selected, show transactions after starting time
    if (startingTime != null)
      filteredList = filteredList
          .where((element) =>
              element[ExpenseTable.columnTimestamp] >=
              startingTime!.millisecondsSinceEpoch)
          .toList();
    // If ending time selected, show transactions before ending time
    if (endingTime != null)
      filteredList = filteredList
          .where((element) =>
              element[ExpenseTable.columnTimestamp] <=
              endingTime!.millisecondsSinceEpoch)
          .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          startingTime = date;
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text('From'),
                  ),
                  Text(startingTime != null
                      ? DateFormat('yyyy-MM-dd – kk:mm').format(startingTime!)
                      : "")
                ],
              ),
              Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          endingTime = date;
                        });
                      }, currentTime: DateTime.now());
                    },
                    child: Text('To'),
                  ),
                  Text(endingTime != null
                      ? DateFormat('yyyy-MM-dd – kk:mm').format(endingTime!)
                      : "")
                ],
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  'ID',
                  style: kDataColumnTextStyle,
                )),
                DataColumn(
                    label: Text(
                  'TITLE',
                  style: kDataColumnTextStyle,
                )),
                DataColumn(
                    numeric: true,
                    label: Text(
                      'AMOUNT',
                      style: kDataColumnTextStyle,
                    )),
                DataColumn(
                    numeric: true,
                    label: Text(
                      'TRANSACTION TIME',
                      style: kDataColumnTextStyle,
                    )),
                DataColumn(
                    label: Text(
                  'DELETE',
                  style: kDataColumnTextStyle,
                )),
              ],
              rows: filteredList
                  .map((record) => DataRow(cells: [
                        DataCell(Text(record['rowid'].toString())),
                        DataCell(Text(record[ExpenseTable.columnTitle])),
                        DataCell(Text('\$ ' +
                            record[ExpenseTable.columnAmount].toString())),
                        DataCell(
                          Text(
                            DateFormat('yyyy-MM-dd – kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    record[ExpenseTable.columnTimestamp])),
                          ),
                        ),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          // Delete From Expense Table
                          onPressed: () async {
                            try {
                              // Get device path of the database
                              var path = join(
                                  (await getDatabasesPath()), 'expenses.db');
                              // Initialize DB UserTable static method
                              Database db = await initializeDB(path);
                              await db.transaction((txn) async {
                                // Insert Record using helper function
                                await txn.delete(
                                  ExpenseTable.tableName,
                                  where: 'rowid = ?',
                                  whereArgs: [record['rowid']],
                                );
                                double remainder =
                                    double.parse(widget.userAmount) +
                                        double.parse(
                                            record[ExpenseTable.columnAmount]
                                                .toString());
                                print(remainder.toString());
                                await txn.update(
                                  UserTable.tableName,
                                  {UserTable.columnAmount: remainder},
                                  where: '${UserTable.columnEmail} = ?',
                                  whereArgs: [widget.email],
                                );
                              });
                              await widget.getDataFromDB();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Expense Transaction deleted successfully.')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Could Not Delete the Transaction.')));
                              print(e);
                            }
                          },
                        )),
                      ]))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
