import 'dart:convert';

class SalleModel {
  String idSalle;
  String nom;
  List<String> idCours;
  SalleModel({
    required this.idSalle,
    required this.nom,
    required this.idCours,
  });

  SalleModel copyWith({
    String? idSalle,
    String? nom,
    List<String>? idCours,
  }) {
    return SalleModel(
      idSalle: idSalle ?? this.idSalle,
      nom: nom ?? this.nom,
      idCours: idCours ?? this.idCours,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idSalle': idSalle,
      'nom': nom,
      'idCours': idCours,
    };
  }

  factory SalleModel.fromMap(Map<String, dynamic> map) {
    return SalleModel(
      idSalle: map['idSalle'] as String,
      nom: map['nom'] as String,
      idCours: List<String>.from((map['idCours'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalleModel.fromJson(String source) => SalleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SalleModel(idSalle: $idSalle, nom: $nom, idCours: $idCours)';
}
