import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CertificatPage extends StatefulWidget {
  @override
  _CertificatPageState createState() => _CertificatPageState();
}

class _CertificatPageState extends State<CertificatPage> {
  TextEditingController studentIdController = TextEditingController();
  String? studentName;
  String? selectedCertificatType;
  DateTime? issueDate = DateTime.now();
  String? studentProgram;

  List<String> certificatTypes = [
    'Certificat de Scolarité',
    'Certificat de Présence',
    'Certificat de Réussite',
    'Autre'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Génération de Certificat"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recherche d'Étudiant",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: "Identifiant de l'Étudiant",
                border: OutlineInputBorder(),
              ),
              onSubmitted: _fetchStudentData,
            ),
            const SizedBox(height: 20),
            if (studentName != null)
              Text(
                "Étudiant : $studentName",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            const Text(
              "Sélectionnez le type de certificat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCertificatType,
              hint: const Text("Choisir un type de certificat"),
              onChanged: (value) {
                setState(() {
                  selectedCertificatType = value;
                });
              },
              items: certificatTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Informations supplémentaires",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Programme d'Études",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  studentProgram = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Date de génération du certificat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${DateFormat('dd/MM/yyyy').format(issueDate!)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateCertificat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Générer Certificat"),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchStudentData(String studentId) {
    // Logique pour récupérer les données de l'étudiant
    setState(() {
      studentName = "John Doe"; // Exemple de nom récupéré
    });
  }

  void _generateCertificat() {
    if (selectedCertificatType != null && studentName != null && studentProgram != null) {
      // Logique pour générer le certificat (ex: export en PDF)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Certificat généré avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }
}
