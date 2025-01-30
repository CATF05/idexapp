import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/repositories/auth_repo.dart';
import 'package:frontend/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    // storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  // final StorageRepository _storageRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository, 
    // required StorageRepository storageRepository,
    required Ref ref
  })
      : _authRepository = authRepository,
        // _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    final user = await _authRepository.signInWithEmailAndPassword(email, password);
    state = false;
    // user.fold(
    //   (l) => showSnackBar(context, l.message),
    //   (userM) => _ref.read(userProvider.notifier).update((state) => userM),
    // );
    return user;
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }
}