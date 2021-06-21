import 'package:sqflite/sqflite.dart';

class UserTable {
  static const tableName = 'users';
  static const columnName = 'username';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnAmount = 'amount';
  static const createTable =
      'CREATE TABLE $tableName ($columnEmail TEXT PRIMARY KEY, $columnName TEXT NOT NULL, $columnPassword TEXT, $columnAmount REAL)';
}

class ExpenseTable {
  static const tableName = 'expenses';
  static const columnUserEmail = 'email';
  static const columnTitle = 'title';
  static const columnAmount = 'amount';
  static const columnTimestamp = 'timestamp';
  static const createTable =
      'CREATE TABLE $tableName ($columnTitle TEXT NOT NULL, $columnUserEmail TEXT NOT NULL, $columnTimestamp DATETIME NOT NULL, $columnAmount REAL)';
}

class RevenueTable {
  static const tableName = 'revenues';
  static const columnUserEmail = 'email';
  static const columnTitle = 'title';
  static const columnAmount = 'amount';
  static const columnTimestamp = 'timestamp';
  static const createTable =
      'CREATE TABLE $tableName ($columnTitle TEXT NOT NULL, $columnUserEmail TEXT NOT NULL, $columnTimestamp DATETIME NOT NULL, $columnAmount REAL)';
}

// Open db and create all tables if db does not exist.
Future initializeDB(path) async => await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(UserTable.createTable);
        print('User table created.');
        await db.execute(ExpenseTable.createTable);
        print('Expense table created.');
        await db.execute(RevenueTable.createTable);
        print('Revenue table created.');
      },
    );
