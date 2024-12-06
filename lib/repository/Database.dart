import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Database? _database;

  DatabaseClient._internal();

  factory DatabaseClient() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bibliotheque.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create `auteur` table
    await db.execute('''
      CREATE TABLE auteur(
        idAuteur INTEGER PRIMARY KEY AUTOINCREMENT,
        nomAuteur TEXT NOT NULL
      )
    ''');

    // Create `livre` table
    await db.execute('''
      CREATE TABLE livre(
        idLivre INTEGER PRIMARY KEY AUTOINCREMENT,
        nomLivre TEXT NOT NULL,
        idAuteur INTEGER,
        jacket TEXT,
        FOREIGN KEY(idAuteur) REFERENCES auteur(idAuteur)
      )
    ''');

    // Create `users` table
    await db.execute('''
  CREATE TABLE IF NOT EXISTS USERS(
    idUser INTEGER PRIMARY KEY AUTOINCREMENT,
    nomUser TEXT NOT NULL,
    prenomUser TEXT NOT NULL,
    loginUser TEXT NOT NULL UNIQUE,
    mdpUser TEXT NOT NULL,
    roleUser TEXT NOT NULL
  )
''');


// Hashing passwords
    String hashedAdminPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());
    String hashedUserPassword = BCrypt.hashpw('user123', BCrypt.gensalt());

// Insertion of default users
    await db.insert('USERS', {
      'nomUser': 'Admin',
      'prenomUser': 'Administrateur',
      'loginUser': 'admin',
      'mdpUser': hashedAdminPassword, // Hashed password
      'roleUser': 'admin'
    });

    await db.insert('USERS', {
      'nomUser': 'User',
      'prenomUser': 'Utilisateur',
      'loginUser': 'user',
      'mdpUser': hashedUserPassword, // Hashed password
      'roleUser': 'user'
    });

  }
}
