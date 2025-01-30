// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class EtudiantModel {
  String idStudent;
  String prenom;
  String nom;
  String sexe;
  String dateDeNaissance;
  String adresse;
  String nationalite;
  String situationMatrimonial;
  String email;
  String telephone;
  String nomTuteur;
  String emailTuteur;
  String telephoneTuteur;
  String classe;
  int scolariteAnnuel;
  int fraisEtudiant;
  String urlPhoto;
  List<Echeance> echeances;
  bool get enRegle => !echeances
    .where((e) => DateTime.now().compareTo(e.dernierDelais)==1)
    .map((e) => e.paiementEffectuer).toList().contains(false);
  // Widget get statutWiget => statut
  //   ? StatutWidget(statut: true) : StatutWidget(statut: false);
  // Widget actions = const ActionsWidget();
  bool selected = false;
  EtudiantModel({
    required this.idStudent,
    required this.prenom,
    required this.nom,
    required this.sexe,
    required this.dateDeNaissance,
    required this.adresse,
    required this.nationalite,
    required this.situationMatrimonial,
    required this.email,
    required this.telephone,
    required this.nomTuteur,
    required this.emailTuteur,
    required this.telephoneTuteur,
    required this.classe,
    required this.scolariteAnnuel,
    required this.fraisEtudiant,
    required this.urlPhoto,
    required this.echeances,
  });

  EtudiantModel copyWith({
    String? idStudent,
    String? prenom,
    String? nom,
    String? sexe,
    String? dateDeNaissance,
    String? adresse,
    String? nationalite,
    String? situationMatrimonial,
    String? email,
    String? telephone,
    String? nomTuteur,
    String? emailTuteur,
    String? telephoneTuteur,
    String? classe,
    int? scolariteAnnuel,
    int? fraisEtudiant,
    String? urlPhoto,
    List<Echeance>? echeances,
  }) {
    return EtudiantModel(
      idStudent: idStudent ?? this.idStudent,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      sexe: sexe ?? this.sexe,
      dateDeNaissance: dateDeNaissance ?? this.dateDeNaissance,
      adresse: adresse ?? this.adresse,
      nationalite: nationalite ?? this.nationalite,
      situationMatrimonial: situationMatrimonial ?? this.situationMatrimonial,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      nomTuteur: nomTuteur ?? this.nomTuteur,
      emailTuteur: emailTuteur ?? this.emailTuteur,
      telephoneTuteur: telephoneTuteur ?? this.telephoneTuteur,
      classe: classe ?? this.classe,
      scolariteAnnuel: scolariteAnnuel ?? this.scolariteAnnuel,
      fraisEtudiant: fraisEtudiant ?? this.fraisEtudiant,
      urlPhoto: urlPhoto ?? this.urlPhoto,
      echeances: echeances ?? this.echeances,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idStudent': idStudent,
      'prenom': prenom,
      'nom': nom,
      'sexe': sexe,
      'dateDeNaissance': dateDeNaissance,
      'adresse': adresse,
      'nationalite': nationalite,
      'situationMatrimonial': situationMatrimonial,
      'email': email,
      'telephone': telephone,
      'nomTuteur': nomTuteur,
      'emailTuteur': emailTuteur,
      'telephoneTuteur': telephoneTuteur,
      'classe': classe,
      'scolariteAnnuel': scolariteAnnuel,
      'fraisEtudiant': fraisEtudiant,
      'urlPhoto': urlPhoto,
      'echeances': echeances.map((x) => x.toMap()).toList(),
      'selected': selected,
    };
  }

  factory EtudiantModel.fromMap(Map<String, dynamic> map) {
    return EtudiantModel(
      idStudent: map['idStudent'] as String,
      prenom: map['prenom'] as String,
      nom: map['nom'] as String,
      sexe: map['sexe'] as String,
      dateDeNaissance: map['dateDeNaissance'] as String,
      adresse: map['adresse'] as String,
      nationalite: map['nationalite'] as String,
      situationMatrimonial: map['situationMatrimonial'] as String,
      email: map['email'] as String,
      telephone: map['telephone'] as String,
      nomTuteur: map['nomTuteur'] as String,
      emailTuteur: map['emailTuteur'] as String,
      telephoneTuteur: map['telephoneTuteur'] as String,
      classe: map['classe'] as String,
      scolariteAnnuel: map['scolariteAnnuel'] as int,
      fraisEtudiant: map['fraisEtudiant'] as int,
      urlPhoto: map['urlPhoto'] as String,
      echeances: List<Echeance>.from((map['echeances'] as List<dynamic>).map<Echeance>((x) => Echeance.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory EtudiantModel.fromJson(String source) => EtudiantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EtudiantModel(idStudent: $idStudent, prenom: $prenom, nom: $nom, sexe: $sexe, dateDeNaissance: $dateDeNaissance, adresse: $adresse, nationalite: $nationalite, situationMatrimonial: $situationMatrimonial, email: $email, telephone: $telephone, nomTuteur: $nomTuteur, emailTuteur: $emailTuteur, telephoneTuteur: $telephoneTuteur, classe: $classe, scolariteAnnuel: $scolariteAnnuel, fraisEtudiant: $fraisEtudiant, urlPhoto: $urlPhoto, echeances: $echeances, selected: $selected)';
  }
}


class Echeance {
  String description;
  int montantAPayer;
  int montantDejaPayer;
  DateTime dernierDelais;
  // bool statut;
  Echeance({
    required this.description,
    required this.montantAPayer,
    required this.montantDejaPayer,
    required this.dernierDelais,
    // this.statut,
  });

  bool get paiementEffectuer => montantDejaPayer >= montantAPayer;

  // Widget get statutWiget => montantAPayer > montantDejaPayer 
  //   ? StatutWidget(statut: false) : StatutWidget(statut: true);

  Echeance copyWith({
    String? description,
    int? montantAPayer,
    int? montantDejaPayer,
    DateTime? dernierDelais,
  }) {
    return Echeance(
      description: description ?? this.description,
      montantAPayer: montantAPayer ?? this.montantAPayer,
      montantDejaPayer: montantDejaPayer ?? this.montantDejaPayer,
      dernierDelais: dernierDelais ?? this.dernierDelais,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'montantAPayer': montantAPayer,
      'montantDejaPayer': montantDejaPayer,
      'dernierDelais': dernierDelais.millisecondsSinceEpoch,
    };
  }

  factory Echeance.fromMap(Map<String, dynamic> map) {
    return Echeance(
      description: map['description'] as String,
      montantAPayer: map['montantAPayer'] as int,
      montantDejaPayer: map['montantDejaPayer'] as int,
      dernierDelais: DateTime.fromMillisecondsSinceEpoch(map['dernierDelais'] ?? 1737309663002),
    );
  }

  String toJson() => json.encode(toMap());

  factory Echeance.fromJson(String source) => Echeance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Echeance(description: $description, montantAPayer: $montantAPayer, montantDejaPayer: $montantDejaPayer, dernierDelais: $dernierDelais)';
  }
}


class StatutWidget extends StatelessWidget {
  Color color;
  String statut;
  StatutWidget({
    super.key,
    required this.color,
    required this.statut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        // width: 80,
        height: 25,
        child: Center(
          child: Text( statut,
            // isInvoice ? enRegle ? "Validée" : "Non Validée" 
            //   : (enRegle ? "Payée" : "Impayée"), 
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
