// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class EmployeModel {
  String idEmploye;
  String nom;
  String role;
  String email;
  int telephone;
  double salaire;
  List<Abscence> abscences;
  List<String> paiementsRecu;
  EmployeModel({
    required this.idEmploye,
    required this.nom,
    required this.role,
    required this.email,
    required this.telephone,
    required this.salaire,
    required this.abscences,
    required this.paiementsRecu,
  });
  bool selected = false;

  EmployeModel copyWith({
    String? idEmploye,
    String? nom,
    String? role,
    String? email,
    int? telephone,
    double? salaire,
    List<Abscence>? abscences,
    List<String>? paiementsRecu,
  }) {
    return EmployeModel(
      idEmploye: idEmploye ?? this.idEmploye,
      nom: nom ?? this.nom,
      role: role ?? this.role,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      salaire: salaire ?? this.salaire,
      abscences: abscences ?? this.abscences,
      paiementsRecu: paiementsRecu ?? this.paiementsRecu,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEmploye': idEmploye,
      'nom': nom,
      'role': role,
      'email': email,
      'telephone': telephone,
      'salaire': salaire,
      'abscences': abscences.map((x) => x.toMap()).toList(),
      'paiementsRecu': paiementsRecu,
    };
  }

  factory EmployeModel.fromMap(Map<String, dynamic> map) {
    return EmployeModel(
      idEmploye: map['idEmploye'] as String,
      nom: map['nom'] as String,
      role: map['role'] as String,
      email: map['email'] as String,
      telephone: map['telephone'] as int,
      salaire: map['salaire'] as double,
      abscences: List<Abscence>.from((map['abscences'] as List<dynamic>).map<Abscence>((x) => Abscence.fromMap(x as Map<String,dynamic>),),),
      paiementsRecu: List<String>.from((map['paiementsRecu'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeModel.fromJson(String source) => EmployeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmployeModel(idEmploye: $idEmploye, nom: $nom, role: $role, email: $email, telephone: $telephone, salaire: $salaire, abscences: $abscences, paiementsRecu: $paiementsRecu)';
  }

  @override
  bool operator ==(covariant EmployeModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEmploye == idEmploye &&
      other.nom == nom &&
      other.role == role &&
      other.email == email &&
      other.telephone == telephone &&
      other.salaire == salaire &&
      listEquals(other.abscences, abscences) &&
      listEquals(other.paiementsRecu, paiementsRecu);
  }

  @override
  int get hashCode {
    return idEmploye.hashCode ^
      nom.hashCode ^
      role.hashCode ^
      email.hashCode ^
      telephone.hashCode ^
      salaire.hashCode ^
      abscences.hashCode ^
      paiementsRecu.hashCode;
  }
}


class Abscence {
  DateTime date;
  String justification;
  bool justificationValable;
  Abscence({
    required this.date,
    required this.justification,
    required this.justificationValable,
  });

  Abscence copyWith({
    DateTime? date,
    String? justification,
    bool? justificationValable,
  }) {
    return Abscence(
      date: date ?? this.date,
      justification: justification ?? this.justification,
      justificationValable: justificationValable ?? this.justificationValable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'justification': justification,
      'justificationValable': justificationValable,
    };
  }

  factory Abscence.fromMap(Map<String, dynamic> map) {
    return Abscence(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      justification: map['justification'] as String,
      justificationValable: map['justificationValable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Abscence.fromJson(String source) => Abscence.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Abscence(date: $date, justification: $justification, justificationValable: $justificationValable)';

  @override
  bool operator ==(covariant Abscence other) {
    if (identical(this, other)) return true;
  
    return 
      other.date == date &&
      other.justification == justification &&
      other.justificationValable == justificationValable;
  }

  @override
  int get hashCode => date.hashCode ^ justification.hashCode ^ justificationValable.hashCode;
}
