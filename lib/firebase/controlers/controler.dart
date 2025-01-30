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



final facturesProvider = StreamProvider.family((ref, List<DateTime> fromTo) {
    return ref
      .watch(factureControllerProvider.notifier).fetchFactures(fromTo[0], fromTo[1]);
  },
);


final etudiantControllerProvider =
    StateNotifierProvider<EtudiantController, bool>(
  (ref) {
    final etudiantRepository = ref.watch(etudiantRepositoryProvider);
    return EtudiantController(
      demandeRepository: etudiantRepository,
    );
  },
);


final factureControllerProvider =
    StateNotifierProvider<FactureController, bool>(
  (ref) {
    final factureRepository = ref.watch(factureRepositoryProvider);
    return FactureController(
      factureRepository: factureRepository,
    );
  },
);

final coursControllerProvider =
    StateNotifierProvider<CoursController, bool>(
  (ref) {
    final coursRepository = ref.watch(coursRepositoryProvider);
    return CoursController(
      coursRepository: coursRepository,
    );
  },
);

final profsControllerProvider =
    StateNotifierProvider<ProfsController, bool>(
  (ref) {
    final profsRepository = ref.watch(profsRepositoryProvider);
    return ProfsController(
      profsRepository: profsRepository,
    );
  },
);

final classesControllerProvider =
    StateNotifierProvider<ClassesController, bool>(
  (ref) {
    final classesRepository = ref.watch(classesRepositoryProvider);
    return ClassesController(
      classesRepository: classesRepository,
    );
  },
);


class EtudiantController extends StateNotifier<bool> {
  final EtudiantRepository _demandeRepository;
  EtudiantController({
    required EtudiantRepository demandeRepository,
  })  : _demandeRepository = demandeRepository,
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
  FactureController({
    required FactureRepository factureRepository,
  })  : _factureRepository = factureRepository,
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
  CoursController({
    required CoursRepository coursRepository,
  })  : _coursRepository = coursRepository,
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
  ProfsController({
    required ProfsRepository profsRepository,
  })  : _profsRepository = profsRepository,
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
  ClassesController({
    required ClassesRepository classesRepository,
  })  : _classesRepository = classesRepository,
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