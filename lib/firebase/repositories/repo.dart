// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecowatt/backend/firebase/provider/firebase_provider.dart';
// import 'package:ecowatt/models/appareil_model.dart';
// import 'package:ecowatt/models/compteur_model.dart';
// import 'package:ecowatt/models/demande_model.dart';
// import 'package:ecowatt/models/notification_model.dart';
// import 'package:ecowatt/models/transaction_model.dart';
// import 'package:ecowatt/utils/constants/firebase_constants.dart';
// import 'package:ecowatt/utils/utils.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';

// final equipementRepositoryProvider = Provider(
//   (ref) => EquipementRepository(
//     firestore: ref.watch(firestoreProvider),
//   ),
// );


// final demandeRepositoryProvider = Provider(
//   (ref) => DemandeRepository(
//     firestore: ref.watch(firestoreProvider),
//   ),
// );


// final transactionRepositoryProvider = Provider(
//   (ref) => TransactionRepository(
//     firestore: ref.watch(firestoreProvider),
//   ),
// );

// final notificationRepositoryProvider = Provider(
//   (ref) => NotificationRepository(
//     firestore: ref.watch(firestoreProvider),
//   ),
// );

// // final appareilsRepositoryProvider = Provider(
// //   (ref) => AppareilRepository(
// //     firestore: ref.watch(firestoreProvider),
// //   ),
// // );

// class EquipementRepository {
//   final FirebaseFirestore _firestore;
//   EquipementRepository({
//     required FirebaseFirestore firestore,
//   }) : _firestore = firestore;

//   CollectionReference get _equipements =>
//       _firestore.collection(FirebaseConstants.equipementsCollection);
//   CollectionReference get _compteurs =>
//       _firestore.collection(FirebaseConstants.compteursCollection);

//   FutureVoid addEquipement(BuildContext context, Appareil appareil, Compteur compteur) async {
//     try {
//       await _equipements.doc(appareil.id).set(appareil.toMap());
//       await _compteurs.doc(compteur.numeroCompteur).update(compteur.toMap());

//       final addComptInRealTime = right(FirebaseDatabase.instance.ref()
//         .child('${compteur.numeroCompteur}/devices/${appareil.id}').set({
//           'etat': false,
//           'nom': appareil.nom,
//           'puissance': 100,
//           })
//         );
//       addComptInRealTime.fold(
//         (l) => showSnackBar(context, l.message),
//         (r) => print("Appareil ajouté dans le realtime"),
//       );

//       return right("");
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Faillure(e.toString()));
//     }
//   }

//   FutureVoid switchApp(String numeroCompteur, String idApp, bool etat) async {
//     try {
//       final databaseRef = FirebaseDatabase.instance.ref().child('$numeroCompteur/Conso/$idApp/etat');
//       databaseRef.set(etat).then((_) {
//         print("Data has been written successfully");
//       }).catchError((error) {
//         print("Failed to write data: $error");
//       });

//       return right("");
//     } catch (e) {
//       return left(Faillure(e.toString()));
//     }
//   }


//   Stream<Compteur> getCompteur(String idCompteur) {
//     return _compteurs.doc(idCompteur).snapshots().map(
//           (event) => Compteur.fromMap(event.data() as Map<String, dynamic>),
//         );
//   }

//   Stream<Appareil> getEquipementById(String id) {
//     return _equipements.doc(id).snapshots().map(
//           (event) => Appareil.fromMap(event.data() as Map<String, dynamic>),
//         );
//   }

