import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/provider/firebase_provider.dart';
import 'package:frontend/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/utils/utils.dart';


final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _firestore = firestore;
  
  CollectionReference get _users => _firestore.collection("admins");
  // CollectionReference get _compteurs => _firestore.collection(FirebaseConstants.compteursCollection);
  // CollectionReference get _cartes => _firestore.collection(FirebaseConstants.cartesCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      UserModel userModel = await getUserData(user!.uid).first;

      return userModel;
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

  // Future registerWithEmailAndPassword(BuildContext context, String email, String password, 
  //     name, role) async {
  //   try {
  //     UserCredential result = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     User? user = result.user;
  //     if (user == null) {
  //       throw Exception("No user found");
  //     } else {

  //       UserModel userData = UserModel(id: user.uid, name: name, email: email, role: role);

  //       saveUserData(userData, false);

  //       return userData;
  //     }
  //   } catch (exception) {
  //     debugPrint(exception.toString());
  //     return null;
  //   }
  // }

  // FutureVoid saveUserData(UserModel userModel, bool update) async {
  //   try {
  //     if (update) {
  //       return right(await _users.doc(userModel.id).update(userModel.toMap()));
  //     } else {
  //       return right(await _users.doc(userModel.id).set(userModel.toMap()));
  //     }
      
  //   } catch (e) {
  //     return left(Faillure('Failed to save user data: $e'));
  //   }
  // }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
      (event) {
        if (event.data() != null) {
          return UserModel.fromMap(
            event.data() as Map<String, dynamic>,
          );
        }
        return UserModel.fromMap({});
      },
    );
  }

  void logOut() async {
    await _auth.signOut();
  }
}