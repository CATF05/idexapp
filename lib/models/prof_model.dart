// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProfModel {
  String idProf;
  String nom;
  String email;
  String urlPhoto;
  int telephone;
  String nationalite;
  List<String> cours;
  ProfModel({
    required this.idProf,
    required this.nom,
    required this.email,
    required this.urlPhoto,
    required this.telephone,
    required this.nationalite,
    required this.cours,
  });
  bool selected = false;

  ProfModel copyWith({
    String? idProf,
    String? nom,
    String? email,
    String? urlPhoto,
    int? telephone,
    String? nationalite,
    List<String>? cours,
  }) {
    return ProfModel(
      idProf: idProf ?? this.idProf,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      telephone: telephone ?? this.telephone,
      nationalite: nationalite ?? this.nationalite,
      cours: cours ?? this.cours,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProf': idProf,
      'nom': nom,
      'email': email,
      'urlPhoto': urlPhoto,
      'telephone': telephone,
      'nationalite': nationalite,
      'cours': cours,
    };
  }

  factory ProfModel.fromMap(Map<String, dynamic> map) {
    return ProfModel(
      idProf: map['idProf'] as String,
      nom: map['nom'] as String,
      email: map['email'] as String,
      urlPhoto: map['urlPhoto'] as String,
      telephone: map['telephone'] as int,
      nationalite: map['nationalite'] as String,
      cours: List<String>.from((map['cours'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfModel.fromJson(String source) => ProfModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfModel(idProf: $idProf, nom: $nom, email: $email, urlPhoto: $urlPhoto, telephone: $telephone, nationalite: $nationalite, cours: $cours)';
  }
}
