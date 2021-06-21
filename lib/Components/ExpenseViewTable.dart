import 'package:cash_flow_app/DatabaseSchema.dart';
import 'package:cash_flow_app/constants.dart';
import 'package:flutter/material.dart';

class ExpenseViewTable extends StatelessWidget {
  const ExpenseViewTable({Key? key, required this.expensesList})
      : super(key: key);
  final List expensesList;
  @override
  Widget build(BuildContext context) {
    if (expensesList.isEmpty) return CircularProgressIndicator();
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
              rows: expensesList
                  .map((record) => DataRow(cells: [
                        DataCell(Text(record['rowid'].toString())),
                        DataCell(Text(record[ExpenseTable.columnTitle])),
                        DataCell(Text('\$ ' +
                            record[ExpenseTable.columnAmount].toString())),
                        DataCell(Text(DateTime.fromMillisecondsSinceEpoch(
                                record[ExpenseTable.columnTimestamp])
                            .toString())),
                        DataCell(Icon(Icons.delete)),
                      ]))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
