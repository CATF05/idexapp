// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DemandeModel {
  String idDemande;
  String demandeur;
  String objet;
  String contenu;
  DateTime date;
  bool repondu;
  DemandeModel({
    required this.idDemande,
    required this.demandeur,
    required this.objet,
    required this.contenu,
    required this.date,
    required this.repondu,
  });
  bool selected = false;

  DemandeModel copyWith({
    String? idDemande,
    String? demandeur,
    String? objet,
    String? contenu,
    DateTime? date,
    bool? repondu,
  }) {
    return DemandeModel(
      idDemande: idDemande ?? this.idDemande,
      demandeur: demandeur ?? this.demandeur,
      objet: objet ?? this.objet,
      contenu: contenu ?? this.contenu,
      date: date ?? this.date,
      repondu: repondu ?? this.repondu,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDemande': idDemande,
      'demandeur': demandeur,
      'objet': objet,
      'contenu': contenu,
      'date': date.millisecondsSinceEpoch,
      'repondu': repondu,
    };
  }

  factory DemandeModel.fromMap(Map<String, dynamic> map) {
    return DemandeModel(
      idDemande: map['idDemande'] as String,
      demandeur: map['demandeur'] as String,
      objet: map['objet'] as String,
      contenu: map['contenu'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      repondu: map['repondu'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DemandeModel.fromJson(String source) => DemandeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DemandeModel(idDemande: $idDemande, demandeur: $demandeur, objet: $objet, contenu: $contenu, date: $date, repondu: $repondu)';
  }
}
