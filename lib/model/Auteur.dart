class Auteur {
  late int? _idAuteur = 0;
  late String _nomAuteur = '';

  Auteur({int? idAuteur,required String? nomAuteur})
      : _idAuteur = idAuteur,
        _nomAuteur = nomAuteur!;

  int? get idAuteur => _idAuteur;
  String get nomAuteur => _nomAuteur;

  set nomAuteur(String? nomAuteur) {
    _nomAuteur = nomAuteur!;
  }

  Map<String, dynamic> toMap() {
    return {
      'idAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
    };
  }

  factory Auteur.fromMap(Map<String, dynamic> map) {
    return Auteur(
      idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
    );
  }
}