import 'package:bcrypt/bcrypt.dart';
import '../model/User.dart';
import 'Database.dart';

class UserDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  // Récupérer tous les utilisateurs
  Future<List<User>> obtenirTousLesUtilisateurs() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query('USERS');

    return result
        .map((userMap) =>
        User(
          idUser: userMap['idUser'],
          nomUser: userMap['nomUser'],
          prenomUser: userMap['prenomUser'],
          loginUser: userMap['loginUser'],
          mdpUser: userMap['mdpUser'],
          roleUser: userMap['roleUser'],
        ))
        .toList();
  }

  // Ajouter un utilisateur
  Future<int> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser, // Mot de passe en clair à hacher
    required String roleUser,
  }) async {
    final db = await _dbClient.database;

    // Hachage du mot de passe
    String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
    // Insert a new user into the database
    return await db.insert('USERS', {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': hashedPassword,
      'roleUser': roleUser,
    });
  }

  Future<int> mettreAJourUser(int idUser, String nomUser, String prenomUser, String loginUser, String mdpUser, String roleUser) async {
    final db = await _dbClient.database;
    Map<String, dynamic> values = {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'roleUser': roleUser,
    };

    // Vérifie si le mot de passe n'est pas vide avant de le hacher
    if (mdpUser.isNotEmpty) {
      String hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
      values['mdpUser'] = hashedPassword;  // Met à jour le mot de passe avec le mot de passe haché
    } else {
      values.remove('mdpUser');  // Ne met pas à jour le mot de passe si c'est vide
    }

    // Mise à jour de l'utilisateur dans la base de données
    return await db.update(
      'USERS',
      values,
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }
  // Delete a user from the USERS table based on their ID
  Future<int> supprimerUtilisateur(int idUser) async {
    final db = await _dbClient.database;

    // Delete the user from the 'USERS' table where the ID matches
    return await db.delete(
      'USERS',
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }

// Verify a user's credentials (login and password)
  Future<User?> verifierLogin(String login, String password) async {
    final db = await _dbClient.database;

    final List<Map<String, dynamic>> result = await db.query(
      'USERS',
      where: 'loginUser = ?',
      whereArgs: [login],
    );

    if (result.isNotEmpty) {
      final userMap = result.first;

      // Vérifiez que le mot de passe existe avant de tenter la vérification
      if (userMap['mdpUser'] != null && BCrypt.checkpw(password, userMap['mdpUser'])) {
        return User(
          idUser: userMap['idUser'],
          nomUser: userMap['nomUser'],
          prenomUser: userMap['prenomUser'],
          loginUser: userMap['loginUser'],
          mdpUser: userMap['mdpUser'],
          roleUser: userMap['roleUser'],
        );
      }
    }

    return null;
  }

  // Future<Map<String, dynamic>?> obtenirUserParLogin(String loginUser) async {
  //   final db = await _dbClient.database;
  //
  //   List<Map<String, dynamic>> result = await db.query(
  //     'USERS',
  //     where: 'loginUser = ?',
  //     whereArgs: [loginUser],
  //   );
  //
  //   if (result.isNotEmpty) {
  //     return result.first;
  //   }
  //
  //   return null;
  // }
  Future<void> changerMotDePasse(int idUser, String nouveauMotDePasse) async {
    final db = await _dbClient.database;
    String hashedPassword = BCrypt.hashpw(nouveauMotDePasse, BCrypt.gensalt());

    await db.update(
      'USERS',
      {'mdpUser': hashedPassword},
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }
}