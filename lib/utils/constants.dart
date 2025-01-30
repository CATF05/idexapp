import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/etudiant_model.dart';

class Constants {

  static List<Echeance> echeancier1 = [
    Echeance(description: "Frais d'inscription", montantAPayer: 50000, montantDejaPayer: 0, dernierDelais: DateTime(2025, 01, 05)),
    for(int i=1; i<=8; i++)
    Echeance(description: "Echeance $i", montantAPayer: 40000, montantDejaPayer: 0, dernierDelais: DateTime(2025, i+1, 05)),
  ];

  static List<Echeance> echeancier2 = [
    Echeance(description: "Frais d'inscription", montantAPayer: 50000, montantDejaPayer: 0, dernierDelais: DateTime(2025, 01, 05)),
    for(int i=1; i<=8; i++)
    Echeance(description: "Echeance $i", montantAPayer: 30000, montantDejaPayer: 0, dernierDelais: DateTime(2025, i+1, 05)),
  ];

  static Map<String, List<Echeance>> echeancier = {
    "Réseaux et Telecom": echeancier1,
    "Génie Logiciels": echeancier1,
    "Génie Civil": echeancier1,
    "Architecture": echeancier1,
    "Informatique de Gestion": echeancier2,
  };

  static List<String> admins = ["Directeur Général", "Comptable", "Directeur des Etudes", "Secrétaire", "Surveillant Général"];

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  static Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };
}

int selectedCount = 0;
Map<String, Color> statutsDemande = {
  "Demande": Colors.yellow, 
  "En entretient": Colors.orange, 
  "Accéptée": Colors.green, 
  "Rejetée": Colors.red,
};


const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);