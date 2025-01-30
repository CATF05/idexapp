// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionModel {
  String idTransaction;
  String type;
  String description;
  double montant;
  String moyenDePaiement;
  DateTime date;
  TransactionModel({
    required this.idTransaction,
    required this.type,
    required this.description,
    required this.montant,
    required this.moyenDePaiement,
    required this.date,
  });

  TransactionModel copyWith({
    String? idTransaction,
    String? type,
    String? description,
    double? montant,
    String? moyenDePaiement,
    DateTime? date,
  }) {
    return TransactionModel(
      idTransaction: idTransaction ?? this.idTransaction,
      type: type ?? this.type,
      description: description ?? this.description,
      montant: montant ?? this.montant,
      moyenDePaiement: moyenDePaiement ?? this.moyenDePaiement,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTransaction': idTransaction,
      'type': type,
      'description': description,
      'montant': montant,
      'moyenDePaiement': moyenDePaiement,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      idTransaction: map['idTransaction'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
      montant: map['montant'] as double,
      moyenDePaiement: map['moyenDePaiement'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) => TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionModel(idTransaction: $idTransaction, type: $type, description: $description, montant: $montant, moyenDePaiement: $moyenDePaiement, date: $date)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.idTransaction == idTransaction &&
      other.type == type &&
      other.description == description &&
      other.montant == montant &&
      other.moyenDePaiement == moyenDePaiement &&
      other.date == date;
  }

  @override
  int get hashCode {
    return idTransaction.hashCode ^
      type.hashCode ^
      description.hashCode ^
      montant.hashCode ^
      moyenDePaiement.hashCode ^
      date.hashCode;
  }
}
