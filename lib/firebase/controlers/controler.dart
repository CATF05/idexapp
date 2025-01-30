import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/firebase/repositories/repo.dart';
import 'package:frontend/models/classe_model.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/utils/utils.dart';
import 'package:uuid/uuid.dart';


// final getTransactionsProvider = StreamProvider.family((ref, String mobileMoney) {
//   final transactionsController = ref.watch(transactionControllerProvider.notifier);
//   return transactionsController.fetchUserTransactions(mobileMoney);
// });

// final getEquipementsProvider = StreamProvider.family((ref, List<String> liste) {
//   return ref
//       .watch(equipementControllerProvider.notifier).getEquipements(liste);
// });

// final getNotificationsProvider = StreamProvider((ref) {
//   return ref
//       .watch(notificationControllerProvider.notifier).fetchUserNotifications();
// });

final facturesProvider = StreamProvider.family((ref, List<DateTime> from_to) {
    // return FactureRepository().allByDates(from_to[0], from_to[1]);
    return ref
      .watch(factureControllerProvider.notifier).fetchFactures(from_to[0], from_to[1]);
  },
);


final etudiantControllerProvider =
    StateNotifierProvider<EtudiantController, bool>(
  (ref) {
    final etudiantRepository = ref.watch(etudiantRepositoryProvider);
    return EtudiantController(
      demandeRepository: etudiantRepository,
      ref: ref,
    );
  },
);


final factureControllerProvider =
    StateNotifierProvider<FactureController, bool>(
  (ref) {
    final factureRepository = ref.watch(factureRepositoryProvider);
    return FactureController(
      factureRepository: factureRepository,
      ref: ref,
    );
  },
);

final coursControllerProvider =
    StateNotifierProvider<CoursController, bool>(
  (ref) {
    final coursRepository = ref.watch(coursRepositoryProvider);
    return CoursController(
      coursRepository: coursRepository,
      ref: ref,
    );
  },
);

final profsControllerProvider =
    StateNotifierProvider<ProfsController, bool>(
  (ref) {
    final profsRepository = ref.watch(profsRepositoryProvider);
    return ProfsController(
      profsRepository: profsRepository,
      ref: ref,
    );
  },
);

final classesControllerProvider =
    StateNotifierProvider<ClassesController, bool>(
  (ref) {
    final classesRepository = ref.watch(classesRepositoryProvider);
    return ClassesController(
      classesRepository: classesRepository,
      ref: ref,
    );
  },
);

// final transactionControllerProvider =
//     StateNotifierProvider<TransactionController, bool>(
//   (ref) {
//     final transactionRepository = ref.watch(transactionRepositoryProvider);
//     return TransactionController(
//       transactionRepository: transactionRepository,
//       ref: ref,
//     );
//   },
// );

// final notificationControllerProvider =
//     StateNotifierProvider<NotificationController, bool>(
//   (ref) {
//     final notificationRepository = ref.watch(notificationRepositoryProvider);
//     return NotificationController(
//       notificationRepository: notificationRepository,
//       ref: ref,
//     );
//   },
// );


// class EquipementController extends StateNotifier<bool> {
//   final EquipementRepository _equipementRepository;
//   final Ref _ref;
//   EquipementController({
//     required EquipementRepository equipementRepository,
//     required Ref ref,
//   })  : _equipementRepository = equipementRepository,
//         _ref = ref,
//         super(false);

//   Future<void> addEquipement(BuildContext context, String type, String nom, String model, String numeroReference, Compteur compteur) async {
//     state = true;

//     Appareil appareil = Appareil(
//       id: Uuid().v1(), 
//       type: type, 
//       nom: nom, 
//       model: model, 
//       numeroReference: numeroReference
//     );

//     compteur.liste_equipements.add(appareil.id);
    
//     await _equipementRepository.addEquipement(context, appareil, compteur);
//     state = false;
//   }

//   Future<void> switchApp(String idApp, bool etat) async {
//     final numeroCompteur = _ref.read(userProvider)!.numeroCompteur;
//     await _equipementRepository.switchApp(numeroCompteur, idApp, etat);
//   }

//   Stream<Compteur> getCompteur() {
//     final idCompteur = _ref.read(userProvider)!.numeroCompteur;
//     return _equipementRepository.getCompteur(idCompteur);
//   }

//   Stream<List<Appareil>> getEquipements(List<String> liste) {
//     return _equipementRepository.getUserEquipements(liste);
//   }

//   Stream<Appareil> getEquipementById(String id) {
//     return _equipementRepository.getEquipementById(id);
//   }
// }





// class TransactionController extends StateNotifier<bool> {
//   final TransactionRepository _transactionRepository;
//   final Ref _ref;
//   TransactionController({
//     required TransactionRepository transactionRepository,
//     required Ref ref,
//   })  : _transactionRepository = transactionRepository,
//         _ref = ref,
//         super(false);

//   Future<bool> addTransaction(double quantite, int prix, String moyenPaiement, String numeroReference) async {

//     state = true;
//     final id = Uuid().v4();
//     final uid = _ref.read(userProvider)?.id ?? '';
    
//     TransactionModel transaction = TransactionModel(
//       id: id, 
//       userId: uid, 
//       date: Timestamp.now(), 
//       quantite: quantite, 
//       prix: prix, 
//       moyenPaiement: moyenPaiement, 
//       numeroReference: numeroReference
//     );
    
