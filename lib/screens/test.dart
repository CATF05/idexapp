// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class RegistrationFormPage extends StatefulWidget {
//   @override
//   _RegistrationFormPageState createState() => _RegistrationFormPageState();
// }

// class _RegistrationFormPageState extends State<RegistrationFormPage> {
//   File? etudiantPhoto;
//   String schoolName = "INSTITUT D'EXCELLENCE DU SÉNÉGAL"; // Nom fixe de l'école
//   String schoolAccreditation = "RepSen/Ensup-Priv/AP/394 -2021"; // Agrément fixe
//   TextEditingController _schoolNameController = TextEditingController();
//   TextEditingController _schoolAccreditationController = TextEditingController();

//   // Méthode pour choisir la photo de l'étudiant
//   Future<void> pickImage() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//       );
//       if (result != null) {
//         setState(() {
//           etudiantPhoto = File(result.files.single.path!);
//         });
//       }
//     } catch (e) {
//       print("Erreur lors de la sélection de l'image : $e");
//     }
//   }

//   // Méthode pour sauvegarder les données
//   void _saveForm() {
//     setState(() {
//       // Les valeurs sont fixes, donc pas de mise à jour ici
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Formulaire enregistré avec succès !")),
//     );
//   }

//   // Méthode pour générer un PDF
//   Future<void> _generatePDF() async {
//     final pdf = pw.Document();

//     // Ajout de la page d'inscription dans le PDF
//     pdf.addPage(pw.Page(build: (pw.Context context) {
//       return pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Center(
//             child: pw.Column(
//               children: [
//                 pw.Text(
//                   schoolName, // Nom fixe de l'école
//                   style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   "Agrément N°: $schoolAccreditation", // Agrément fixe
//                   style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text(
//                   "Fiche d'Inscription 2024 - 2025",
//                   style: pw.TextStyle(fontSize: 14),
//                 ),
//                 pw.SizedBox(height: 8),
//                 pw.Text("Fait à Dakar le : ${getCurrentDate()}"),
//               ],
//             ),
//           ),
//           pw.Divider(),
//           pw.SizedBox(height: 16),
//           pw.Text("Photo d'identité de l'apprenant"),
//           // Ajouter ici l'image si elle existe
//           if (etudiantPhoto != null)
//             pw.Image(pw.MemoryImage(etudiantPhoto!.readAsBytesSync())),
//           pw.SizedBox(height: 16),
//           pw.Text("IDENTIFICATION DE L'APPRENANT"),
//           pw.Text("Prénom et Nom"),
//           pw.Text("Date de Naissance et Sexe"),
//           pw.Text("Nationalité et Statut Matrimonial"),
//           pw.Text("Adresse"),
//           pw.Text("Téléphone et Email"),
//           pw.SizedBox(height: 16),
//           pw.Text("IDENTIFICATION DU TUTEUR OU DE L'ENTREPRISE"),
//           pw.Text("Raison Sociale"),
//           pw.Text("Nom du Tuteur"),
//           pw.Text("Adresse"),
//           pw.Text("Téléphone Bureau et Téléphone Cellulaire"),
//           pw.SizedBox(height: 16),
//           pw.Text("ENGAGEMENTS"),
//           pw.Text("Scolarité Annuelle"),
//           pw.Text("Frais d'inscription"),
//           pw.Text("Frais Soutenance"),
//           pw.Text("Frais Assurance"),
//           pw.Text("Frais de Stage"),
//           pw.SizedBox(height: 16),
//           pw.Text("PAIEMENT"),
//           pw.SizedBox(height: 16),
//           pw.Text(
//               "-L'inscription sera comptabilisée après règlement des frais et aucune somme ne sera remboursée, sauf si pour des raisons d'effectif, la session n'est pas ouverte."),
//           pw.SizedBox(height: 8),
//           pw.Text(
//               "-Tout inscription rend obligatoire le coût annuel de la formation, toute autre modalité de règlement, ne constitue que des facilités accordées aux apprenants qui demandent."),
//           pw.SizedBox(height: 8),
//           pw.Text(
//               "-L'apprenant s'engage à fournir toutes les pièces requises pour son inscription ou à compléter les pièces manquantes, et atteste qu'elles sont toutes authentiques et légales, à défaut il engage sa responsabilité."),
//           pw.SizedBox(height: 8),
//           pw.Text("APPRENANT, TUTEUR, DIRECTEUR DES ETUDES, LA CAISSE"),
//         ],
//       );
//     }));

