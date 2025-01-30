import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:file_picker/file_picker.dart';

typedef FutureEither<T> = Future<Either<Faillure, T>>;
typedef FutureVoid = FutureEither<void>;

class Faillure {
  final String message;

  Faillure(this.message);
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}

String? validateSomme(String? value) {
  if (value == null || value.isEmpty) return 'Veuillez saisir un montant';
  final regex = RegExp(r'^[0-9]+$');
  if (!regex.hasMatch(value)) return 'Utilisez uniquement des chiffres';
  if(int.parse(value) < 1000) return 'Verifier le montant saisi';
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) return 'Veuillez saisir un numbre';
  final regex = RegExp(r'^[0-9]+$');
  if (!regex.hasMatch(value)) return 'Utilisez uniquement des chiffres';
  return null;
}

String generateNumInvoice() {
  final random = Random();
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';

  // Fonction pour générer un groupe mixte de lettres et de chiffres
  String generateGroup(int length, {bool lettersOnly = false}) {
    return List.generate(length, (_) {
      if (lettersOnly) {
        return letters[random.nextInt(letters.length)];
      } else {
        return random.nextBool()
            ? letters[random.nextInt(letters.length)]
            : numbers[random.nextInt(numbers.length)];
      }
    }).join();
  }

  String idStudent = 'F${generateGroup(5)}';
  return idStudent;
}

String generateIdStudent(String prefix, int length) {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    // Fonction pour générer un groupe mixte de lettres et de chiffres
    String generateGroup(int length, {bool lettersOnly = false}) {
      return List.generate(length, (_) {
        if (lettersOnly) {
          return letters[random.nextInt(letters.length)];
        } else {
          return random.nextBool()
              ? letters[random.nextInt(letters.length)]
              : numbers[random.nextInt(numbers.length)];
        }
      }).join();
    }

    String idStudent = '$prefix${generateGroup(length)}';

    return idStudent;
  }

String getCurrentDate() {
  DateTime now = DateTime.now();
  return now.toString().split(' ')[0];
} 


String? validateName(String? value) {
  if (value == null || value.isEmpty) return 'Ce champ est requis';
  final regex = RegExp(r'^[a-zA-Z]+$');
  if (!regex.hasMatch(value)) return 'Utilisez uniquement des lettres';
  return null;
}

String? validationNotNull(String? value) {
  if (value == null || value.isEmpty) return 'Ce champ est requis';
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  if (!emailRegex.hasMatch(value)) return 'Email invalide';
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) return 'Ce champ est requis';
  String v = value.replaceAll(' ', '');
  final regex = RegExp(r'^[0-9]+$');
  if (!regex.hasMatch(v)) return 'Utilisez uniquement des chiffres';
  if(v.length != 9) return 'Un numero de téléphone doit etre compopsé de 9 chiffres';
  return null;
}


String formatCurrency(double value) {
  final formatter = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );
  return formatter.format(value);
}