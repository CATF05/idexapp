// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';
// import 'package:ecowatt/backend/firebase/provider/firebase_provider.dart';
// import 'package:ecowatt/utils/utils.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';

// final storageRepositoryProvider = Provider(
//   (ref) => StorageRepository(
//     firebaseStorage: ref.watch(storageProvider),
//   ),
// );

// class StorageRepository {
//   final FirebaseStorage _firebaseStorage;
//   StorageRepository({
//     required FirebaseStorage firebaseStorage,
//   }) : _firebaseStorage = firebaseStorage;

//   FutureEither<String> storeFile({
//     required String path,
//     required String id,
//     required File? file,
//   }) async {
//     try {
//       final ref = _firebaseStorage.ref().child(path).child(id);

//       UploadTask uploadTask = ref.putFile(file!);

//       final snapshot = await uploadTask;

//       return right(await snapshot.ref.getDownloadURL());
//     } catch (e) {
//       return left(Faillure(e.toString()));
//     }
//   }
// }
