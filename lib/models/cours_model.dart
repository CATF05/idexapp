import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class CoursModel {
  String id;
  String nom;
  String classe;
  String description;
  String idProf;
  String nomProf;
  String salle;
  List<Evenement> programmations;
  int nbHeures;
  int nbHeuresDejaFait;
  int nbEtudiants;
  CoursModel({
    required this.id,
    required this.nom,
    required this.classe,
    required this.description,
    required this.idProf,
    required this.nomProf,
    required this.salle,
    required this.programmations,
    required this.nbHeures,
    required this.nbHeuresDejaFait,
    required this.nbEtudiants,
  });
  bool selected = false;

  CoursModel copyWith({
    String? id,
    String? nom,
    String? classe,
    String? description,
    String? idProf,
    String? nomProf,
    String? salle,
    List<Evenement>? programmations,
    int? nbHeures,
    int? nbHeuresDejaFait,
    int? nbEtudiants,
  }) {
    return CoursModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      classe: classe ?? this.classe,
      description: description ?? this.description,
      idProf: idProf ?? this.idProf,
      nomProf: nomProf ?? this.nomProf,
      salle: salle ?? this.salle,
      programmations: programmations ?? this.programmations,
      nbHeures: nbHeures ?? this.nbHeures,
      nbHeuresDejaFait: nbHeuresDejaFait ?? this.nbHeuresDejaFait,
      nbEtudiants: nbEtudiants ?? this.nbEtudiants,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nom': nom,
      'classe': classe,
      'description': description,
      'idProf': idProf,
      'nomProf': nomProf,
      'salle': salle,
      'programmations': programmations.map((x) => x.toMap()).toList(),
      'nbHeures': nbHeures,
      'nbHeuresDejaFait': nbHeuresDejaFait,
      'nbEtudiants': nbEtudiants,
    };
  }

  factory CoursModel.fromMap(Map<String, dynamic> map) {
    return CoursModel(
      id: map['id'] as String,
      nom: map['nom'] as String,
      classe: map['classe'] as String,
      description: map['description'] as String,
      idProf: map['idProf'] as String,
      nomProf: map['nomProf'] as String,
      salle: map['salle'] as String,
      programmations: List<Evenement>.from((map['programmations'] as List<dynamic>).map<Evenement>((x) => Evenement.fromMap(x as Map<String,dynamic>),),),
      nbHeures: map['nbHeures'] as int,
      nbHeuresDejaFait: map['nbHeuresDejaFait'] as int,
      nbEtudiants: map['nbEtudiants'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CoursModel.fromJson(String source) => CoursModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoursModel(id: $id, nom: $nom, classe: $classe, description: $description, idProf: $idProf, nomProf: $nomProf, salle: $salle, programmations: $programmations, nbHeures: $nbHeures, nbHeuresDejaFait: $nbHeuresDejaFait, nbEtudiants: $nbEtudiants)';
  }
}

class Evenement {
  String description;
  String salle;
  String classe;
  String idCours;
  String idEvent;
  DateTime heureDebut;
  DateTime heureFin;
  bool dejaFait;
  Color background;
  List<String> absences;
  bool profAbscent;
  Evenement({
    required this.description,
    required this.salle,
    required this.classe,
    required this.idCours,
    required this.idEvent,
    required this.heureDebut,
    required this.heureFin,
    required this.dejaFait,
    required this.background,
    required this.absences,
    required this.profAbscent,
  });
  bool isAllDay = false;
  int get nbHeures => heureFin.difference(heureDebut).inHours;

  Evenement copyWith({
    String? description,
    String? salle,
    String? classe,
    String? idCours,
    String? idEvent,
    DateTime? heureDebut,
    DateTime? heureFin,
    bool? dejaFait,
    Color? background,
    List<String>? absences,
    bool? profAbscent,
  }) {
    return Evenement(
      description: description ?? this.description,
      salle: salle ?? this.salle,
      classe: classe ?? this.classe,
      idCours: idCours ?? this.idCours,
      idEvent: idEvent ?? this.idEvent,
      heureDebut: heureDebut ?? this.heureDebut,
      heureFin: heureFin ?? this.heureFin,
      dejaFait: dejaFait ?? this.dejaFait,
      background: background ?? this.background,
      absences: absences ?? this.absences,
      profAbscent: profAbscent ?? this.profAbscent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'salle': salle,
      'classe': classe,
      'idCours': idCours,
      'idEvent': idEvent,
      'heureDebut': heureDebut.millisecondsSinceEpoch,
      'heureFin': heureFin.millisecondsSinceEpoch,
      'dejaFait': dejaFait,
      'background': background.value,
      'absences': absences,
      'profAbscent': profAbscent,
    };
  }

  factory Evenement.fromMap(Map<String, dynamic> map) {
    return Evenement(
      description: map['description'] as String,
      salle: map['salle'] as String,
      classe: map['classe'] as String,
      idCours: map['idCours'] as String,
      idEvent: map['idEvent'] as String,
      heureDebut: DateTime.fromMillisecondsSinceEpoch(map['heureDebut'] as int),
      heureFin: DateTime.fromMillisecondsSinceEpoch(map['heureFin'] as int),
      dejaFait: map['dejaFait'] as bool,
      background: Color(map['background'] as int),
      absences: List<String>.from((map['absences'] as List<dynamic>)),
      profAbscent: map['profAbscent'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Evenement.fromJson(String source) => Evenement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Evenement(description: $description, salle: $salle, classe: $classe, idCours: $idCours, idEvent: $idEvent, heureDebut: $heureDebut, heureFin: $heureFin, dejaFait: $dejaFait, background: $background, absences: $absences, profAbscent: $profAbscent)';
  }

  @override
  bool operator ==(covariant Evenement other) {
    if (identical(this, other)) return true;
  
    return 
      other.description == description &&
      other.salle == salle &&
      other.classe == classe &&
      other.idCours == idCours &&
      other.idEvent == idEvent &&
      other.heureDebut == heureDebut &&
      other.heureFin == heureFin &&
      other.dejaFait == dejaFait &&
      other.background == background &&
      listEquals(other.absences, absences) &&
      other.profAbscent == profAbscent;
  }

  @override
  int get hashCode {
    return description.hashCode ^
      salle.hashCode ^
      classe.hashCode ^
      idCours.hashCode ^
      idEvent.hashCode ^
      heureDebut.hashCode ^
      heureFin.hashCode ^
      dejaFait.hashCode ^
      background.hashCode ^
      absences.hashCode ^
      profAbscent.hashCode;
  }
}
