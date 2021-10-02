import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

//não será necessário instanciar essa classe
class DBHelpers {
  //static methods

  /*sempre temos que fazer isso em cada operação, então fizemos um método
  especifico*/

  static Future<sql.Database> database() async {
    //nós dá o caminho para nossa base de dados
    final databasePath = await sql.getDatabasesPath();
    /*Por meio do caminho da database, iremos procurar pelo places.db
    caso não tenhamos executaremos o onCreate na primeira execução
    leva algum tempo para achar o arquivo ou criar a tabela por isso o await */
    return sql.openDatabase(
      path.join(databasePath, 'places.db'),
      onCreate: (db, version) {
        //executamos esse SQL na primeira execução de todas
        return db.execute(
          'CREATE TABLE places(id TEXT PRIMARY KEY, title TEXT, image_path TEXT)',
        );
      },
      //trabalhamos sempre com a mesma versão do banco de dados
      version: 1,
    );
  }

  //como esse método aceita um table como argumento ele é bem generico
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    /*temos que inserir o nome da classe por conta do escopo do método que é
    estático*/
    final db = await DBHelpers.database();
    //encontrado o caminho acima ou criada a tabela acima, vamos inserir o registro
    await db.insert(
      table,
      data,
      //caso já tenhamos um registro, vamos substituí-lo
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelpers.database();
    //trazemos todos os registros da tabela (é possivel filtrar)
    return db.query(table);
  }
}