//   // FutureVoid joinequipement(String equipementName, String userId) async {
//   //   try {
//   //     return right(_communities.doc(equipementName).update({
//   //       'members': FieldValue.arrayUnion([userId]),
//   //     }));
//   //   } on FirebaseException catch (e) {
//   //     throw e.message!;
//   //   } catch (e) {
//   //     return left(Faillure(e.toString()));
//   //   }
//   // }
//   // FutureVoid leaveequipement(String equipementName, String userId) async {
//   //   try {
//   //     return right(_communities.doc(equipementName).update({
//   //       'members': FieldValue.arrayRemove([userId]),
//   //     }));
//   //   } on FirebaseException catch (e) {
//   //     throw e.message!;
//   //   } catch (e) {
//   //     return left(Faillure(e.toString()));
//   //   }
//   // }
//   Stream<List<Appareil>> getUserEquipements(List<String> equipements) {
//     return _equipements
//         .snapshots()
//         .map((event) {
//       List<Appareil> apps = [];
//       for (var doc in event.docs) {
//         if (equipements.contains(doc.id)) {
//           apps.add(Appareil.fromMap(doc.data() as Map<String, dynamic>));
//         }
//       }
//       return apps;
//     });
//   }
//   // Stream<List<equipement>> getAllCommunities() {
//   //   return _communities.snapshots().map((event) {
//   //     List<equipement> communities = [];
//   //     for (var doc in event.docs) {
//   //       communities.add(equipement.fromMap(doc.data() as Map<String, dynamic>));
//   //     }
//   //     // une liste de map
//   //     return communities;
//   //   });
//   // }
//   // Stream<equipement> getequipementByName(String name) {
//   //   return _communities.doc(name).snapshots().map(
//   //         (event) => equipement.fromMap(event.data() as Map<String, dynamic>),
//   //       );
//   // }
//   // FutureVoid editequipement(equipement equipement) async {
//   //   try {
//   //     return right(_communities.doc(equipement.name).update(equipement.toMap()));
//   //   } on FirebaseException catch (e) {
//   //     throw e.message!;
//   //   } catch (e) {
//   //     return left(Faillure(e.toString()));
//   //   }
//   // }
//   // FutureVoid addMods(String equipementName, List<String> uids) async {
//   //   try {
//   //     return right(_communities.doc(equipementName).update({'mods': uids}));
//   //   } on FirebaseException catch (e) {
//   //     throw e.message!;
//   //   } catch (e) {
//   //     return left(Faillure(e.toString()));
//   //   }
//   // }
//   // Stream<List<equipement>> serchequipement(String query) {
//   //   return _communities
//   //       .where(
//   //         'name',
//   //         isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
//   //         isLessThan: query.substring(0, query.length - 1) +
//   //             String.fromCharCode(
//   //               query.codeUnitAt(query.length - 1) + 1,
//   //             ),
//   //       )
//   //       .snapshots()
//   //       .map((event) {
//   //     List<equipement> communities = [];
//   //     for (var equipement in event.docs) {
//   //       communities
//   //           .add(equipement.fromMap(equipement.data() as Map<String, dynamic>));
//   //     }
//   //     return communities;
//   //   });
//   // }
//   // Stream<List<Post>> getequipementPosts(String name) {
//   //   return _posts
//   //       .where('equipementName', isEqualTo: name)
//   //       .orderBy('createdAt', descending: true)
//   //       .snapshots()
//   //       .map(
//   //         (event) => event.docs
//   //             .map(
//   //               (e) => Post.fromMap(e.data() as Map<String, dynamic>),
//   //             )
//   //             .toList(),
//   //       );
//   // }
// }


// class TransactionRepository {
//   final FirebaseFirestore _firestore;
//   TransactionRepository({
//     required FirebaseFirestore firestore,
//   }) : _firestore = firestore;

//   CollectionReference get _transaction =>
//       _firestore.collection(FirebaseConstants.transactionsCollection);

//   FutureVoid addTransaction(TransactionModel transaction) async {
//     try {
//       return right(
//           await _transaction.doc(transaction.id).set(transaction.toMap()));
//     } on FirebaseException catch (e) {
//       print("-----------------------------------");
//       throw e.message!;
//     } catch (e) {
//       print("|||||||||||||||||||||||||||||||||||");
//       return left(Faillure(e.toString()));
//     }
//   }

//   Stream<List<TransactionModel>> fetchUserTransactions(String userId, String mobileMoney) {
//     return _transaction
//     .orderBy('date', descending: true)
//     .snapshots().map(
//       (event) {
//         List<TransactionModel> transactions = [];
//         for (var e in event.docs) {
//           TransactionModel transaction = TransactionModel.fromMap(e.data() as Map<String, dynamic>);
//           if (transaction.userId == userId) {
//             if (mobileMoney == "Tous") {
//               transactions.add(transaction);
//             } else {
//               if (transaction.moyenPaiement == mobileMoney) {
//                 transactions.add(transaction);
//               }
//             }
//           }
//         }
//         return transactions;
//       },
//     );
//   }
// }



// class NotificationRepository {
//   final FirebaseFirestore _firestore;
//   NotificationRepository({
//     required FirebaseFirestore firestore,
//   }) : _firestore = firestore;

//   CollectionReference get _notifications =>
//       _firestore.collection(FirebaseConstants.notificationsCollection);

//   FutureVoid updateView(NotificationModel notif) async {
//     try {
//       NotificationModel notificationModel = NotificationModel(
//         id: notif.id, 
//         userId: notif.userId, 
//         type: notif.type, 
//         contenu: notif.contenu, 
//         date: notif.date, 
//         lue: true,
//       );
//       return right(
//           await _notifications.doc(notif.id).update(notificationModel.toMap()));
//     } on FirebaseException catch (e) {
//       print("-----------------------------------");
//       throw e.message!;
//     } catch (e) {
//       print("|||||||||||||||||||||||||||||||||||");
//       return left(Faillure(e.toString()));
//     }
//   }