//     // Enregistrer le PDF dans le stockage
//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/formulaire_inscription.pdf");
//     await file.writeAsBytes(await pdf.save());

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("PDF généré avec succès !")),
//     );
//   }

//   // Récupération de la date actuelle
//   String getCurrentDate() {
//     DateTime now = DateTime.now();
//     return "${now.day}/${now.month}/${now.year}";
//   }

//   // Méthode pour créer un champ de texte
//   Widget buildTextField(String label, {bool isShort = false, TextEditingController? controller}) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: isShort ? 1 : 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//                 fillColor: Colors.white,
//                 filled: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Méthode pour afficher les titres des sections
//   Widget buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Formulaire d\'inscription'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Photo de l'étudiant
//               GestureDetector(
//                 onTap: pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.blueAccent,
//                   backgroundImage: etudiantPhoto != null ? FileImage(etudiantPhoto!) : null,
//                   child: etudiantPhoto == null
//                       ? Icon(Icons.camera_alt, color: Colors.white)
//                       : null,
//                 ),
//               ),
//               buildSectionTitle("INFORMATIONS DE L'ÉCOLE"),
//               buildTextField("Nom de l'École", controller: _schoolNameController),
//               buildTextField("Agrément de l'École", controller: _schoolAccreditationController),
//               buildSectionTitle("IDENTIFICATION DE L'APPRENANT"),
//               buildDualTextField("Prénom", "Nom"),
//               buildDualTextField("Date de naissance", "Sexe"),
//               buildDualTextField("Nationalité", "Statut matrimonial"),
//               buildTextField("Adresse"),
//               buildDualTextField("Téléphone", "Email"),
//               buildSectionTitle("IDENTIFICATION DU TUTEUR OU DE L'ENTREPRISE"),
//               buildTextField("Raison Sociale"),
//               buildTextField("Nom du Tuteur"),
//               buildTextField("Adresse"),
//               buildDualTextField("Téléphone Bureau", "Téléphone Cellulaire"),
//               buildSectionTitle("ENGAGEMENTS"),
//               buildTextField("Scolarité Annuelle"),
//               buildTextField("Frais d'inscription"),
//               buildTextField("Frais Soutenance"),
//               buildTextField("Frais Assurance"),
//               buildTextField("Frais de Stage"),
//               buildPaymentSection(),
//               buildFooterRow("Signature de l'Apprenant", "Signature du Tuteur", "Signature de la Direction des Etudes"),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _generatePDF,
//         child: Icon(Icons.download),
//       ),
//     );
//   }

//   // Section pour le paiement
//   Widget buildPaymentSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         children: [
//           Text(
//             "PAIEMENT",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//           ),
//           Text("Les frais sont à régler en début d'année scolaire."),
//         ],
//       ),
//     );
//   }

//   // Champs pour afficher des informations côte à côte
//   Widget buildDualTextField(String label1, String label2) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(child: buildTextField(label1)),
//           SizedBox(width: 16),
//           Expanded(child: buildTextField(label2)),
//         ],
//       ),
//     );
//   }

//   // Footer pour les signatures
//   Widget buildFooterRow(String label1, String label2, String label3) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Text(label1),
//               SizedBox(height: 20),
//               Container(width: 100, height: 2, color: Colors.blueAccent),
//             ],
//           ),
//           Column(
//             children: [
//               Text(label2),
//               SizedBox(height: 20),
//               Container(width: 100, height: 2, color: Colors.blueAccent),
//             ],
//           ),
//           Column(
//             children: [
//               Text(label3),
//               SizedBox(height: 20),
//               Container(width: 100, height: 2, color: Colors.blueAccent),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
