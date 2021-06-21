import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RevenueViewTable extends StatelessWidget {
  const RevenueViewTable(
      {Key? key,
      required this.revenuesList,
      required this.email,
      required this.userAmount,
      required this.getDataFromDB})
      : super(key: key);
  final List revenuesList;
  final String email;
  final String userAmount;
  final Function getDataFromDB;
  @override
  Widget build(BuildContext context) {
    if (revenuesList.isEmpty)
      return Center(
        child: Container(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(),
        ),
      );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
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
              rows: revenuesList
                  .map((record) => DataRow(cells: [
                        DataCell(Text(record['rowid'].toString())),
                        DataCell(Text(record[RevenueTable.columnTitle])),
                        DataCell(Text('\$ ' +
                            record[RevenueTable.columnAmount].toString())),
                        DataCell(Text(DateTime.fromMillisecondsSinceEpoch(
                                record[RevenueTable.columnTimestamp])
                            .toString())),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          // Delete From Revenue Table
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
                                  RevenueTable.tableName,
                                  where: 'rowid = ?',
                                  whereArgs: [record['rowid']],
                                );
                                double remainder = double.parse(userAmount) -
                                    double.parse(
                                        record[RevenueTable.columnAmount]
                                            .toString());
                                print(remainder.toString());
                                await txn.update(
                                  UserTable.tableName,
                                  {UserTable.columnAmount: remainder},
                                  where: '${UserTable.columnEmail} = ?',
                                  whereArgs: [email],
                                );
                              });
                              await getDataFromDB();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Revenue Transaction deleted successfully.')));
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