//   Stream<List<NotificationModel>> fetchUserNotifications(String userId) {
//     return _notifications
//     .orderBy('date', descending: true)
//     .snapshots().map(
//       (event) {
//         List<NotificationModel> notifications = [];
//         for (var e in event.docs) {
//           NotificationModel notification = NotificationModel.fromMap(e.data() as Map<String, dynamic>);
//           if (notification.userId == userId) {
//             notifications.add(notification);
//           }
//         }
//         return notifications;
//       },
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/firebase/provider/firebase_provider.dart';
import 'package:frontend/models/classe_model.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/utils/utils.dart';


final etudiantRepositoryProvider = Provider(
  (ref) => EtudiantRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

final factureRepositoryProvider = Provider(
  (ref) => FactureRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

final coursRepositoryProvider = Provider(
  (ref) => CoursRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

final profsRepositoryProvider = Provider(
  (ref) => ProfsRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

final classesRepositoryProvider = Provider(
  (ref) => ClassesRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);


class EtudiantRepository {
  final FirebaseFirestore _firestore;
  EtudiantRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _etudiant =>
      _firestore.collection("students");

  FutureVoid addStudent(EtudiantModel etudiant, [bool? isUpdate]) async {
    try {
      if (isUpdate==null) {
        return right(
          await _etudiant.doc(etudiant.idStudent).set(etudiant.toMap()));
      } else {
        return right(
          await _etudiant.doc(etudiant.idStudent).update(etudiant.toMap()));
      }
    } on FirebaseException catch (e) {
      print("-----------------------------------");
      throw e.message!;
    } catch (e) {
      print("|||||||||||||||||||||||||||||||||||");
      return left(Faillure(e.toString()));
    }
  }
}



// class FactureRepository  extends StateNotifier<bool> {
//   FactureRepository() : super(false);

class FactureRepository {
  final FirebaseFirestore _firestore;
  FactureRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _factures => 
      _firestore.collection("factures");

  FutureVoid addFacture(FactureModel facture, [bool? isUpdate]) async {
    try {
      if (isUpdate==null) {
        return right(
          await _factures.doc(facture.numero).set(facture.toMap()));
      } else {
        return right(
          await _factures.doc(facture.numero).update(facture.toMap()));
      }
    } on FirebaseException catch (e) {
      print("-----------------------------------");
      throw e.message!;
    } catch (e) {
      print("|||||||||||||||||||||||||||||||||||");
      return left(Faillure(e.toString()));
    }
  }

  Stream<List<FactureModel>> allByDates(DateTime? from, DateTime? to) {
    return _factures
        .where(
          'date',
          isGreaterThanOrEqualTo: from!.millisecondsSinceEpoch,
          isLessThan: to!.millisecondsSinceEpoch,
        )
        .snapshots()
        .map((event) {
      List<FactureModel> factures = [];
      for (var f in event.docs) {
        factures.add(FactureModel.fromMap(f.data() as Map<String, dynamic>));
      }
      print(factures);
      return factures;
    });
  }
}



class CoursRepository {
  final FirebaseFirestore _firestore;
  CoursRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _cours => 
      _firestore.collection("cours");

  FutureVoid addCour(CoursModel cour, [bool? isUpdate]) async {
    try {
      if (isUpdate==null) {
        return right(
          await _cours.doc(cour.id).set(cour.toMap()));
      } else {
        return right(
          await _cours.doc(cour.id).update(cour.toMap()));
      }
    } on FirebaseException catch (e) {
      print("-----------------------------------");
      throw e.message!;
    } catch (e) {
      print("|||||||||||||||||||||||||||||||||||");
      return left(Faillure(e.toString()));
    }
  }
}



class ProfsRepository {
  final FirebaseFirestore _firestore;
  ProfsRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _profs => 
      _firestore.collection("profs");

  FutureVoid addProf(ProfModel prof, [bool? isUpdate]) async {
    try {
      if (isUpdate==null) {
        return right(
          await _profs.doc(prof.idProf).set(prof.toMap()));
      } else {
        return right(
          await _profs.doc(prof.idProf).update(prof.toMap()));
      }
    } on FirebaseException catch (e) {
      print("-----------------------------------");
      throw e.message!;
    } catch (e) {
      print("|||||||||||||||||||||||||||||||||||");
      return left(Faillure(e.toString()));
    }
  }
}




class ClassesRepository {
  final FirebaseFirestore _firestore;
  ClassesRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _classes => 
      _firestore.collection("classes");

  FutureVoid addClasse(ClasseModel classe, [bool? isUpdate]) async {
    try {
      if (isUpdate==null) {
        return right(
          await _classes.doc(classe.idClasse).set(classe.toMap()));
      } else {
        return right(
          await _classes.doc(classe.idClasse).update(classe.toMap()));
      }
    } on FirebaseException catch (e) {
      print("-----------------------------------");
      throw e.message!;
    } catch (e) {
      print("|||||||||||||||||||||||||||||||||||");
      return left(Faillure(e.toString()));
    }
  }
}