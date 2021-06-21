import 'package:sqflite/sqflite.dart';

class UserTable {
  static const tableName = 'users';
  static const columnName = 'username';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnAmount = 'amount';
  static const createTable =
      'CREATE TABLE $tableName ($columnEmail TEXT PRIMARY KEY, $columnName TEXT NOT NULL, $columnPassword TEXT, $columnAmount REAL)';

  static Future initializeDB(path) async => await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async => await db.execute(createTable),
      );
}

class ExpenseTable {
  static const tableName = 'expenses';
  static const columnTimestamp = 'timestamp';
  static const columnDetails = 'details';
  static const columnUserEmail = 'email';
  static const columnAmount = 'amount';
  static const createTable =
      'CREATE TABLE $tableName ($columnDetails TEXT NOT NULL, $columnUserEmail TEXT NOT NULL, $columnTimestamp DATETIME NOT NULL, $columnAmount REAL)';

  static Future initializeDB(path) async => await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async => await db.execute(createTable),
      );
}

class RevenueTable {
  static const tableName = 'revenues';
  static const columnTimestamp = 'timestamp';
  static const columnDetails = 'details';
  static const columnUserEmail = 'email';
  static const columnAmount = 'amount';
  static const createTable =
      'CREATE TABLE $tableName ($columnDetails TEXT NOT NULL, $columnUserEmail TEXT NOT NULL, $columnTimestamp DATETIME NOT NULL, $columnAmount REAL)';

  static Future initializeDB(path) async => await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async => await db.execute(createTable),
      );
}
