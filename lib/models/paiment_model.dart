// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaimentModel {
  String idPaiement;
  String destinataire;
  String idDestinataire;
  String designation;
  double montant;
  String moyenDePaiement;
  DateTime date;
  PaimentModel({
    required this.idPaiement,
    required this.destinataire,
    required this.idDestinataire,
    required this.designation,
    required this.montant,
    required this.moyenDePaiement,
    required this.date,
  });

  PaimentModel copyWith({
    String? idPaiement,
    String? destinataire,
    String? idDestinataire,
    String? designation,
    double? montant,
    String? moyenDePaiement,
    DateTime? date,
  }) {
    return PaimentModel(
      idPaiement: idPaiement ?? this.idPaiement,
      destinataire: destinataire ?? this.destinataire,
      idDestinataire: idDestinataire ?? this.idDestinataire,
      designation: designation ?? this.designation,
      montant: montant ?? this.montant,
      moyenDePaiement: moyenDePaiement ?? this.moyenDePaiement,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idPaiement': idPaiement,
      'destinataire': destinataire,
      'idDestinataire': idDestinataire,
      'designation': designation,
      'montant': montant,
      'moyenDePaiement': moyenDePaiement,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory PaimentModel.fromMap(Map<String, dynamic> map) {
    return PaimentModel(
      idPaiement: map['idPaiement'] as String,
      destinataire: map['destinataire'] as String,
      idDestinataire: map['idDestinataire'] as String,
      designation: map['designation'] as String,
      montant: map['montant'] as double,
      moyenDePaiement: map['moyenDePaiement'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaimentModel.fromJson(String source) => PaimentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaimentModel(idPaiement: $idPaiement, destinataire: $destinataire, idDestinataire: $idDestinataire, designation: $designation, montant: $montant, moyenDePaiement: $moyenDePaiement, date: $date)';
  }

  @override
  bool operator ==(covariant PaimentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.idPaiement == idPaiement &&
      other.destinataire == destinataire &&
      other.idDestinataire == idDestinataire &&
      other.designation == designation &&
      other.montant == montant &&
      other.moyenDePaiement == moyenDePaiement &&
      other.date == date;
  }

  @override
  int get hashCode {
    return idPaiement.hashCode ^
      destinataire.hashCode ^
      idDestinataire.hashCode ^
      designation.hashCode ^
      montant.hashCode ^
      moyenDePaiement.hashCode ^
      date.hashCode;
  }
}
