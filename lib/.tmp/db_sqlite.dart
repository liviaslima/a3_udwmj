/*
CRUD
*/

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show ConflictAlgorithm, Database, getDatabasesPath, openDatabase;


// return await openDatabase('/home/fabiano/Documentos/Una/S2-2024/UDWMJ/Flutter/trabalho_a3/a3_udwmj/taskify.db', 

// join(...) = .../a3_udwmj/.dart_tool/sqflite_common_ffi/databases/taskify.db

class db_sqlite{
  
  Future<Database> openMyDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'taskify.db'),
                              version: 1, 
                              onCreate: (db, version) async {
    return db.execute('''
            PRAGMA foreign_keys = ON;
            CREATE TABLE IF NOT EXISTS usuario (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              apiId TEXT,
              nome TEXT NOT NULL,
              email TEXT NOT NULL,
              senha TEXT NOT NULL
            );
            CREATE TABLE IF NOT EXISTS tarefa (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              usuarioId INTEGER,
              apiId TEXT,
              name TEXT NOT NULL,
              description TEXT,
              date_initial TEXT,
              date_finish TEXT,
              time TEXT,
              task_category TEXT,
              FOREIGN KEY (usuarioId) REFERENCES usuario (id) ON DELETE CASCADE
           );
            CREATE TABLE IF NOT EXISTS lembrete (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              tarefaId INTEGER,
              data TEXT,
              FOREIGN KEY (tarefaId) REFERENCES tarefa (id) ON DELETE CASCADE
           );
           ''');
      
    });

  }
  
  Future<void> insertUser(String nome, String email, String senha) async {
    
    final db = await openMyDatabase();
    
    db.insert(
        'usuario',
        {
          'nome': nome,
          'email': email,
          'senha': senha,                    
        },
        conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<void> deleteUser(int id) async {
    
    final db = await openMyDatabase();
    
    db.delete('usuario', where: 'id = ?', whereArgs: [id]);
                
  }

  Future<void> updateUser(int id, String nome, String email) async {
    
    final db = await openMyDatabase();
    
    db.update(
        'usuario',
        {
          'nome': nome,
          'email': email,          
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await openMyDatabase();    
    return await db.query('usuario');
  }
   
  Future<List<Map<String, dynamic>>> getUserById(int id) async {
    final db = await openMyDatabase();
    return await db.query('usuario', 
                      columns: ['nome', 'email'],
                      where: 'id = ?',
                      whereArgs: [id]); 
  }
//Future<List<Map<String, dynamic>>>
//Future<List<Map<String, Object?>>> 
//Future<Map<String, Object?>>
Future <String> searchUserByEmail(String email) async {
    final db = await openMyDatabase();
  // String psswrd;
   // String senhaRet;
   // print("db.query");
   //Future<List<Map<String, Object?>>> senhaRet =
   //return await 
   List<Map<String, Object?>> usr = (await db.query('usuario', 
                      columns: ['id', 'senha'],
                      where: 'email = ?',
                      whereArgs: [email])) as List<Map<String, Object?>>;// as Future<List<Map<String, Object?>>>; 

  var senhaRet = usr.firstWhere((mapa) => mapa.containsKey('senha'), orElse: () => {},);

  Object? valor = await senhaRet['senha'];

 // print('senhaRet: $senhaRet');

  //print('senhaRetaaa:');
  //print(senhaRet['senha']);
  // Map<String, Object?> firstItem = senhaRet.first; // Recupera o primeiro item
  //  print('Primeiro item: $firstItem');
  //psswrd = usr[0]['senha'];
   // return usr[0]['senha'];
  //     return psswrd;  
    //return senhaRet['senha'];  
    return valor?.toString() ?? '';        
  }
  /*
Future <void> rec() async {
  // Recuperando o primeiro item
  try {
    List<Map<String, Object?>> data = await searchUserByEmail("fabianofigueredochaves@gmail.com");
    Map<String, Object?> firstItem = data.first; // Recupera o primeiro item
    var primeiroItem = firstItem.entries.first;
    print('firstItem: $firstItem');
    print('var primeiroItem: $primeiroItem');
    
    print('Primeiro campo: ${primeiroItem.key}');
    print('Segundo campo: ${primeiroItem.value}');

    print('Tudo: ${data[0]['senha']}');

  } catch (e) {
    print('Erro ao buscar dados: $e');
  }


}

*/

 //  Future<List<Map<String, Object?>>> firstItem = senhaRet[1];
//print(firstItem);
   
  ///  String name = senhaRet['senha']["senha"];
//print(name); // Saída: João                  
   // Map<String, dynamic> firstItem = data[0];
   // return senhaRet;
 //  return "";
 // }

 // CRUD para Tarefas

  Future<void> insertTask(int usuarioId, String titulo, String descricao, String data, int concluido) async {
    
     final db = await openMyDatabase();
    
     int i = await db.insert(
         'tarefa',
        {
          'usuarioId': usuarioId,
          'titulo': titulo,
          'descricao': descricao,
          'data': data,
          'concluido': concluido,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);    
  }

  Future<void> deleteTask(int id) async {
    
    final db = await openMyDatabase();
    
    db.delete('tarefa', where: 'id = ?', whereArgs: [id]);
                
  }

  Future<void> updateTask(int id, int usuarioId, String titulo, String descricao, String data, int concluido) async {
    
    final db = await openMyDatabase();
    
    db.update(
        'tarefa',
        {
          'usuarioId': usuarioId,
          'titulo': titulo,
          'descricao': descricao,
          'data': data,
          'concluido': concluido,       
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTasksByIdUser(int usuarioId) async {
    final db = await openMyDatabase();      
    return await db.query('tarefa', 
                      columns: ['id', 'titulo', 'descricao', 'data', 'concluido'],
                      where: 'usuarioId = ?',
                      whereArgs: [usuarioId]);
  }
   
  Future<List<Map<String, dynamic>>> getTasksById(int id) async {
    final db = await openMyDatabase();
    return await db.query('tarefa', 
                      columns: ['usuarioId', 'titulo', 'descricao', 'data', 'concluido'],
                      where: 'id = ?',
                      whereArgs: [id]); 
  }




} 


