import '../model/Auteur.dart';
import '../model/Livre.dart';
import 'database.dart';

class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  // Méthode pour ajouter un livre
  Future<int> ajouterLivre(String nomLivre, int authorId , String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': authorId,
      'jacket': jacketPath,
    });
  }

  // Méthode pour récupérer tous les auteurs
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  // Mettre à jour un livre
  Future<int> mettreAJourLivre(int livreId, String livreName, int authorId , String? jacketPath) async {
    final db = await _dbClient.database;
    return await db.update(
      'Livre',
      {'nomLivre': livreName, 'idAuteur': authorId , 'jacket': jacketPath},
      where: 'idLivre = ?',
      whereArgs: [livreId],
    );
  }

  // Supprimer un livre
  Future<int> supprimerLivre(int livreId) async {
    final db = await _dbClient.database;
    return await db.delete(
      'LIVRE',
      where: 'idLivre = ?',
      whereArgs: [livreId],
    );
  }

  // Récupérer un auteur par son ID
  // Méthode pour récupérer un auteur par son ID
  Future<Auteur?> obtenirAuteurParId(int idAuteur) async {
    final db = await _dbClient.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'AUTEUR', // Nom de la table
      where: 'idAuteur = ?', // Clause WHERE
      whereArgs: [idAuteur], // Argument (ID de l'auteur)
      limit: 1, // On ne veut qu'un seul résultat
    );

    if (maps.isNotEmpty) {
      // Si on trouve un auteur, on retourne un objet Auteur
      return Auteur.fromMap(maps.first);
    } else {
      // Si aucun auteur n'est trouvé, on retourne null
      return null;
    }
  }
  Future<Livre?> getLivreById(int idLivre) async {
    final db = await _dbClient.database;

    // Récupérer le livre par son ID
    final List<Map<String, dynamic>> maps = await db.query(
      'LIVRE',
      where: 'idLivre = ?',
      whereArgs: [idLivre],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      // Récupérer les données du livre
      var livreMap = maps.first;
      int auteurId = livreMap['idAuteur'];

      // Récupérer l'auteur du livre
      Auteur? auteur = await obtenirAuteurParId(auteurId);

      if (auteur != null) {
        // Retourner l'objet Livre avec l'auteur
        return Livre.fromMap(livreMap, auteur);
      } else {
        // L'auteur n'a pas été trouvé
        return null;
      }
    } else {
      // Aucun livre trouvé
      return null;
    }
  }
}