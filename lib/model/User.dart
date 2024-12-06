class User {
  late int _idUser;
  late String _nomUser;
  late String _prenomUser;
  late String _loginUser;
  late String _mdpUser;
  late String _roleUser;

  // Constructeur
  User({
    required int idUser,
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  })  : _idUser = idUser,
        _nomUser = nomUser,
        _prenomUser = prenomUser,
        _loginUser = loginUser,
        _mdpUser = mdpUser,
        _roleUser = roleUser;

  // Getters
  int get idUser => _idUser;
  String get nomUser => _nomUser;
  String get prenomUser => _prenomUser;
  String get loginUser => _loginUser;
  String get mdpUser => _mdpUser;
  String get roleUser => _roleUser;

  // Setters
  set nomUser(String value) {
    _nomUser = value;
  }

  set prenomUser(String value) {
    _prenomUser = value;
  }

  set loginUser(String value) {
    _loginUser = value;
  }

  set mdpUser(String value) {
    _mdpUser = value;
  }

  set roleUser(String value) {
    _roleUser = value;
  }

// Méthode pour convertir un User en Map (pour l'insertion dans la base de données)
  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'nomUser': _nomUser,
      'prenomUser': _prenomUser,
      'loginUser': _loginUser,
      'mdpUser': _mdpUser,
      'roleUser': _roleUser,
    };
  }

// Méthode pour créer un User à partir d'un Map (lors de la récupération depuis la base de données)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'],
      nomUser: map['nomUser'],
      prenomUser: map['prenomUser'],
      loginUser: map['loginUser'],
      mdpUser: map['mdpUser'],
      roleUser: map['roleUser'],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other._idUser == _idUser;
  }
}
