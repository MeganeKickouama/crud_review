import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'User.dart';

class DatabaseHelper
{
  // step 1: create the table
  static Future<void> createTable(sql.Database database) async
  {
    await database.execute('''
      create table user 
      (
        id integer primary key autoincrement not null,
        fname varchar(35),
        lname varchar(35),
        username varchar(20),
        password varchar(35)
      )
    ''');
  }

  // step 2: create or fetch the instance of the database
  static Future<sql.Database> db() async
  {
      return sql.openDatabase(
        'shmoney.db',
        version: 1,
        onCreate: (sql.Database database, int version) async
          {
            print('creating a table...');
            await createTable(database);
          }
      );
  }

  // step 3: insert an object of an user to the database
  static Future<int> registerUser(User user) async
  {
    final db = await DatabaseHelper.db();
    final data =
    {
      'fname' : user.fname,
      'lname' : user.lname,
      'username' : user.username,
      'password' : user.password,
    };

    final id = await db.insert('user', data, // insert into 'user' the values in 'data,' prevent duplicates with conflictAlgorithm
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async
  {
    final db = await DatabaseHelper.db();
    return db.query('user', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> fetchUser(int id) async
  {
    final db = await DatabaseHelper.db();
    return db.query('user', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> fetchUserByUsername(String name) async
  {
    final db = await DatabaseHelper.db();
    return db.query('user', where: 'username = ?', whereArgs: [name], limit: 1);
  }

  static Future<int> updateUser(int id, String? fname,
  String? lname, String? username, String? password) async
  {
    final db = await DatabaseHelper.db();

    final data =
    {
      'fname': fname,
      'lname': lname,
      'username': username,
      'password': password,
    };

    final result = await db.update('user', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteUser(int id, BuildContext context) async
  {
    final db = await DatabaseHelper.db();
    try
    {
      await db.delete('user', where: 'id = ?', whereArgs: [id]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully!')));
    }
    catch (error)
    {
      debugPrint('Something went wrong with deleting an item:\n$error');
    }
  }

}