//     await _transactionRepository.addTransaction(transaction);
//     state = false;
//     return state;
//     // res.fold(
//     //   (l) => showSnackBar(context, l.message),
//     //   (r) {
//     //     showSnackBar(context, 'Transaction ajouter avec succès');
//     //   },
//     // );
//   }


//   Stream<List<TransactionModel>> fetchUserTransactions(String mobileMoney) {
//     final id = _ref.read(userProvider)!.id;
//     return _transactionRepository.fetchUserTransactions(id, mobileMoney);
//   }
// }



class EtudiantController extends StateNotifier<bool> {
  final EtudiantRepository _demandeRepository;
  final Ref _ref;
  EtudiantController({
    required EtudiantRepository demandeRepository,
    required Ref ref,
  })  : _demandeRepository = demandeRepository,
        _ref = ref,
        super(false);

  Future<void> addStudent(EtudiantModel etudiant, BuildContext context, [bool? isUpdate]) async {
    state = true;

    late Either<Faillure, void> res;
    if (isUpdate==null) {
      res = await _demandeRepository.addStudent(etudiant);
    } else {
      res = await _demandeRepository.addStudent(etudiant, true);
    }
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Demande envoyé avec succès');
      },
    );
  }
}


class FactureController extends StateNotifier<bool> {
  final FactureRepository _factureRepository;
  final Ref _ref;
  FactureController({
    required FactureRepository factureRepository,
    required Ref ref,
  })  : _factureRepository = factureRepository,
        _ref = ref,
        super(false);

  Future<void> addFacture(FactureModel facture, BuildContext context, [bool? isUpdate]) async {
    state = true;

    late Either<Faillure, void> res;
    if (isUpdate==null) {
      res = await _factureRepository.addFacture(facture);
    } else {
      res = await _factureRepository.addFacture(facture, true);
    }
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Facture sauvegarder');
      },
    );
  }

  Stream<List<FactureModel>> fetchFactures(DateTime? from, DateTime? to) {
    return _factureRepository.allByDates(from, to);
  }
}



class CoursController extends StateNotifier<bool> {
  final CoursRepository _coursRepository;
  final Ref _ref;
  CoursController({
    required CoursRepository coursRepository,
    required Ref ref,
  })  : _coursRepository = coursRepository,
        _ref = ref,
        super(false);

  Future<void> addCour(CoursModel cour, BuildContext context, [bool? isUpdate]) async {
    state = true;

    late Either<Faillure, void> res;
    if (isUpdate==null) {
      res = await _coursRepository.addCour(cour);
    } else {
      res = await _coursRepository.addCour(cour, true);
    }
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Cours sauvegarder');
      },
    );
  }
}

class ProfsController extends StateNotifier<bool> {
  final ProfsRepository _profsRepository;
  final Ref _ref;
  ProfsController({
    required ProfsRepository profsRepository,
    required Ref ref,
  })  : _profsRepository = profsRepository,
        _ref = ref,
        super(false);

  Future<void> addProf(ProfModel prof, BuildContext context, [bool? isUpdate]) async {
    state = true;

    late Either<Faillure, void> res;
    if (isUpdate==null) {
      res = await _profsRepository.addProf(prof);
    } else {
      res = await _profsRepository.addProf(prof, true);
    }
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Prof sauvegarder');
      },
    );
  }
}


class ClassesController extends StateNotifier<bool> {
  final ClassesRepository _classesRepository;
  final Ref _ref;
  ClassesController({
    required ClassesRepository classesRepository,
    required Ref ref,
  })  : _classesRepository = classesRepository,
        _ref = ref,
        super(false);

  Future<void> addClasse(ClasseModel classe, BuildContext context, [bool? isUpdate]) async {
    state = true;

    late Either<Faillure, void> res;
    if (isUpdate==null) {
      res = await _classesRepository.addClasse(classe);
    } else {
      res = await _classesRepository.addClasse(classe, true);
    }
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Classe sauvegarder');
      },
    );
  }
}

// class NotificationController extends StateNotifier<bool> {
//   final NotificationRepository _notificationRepository;
//   final Ref _ref;
//   NotificationController({
//     required NotificationRepository notificationRepository,
//     required Ref ref,
//   })  : _notificationRepository = notificationRepository,
//         _ref = ref,
//         super(false);
  
//   Future<void> updateView (NotificationModel notif) {
//     return _notificationRepository.updateView(notif);
//   }

//   Stream<List<NotificationModel>> fetchUserNotifications() {
//     final id = _ref.read(userProvider)!.id;
//     return _notificationRepository.fetchUserNotifications(id);
//   }
// }


// class AppareilController extends StateNotifier<bool> {
//   final AppareilRepository _appareilRepository;
//   AppareilController({
//     required AppareilRepository appareilRepository,
//   })  : _appareilRepository = appareilRepository,
//         super(false);

//   void addAppareil(String objet, String type, String nom, String model, String numeroReference, Compteur compteur, BuildContext context) async {
//     state = true;

//     Appareil appareil = Appareil(
//       id: Uuid().v1(), 
//       type: type, 
//       nom: nom, 
//       model: model, 
//       numeroReference: numeroReference
//     );

//     final res = await _appareilRepository.addAppareil(appareil, compteur);
//     state = false;
//     res.fold(
//       (l) => showSnackBar(context, l.message),
//       (r) {
//         showSnackBar(context, 'Appareil ajouté avec succès');
//       },
//     );
//   }
// }