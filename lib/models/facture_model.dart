// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FactureModel {
  String numero;
  String client;
  String idStudent;
  DateTime date;
  int montant;
  String objet;
  int montantAPayer;
  List<Detail> details;
  bool isValidate = false;
  FactureModel({
    required this.numero,
    required this.client,
    required this.idStudent,
    required this.date,
    required this.montant,
    required this.objet,
    required this.montantAPayer,
    required this.details,
    required this.isValidate,
  });
  bool selected = false;

  FactureModel copyWith({
    String? numero,
    String? client,
    String? idStudent,
    DateTime? date,
    int? montant,
    String? objet,
    int? montantAPayer,
    List<Detail>? details,
    bool? isValidate,
  }) {
    return FactureModel(
      numero: numero ?? this.numero,
      client: client ?? this.client,
      idStudent: idStudent ?? this.idStudent,
      date: date ?? this.date,
      montant: montant ?? this.montant,
      objet: objet ?? this.objet,
      montantAPayer: montantAPayer ?? this.montantAPayer,
      details: details ?? this.details,
      isValidate: isValidate ?? this.isValidate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numero': numero,
      'client': client,
      'idStudent': idStudent,
      'date': date.millisecondsSinceEpoch,
      'montant': montant,
      'objet': objet,
      'montantAPayer': montantAPayer,
      'details': details.map((x) => x.toMap()).toList(),
      'isValidate': isValidate,
    };
  }

  factory FactureModel.fromMap(Map<String, dynamic> map) {
    return FactureModel(
      numero: map['numero'] as String,
      client: map['client'] as String,
      idStudent: map['idStudent'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      montant: map['montant'] as int,
      objet: map['objet'] as String,
      montantAPayer: map['montantAPayer'] as int,
      details: List<Detail>.from((map['details'] as List<dynamic>).map<Detail>((x) => Detail.fromMap(x as Map<String,dynamic>),),),
      isValidate: map['isValidate'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory FactureModel.fromJson(String source) => FactureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FactureModel(numero: $numero, client: $client, idStudent: $idStudent, date: $date, montant: $montant, objet: $objet, montantAPayer: $montantAPayer, details: $details, isValidate: $isValidate)';
  }
}

class Detail {
  String article;
  DateTime date;
  int montant;
  String moyenDePaiement;
  Detail({
    required this.article,
    required this.date,
    required this.montant,
    required this.moyenDePaiement,
  });

  Detail copyWith({
    String? article,
    DateTime? date,
    int? montant,
    String? moyenDePaiement,
  }) {
    return Detail(
      article: article ?? this.article,
      date: date ?? this.date,
      montant: montant ?? this.montant,
      moyenDePaiement: moyenDePaiement ?? this.moyenDePaiement,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'article': article,
      'date': date.millisecondsSinceEpoch,
      'montant': montant,
      'moyenDePaiement': moyenDePaiement,
    };
  }

  factory Detail.fromMap(Map<String, dynamic> map) {
    return Detail(
      article: map['article'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      montant: map['montant'] as int,
      moyenDePaiement: map['moyenDePaiement'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Detail.fromJson(String source) => Detail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Detail(article: $article, date: $date, montant: $montant, moyenDePaiement: $moyenDePaiement)';
  }
}
