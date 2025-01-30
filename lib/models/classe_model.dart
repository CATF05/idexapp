import 'dart:convert';

class ClasseModel {
  String idClasse;
  String nom;
  List<String> idCours;
  List<String> idStudents;
  ClasseModel({
    required this.idClasse,
    required this.nom,
    required this.idCours,
    required this.idStudents,
  });

  ClasseModel copyWith({
    String? idClasse,
    String? nom,
    List<String>? idCours,
    List<String>? idStudents,
  }) {
    return ClasseModel(
      idClasse: idClasse ?? this.idClasse,
      nom: nom ?? this.nom,
      idCours: idCours ?? this.idCours,
      idStudents: idStudents ?? this.idStudents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idClasse': idClasse,
      'nom': nom,
      'idCours': idCours,
      'idStudents': idStudents,
    };
  }

  factory ClasseModel.fromMap(Map<String, dynamic> map) {
    return ClasseModel(
      idClasse: map['idClasse'] as String,
      nom: map['nom'] as String,
      idCours: List<String>.from((map['idCours'] as List<dynamic>)),
      idStudents: List<String>.from((map['idStudents'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClasseModel.fromJson(String source) => ClasseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClasseModel(idClasse: $idClasse, nom: $nom, idCours: $idCours, idStudents: $idStudents)';
  }
}
