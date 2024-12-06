import '../../model/Auteur.dart';

class Livre {
  late int? _idLivre;
  late String _nomLivre;
  late Auteur _auteur;
  late String? _jacketPath;

  // Constructeur
  Livre({int? idLivre, required String nomLivre, required Auteur auteur, String? jacketPath})
      : _idLivre = idLivre,
        _nomLivre = nomLivre,
        _auteur = auteur,
        _jacketPath = jacketPath;

  // Getters
  int? get idLivre => _idLivre;

  String get nomLivre => _nomLivre;

  Auteur get auteur => _auteur;

  String get nomAuteur => _auteur.nomAuteur;

  int? get idAuteur => _auteur.idAuteur;

  String? get jacketPath => _jacketPath;

  //Setters
  set nomLivre(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Le nom du livre ne peut pas être vide');
    }
    _nomLivre = value;
  }

  set jacketPath(String? value) {
    _jacketPath = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'idLivre': _idLivre,
      'nomLivre': _nomLivre,
      'idAuteur': _auteur.idAuteur,
      'jacket' : _jacketPath,
    };
  }

  factory Livre.fromMap(Map<String, dynamic> map, Auteur auteur) {
    return Livre(
      idLivre: map['idLivre'],
      nomLivre: map['nomLivre'],
      auteur: auteur,
      jacketPath: map['jacket'],
    );
  }


}