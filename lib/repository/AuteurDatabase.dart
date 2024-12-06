import 'Database.dart';

class AuteurDataBase {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<int> ajouterAuteur(String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.insert('AUTEUR', {'nomAuteur': nomAuteur});
  }

  Future<List<Map<String, dynamic>>> obtenirTousLesAuteurs() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR');
  }

  Future<int> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.update('AUTEUR', {'nomAuteur': nomAuteur}, where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  Future<int> supprimerAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.delete('AUTEUR', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  Future<List<Map<String, dynamic>>> obtenirLesAuteursParOrdreAlphabetique() async {
    final db = await _dbClient.database;
    return await db.query('Auteur', orderBy: 'nomAuteur ASC');
  }
}