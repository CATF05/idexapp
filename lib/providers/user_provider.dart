import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  firebase_auth.User? _firebaseUser; // Utilisation de l'alias Firebase
  // User? _user; // Si tu as un modèle personnalisé User
  // User? get user => _user; // Getter pour l'utilisateur personnalisé

  // Getter pour obtenir l'utilisateur actuel (Firebase)
  firebase_auth.User? get firebaseUser => _firebaseUser;

  // Méthode de connexion avec email et mot de passe
  Future<void> login(String email, String password) async {
    try {
      // Connexion avec Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupérer les détails de l'utilisateur depuis Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      // Créer une instance du modèle personnalisé à partir de Firestore (si nécessaire)
      // _user = User.fromFirestore(doc);

      // Mettre à jour l'utilisateur Firebase
      _firebaseUser = userCredential.user;

      // Notifier les écouteurs que l'état a changé
      notifyListeners();
    } catch (e) {
      // Gérer les erreurs de connexion
      throw Exception("Erreur de connexion : ${e.toString()}");
    }
  }

  // Méthode pour récupérer le token JWT de l'utilisateur actuel
  Future<String?> getToken() async {
    if (_firebaseUser != null) {
      // Récupérer le token JWT (ID token)
      try {
        String? token = await _firebaseUser!.getIdToken();
        return token;
      } catch (e) {
        // Gérer les erreurs liées à la récupération du token
        throw Exception("Erreur lors de la récupération du token : ${e.toString()}");
      }
    }

    // Si aucun utilisateur n'est connecté, retourner une chaîne vide
    return "";
  }

  // Méthode pour créer un utilisateur
  Future<void> createUser(String email, String password, String name) async {
    try {
      // Créer un utilisateur avec Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajouter l'utilisateur à Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user', // Rôle par défaut
      });

      // Notifier les écouteurs que l'état a changé
      notifyListeners();
    } catch (e) {
      // Gérer les erreurs de création de l'utilisateur
      throw Exception("Erreur de création d'utilisateur : ${e.toString()}");
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
    // Réinitialiser l'utilisateur Firebase
    _firebaseUser = null;
    // Réinitialiser l'utilisateur personnalisé si nécessaire
    // _user = null;
    notifyListeners();
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Erreur de réinitialisation du mot de passe : ${e.toString()}");
    }
  }
}
