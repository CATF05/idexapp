import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String role;

  User({required this.id, required this.name, required this.email, required this.role});

  // Convertir un modèle en map pour l'enregistrement dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Créer un modèle à partir d'un document Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      role: data['role'],
    );
  }
}
