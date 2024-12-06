import '../../model/Auteur.dart';
import '../../repository/Database.dart';
import '../../model/Livre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../repository/LivreDatabase.dart';


class LivreViewModel with ChangeNotifier {
  final DatabaseClient _dbClient = DatabaseClient();
  final LivreDatabase _livreDatabase = LivreDatabase(); // Renommé pour éviter les confusions
  List<Auteur> _auteurs = []; // Liste des auteurs
  List<Auteur> get auteurs => _auteurs; // Getter pour les auteurs
  List<Livre> _livres = []; // Liste des livres
  List<Livre> get livres => _livres; // Getter pour la liste des livres
  Livre? _livre; // Variable pour stocker un livre spécifique
  Livre? get livre => _livre; // Getter pour récupérer un livre spécifique

  // Méthode pour charger les livres depuis la base de données
  Future<void> chargerLivres() async {
    print("Récupération des livres...");
    final livresMap = await _livreDatabase.obtenirTousLesLivres(); // Appel à la méthode du repository
    print("Livres récupérés: $livresMap");

    // Utiliser Future.wait pour récupérer les livres et leurs auteurs
    final List<Livre?> livres = await Future.wait(
      livresMap.map((livreMap) async {
        final auteur = await _livreDatabase.obtenirAuteurParId(livreMap['idAuteur']);
        // Vérifiez si l'auteur a été trouvé
        if (auteur == null) {
          print("Auteur non trouvé pour l'ID: ${livreMap['idAuteur']}");
          return null; // Retournez null si l'auteur n'est pas trouvé
        } else {
          print("Auteur trouvé: ${auteur.nomAuteur}");
          return Livre.fromMap(livreMap, auteur); // Créer le livre avec l'auteur trouvé
        }
      }),
    );

    // Filtrer les livres pour ne garder que ceux qui ne sont pas null
    _livres = livres.where((livre) => livre != null).cast<Livre>().toList();

    // Notifier les auditeurs de la mise à jour
    notifyListeners();
  }

  // Méthode pour charger les auteurs depuis la base de données
  Future<void> chargerAuteurs() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> auteursMap = await db.query('AUTEUR');
    _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
    notifyListeners(); // Notifier les auditeurs de la mise à jour
  }

  // Méthode pour ajouter un livre
  Future<void> ajouterLivre(String nomLivre, int idAuteur ,String? jacketPath) async {
    final db = await _dbClient.database;
    await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'jacket': jacketPath,
    });
    // Recharger la liste des livres après ajout
    await chargerLivres();
  }

  // Méthode pour mettre à jour un livre
  Future<void> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur , String? jacketPath) async {
    final db = await _dbClient.database;
    await db.update(
      'LIVRE',
      {'nomLivre': nomLivre, 'idAuteur': idAuteur , 'jacket': jacketPath},
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
    // Recharger la liste des livres après mise à jour
    await chargerLivres();
  }

  // Méthode pour supprimer un livre
  Future<void> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
    await chargerLivres();
  }

  // Méthode pour récupérer un livre par son ID
  Future<void> getLivreById(int idLivre) async {
    try {
      // Appel à la méthode getLivreById de la base de données
      Livre? livreRecupere = await _livreDatabase.getLivreById(idLivre);

      // Vérifier si un livre a été trouvé
      if (livreRecupere != null) {
        _livre = livreRecupere;
      } else {
        // Si aucun livre n'est trouvé, assigner null
        _livre = null;
      }

      // Notifier les auditeurs que l'état a changé
      notifyListeners();
    } catch (e) {
      // Gérer l'erreur si une exception se produit
      print("Erreur lors de la récupération du livre: $e");
      _livre = null;
      notifyListeners();
    }
  }
}

