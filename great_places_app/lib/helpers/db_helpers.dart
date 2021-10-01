import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//não será necessário instanciar essa classe
class DBHelpers {
  //static methods
  static Future<void> insert(String table, Map<String, dynamic> places) {
    return Future.delayed(Duration(seconds: 1));
  }
}
