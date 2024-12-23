import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationFormPage extends StatefulWidget {
  @override
  _RegistrationFormPageState createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  File? etudiantPhoto;

   // Méthode pour choisir la photo de l'employé
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          etudiantPhoto = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection de l'image : $e");
    }
  }

  // Méthode pour sauvegarder les données
  void _saveForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Formulaire enregistré avec succès !")),
    );
  }

  // Méthode pour générer un PDF
  void _generatePDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF généré avec succès !")),
    );
  }

  // Récupération de la date actuelle
  String getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  } 

  // Méthode pour créer un champ de texte
  Widget buildTextField(String label, {bool isShort = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: isShort ? 1 : 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour créer un champ de texte à double entrée
  Widget buildDualTextField(String label1, String label2) {
    return Row(
      children: [
        Expanded(child: buildTextField(label1, isShort: true)),
        SizedBox(width: 16),
        Expanded(child: buildTextField(label2, isShort: true)),
      ],
    );
  }

  // Méthode pour afficher les titres des sections
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }Widget buildPaymentSection() {
  return Column(
    children: [
      Text(
        "Paiement le 05 de chaque mois au plus tard :",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      // Alignement des champs par 3 mois côte à côte sans espace entre eux
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 colonnes
          crossAxisSpacing: 0.0, // Pas d'espaces horizontaux
          mainAxisSpacing: 0.0,  // Espace vertical réduit entre les lignes
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          String month = getMonth(index + 1);
          return Padding(
            padding: EdgeInsets.zero, // Pas de marge autour des champs
            child: TextField(
              decoration: InputDecoration(
                labelText: "$month : Somme versée",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
          );
        },
      ),
    ],
  );
}

  // Méthode pour obtenir le nom du mois
  String getMonth(int monthIndex) {
    List<String> months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet",
      "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[monthIndex - 1];
  }

  // Méthode pour afficher les colonnes de signature
  Widget buildFooterColumn(String label) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        SizedBox(height: 40), // Espace pour la signature
        Container(
          height: 1,
          width: 100,
          color: Colors.blueAccent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiche d'Inscription", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: "Enregistrer",
            onPressed: _saveForm,
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: "Générer un PDF",
            onPressed: _generatePDF,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Text(
                      "INSTITUT D'EXCELLENCE DU SÉNÉGAL",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Agrément N°:RepSen/Ensup-Priv/AP/394 -2021",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Fiche d'Inscription 2024 - 2025",
                      style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text("Fait à Dakar le : ${getCurrentDate()}", style: TextStyle(color: Colors.blueAccent)),
                  ],
                ),
              ),
              Divider(thickness: 2, color: Colors.blueAccent),

              // Photo d'identité
              Center(
                child: Column(
                  children: [
                    Text(
                      "Photo d'identité de l'apprenant",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: etudiantPhoto == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.blueAccent,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                etudiantPhoto!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.image),
                      label: Text("Choisir une Image"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Identification de l'apprenant
              buildSectionTitle("IDENTIFICATION DE L'APPRENANT"),
              buildTextField("Prénom et Nom"),
              buildDualTextField("Date de Naissance", "Sexe"),
              buildDualTextField("Nationalité", "Statut Matrimonial"),
              buildTextField("Adresse"),
              buildDualTextField("Téléphone", "Email"),

              SizedBox(height: 16),

              // Identification du tuteur
              buildSectionTitle("IDENTIFICATION DU TUTEUR OU DE L'ENTREPRISE"),
              buildTextField("Raison Sociale"),
              buildTextField("Nom du Tuteur"),
              buildTextField("Adresse"),
              buildDualTextField("Téléphone Bureau", "Téléphone Cellulaire"),

              SizedBox(height: 16),

              // Engagements
              buildSectionTitle("ENGAGEMENTS"),
              buildTextField("Scolarité Annuelle"),
              buildTextField("Frais d'inscription"),
              buildTextField("Frais Soutenance"),
              buildTextField("Frais Assurance"),
              buildTextField("Frais de Stage"),

              SizedBox(height: 16),

              // Paiement
              buildSectionTitle("PAIEMENT"),
              buildPaymentSection(),

              SizedBox(height: 16),

            Text(
          "-L'inscription sera comptabilisée après règlement des frais et aucune somme ne sera remboursé, sauf si pour des raisons d'effectif,la session n'est pas ouverte",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

          Text(
          "-Tout inscription rend obligatoire le coût annuel de la formatio,toute autre modalité de réglement,ne constyitut que des facilités accordés aux apprenants qui demandent  ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),


          Text(
          "-L'aprenant s'angage à fournir toutes les piéces requises pour son inscription ou à completer les piéces manquante, et atteste qu'elles sont toutes authentiques et légales ,à defaut il engage sa responsabilité",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),


              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFooterColumn("APPRENANT"),
                  buildFooterColumn("TUTEUR"),
                  buildFooterColumn("DIRECTEUR DES ETUDES "),
                  buildFooterColumn("La CAISSE"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
