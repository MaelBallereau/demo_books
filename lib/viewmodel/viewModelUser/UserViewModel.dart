import '../../model/User.dart';
import '../../repository/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final UserDatabase _userDatabase = UserDatabase();
  List<User> _utilisateur = [];
  bool _isLoading = false;
  String _userName;
  String _userRole;

  UserViewModel({
    required String userName,
    required String userRole,
  })  : _userName = userName,
        _userRole = userRole;

  // Getters
  List<User> get utilisateur => _utilisateur;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userRole => _userRole;

  @override
  void dispose() {
    super.dispose();
  }

  // Charger les utilisateurs
  Future<void> chargerUtilisateur() async {
    _isLoading = true;
    notifyListeners();
    try {
      _utilisateur = await _userDatabase.obtenirTousLesUtilisateurs();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter un utilisateur
  Future<void> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDatabase.ajouterUser(
      nomUser: nomUser,
      prenomUser: prenomUser,
      loginUser: loginUser,
      mdpUser: mdpUser,
      roleUser: roleUser,
    );
    await chargerUtilisateur();
  }

  // Mettre à jour un utilisateur
  Future<void> mettreAJourUser({
    required int idUser,
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDatabase.mettreAJourUser(
      idUser,
      nomUser,
      prenomUser,
      loginUser,
      mdpUser,
      roleUser,
    );
    await chargerUtilisateur();
  }

  // Supprimer un utilisateur
  Future<void> supprimerUser(int idUser) async {
    await _userDatabase.supprimerUtilisateur(idUser);
    await chargerUtilisateur();
  }

  // Connexion utilisateur
  Future<String?> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return 'Veuillez remplir tous les champs';
    }

    var user = await _userDatabase.verifierLogin(login, password);
    if (user != null) {
      _userName = user.nomUser;
      _userRole = user.roleUser;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', user.nomUser);
      await prefs.setString('userRole', user.roleUser);
      notifyListeners();
      return null;
    } else {
      return 'Login ou mot de passe incorrect';
    }
  }

  // Déconnexion utilisateur
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userRole');
    notifyListeners();
  }

  // Changer le mot de passe d'un utilisateur
  Future<void> changerMotDePasse(int idUser, String nouveauMotDePasse) async {
    await _userDatabase.changerMotDePasse(idUser, nouveauMotDePasse);
    notifyListeners();
  }
}
