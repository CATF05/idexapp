import 'package:flutter/material.dart';

class AttestationPage extends StatefulWidget {
  @override
  _AttestationPageState createState() => _AttestationPageState();
}

class _AttestationPageState extends State<AttestationPage> {
  String? selectedAttestation;
  TextEditingController studentIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  List<String> attestationTypes = [
    "Attestation de Scolarité",
    "Attestation de Réussite",
    "Attestation d'Inscription",
    "Attestation de Stage",
  ];

  List<Map<String, String>> generatedAttestations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Attestations"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recherche d’Étudiant",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: "Identifiant de l'Étudiant",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Type d'Attestation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedAttestation,
              hint: const Text("Sélectionnez un type"),
              items: attestationTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAttestation = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Informations de l'Étudiant",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: surnameController,
              decoration: const InputDecoration(
                labelText: "Prénom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAttestation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Générer Attestation"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Historique des Attestations Générées",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: generatedAttestations.length,
                itemBuilder: (context, index) {
                  final attestation = generatedAttestations[index];
                  return ListTile(
                    leading: const Icon(Icons.file_copy),
                    title: Text("${attestation['type']}"),
                    subtitle: Text(
                        "Étudiant : ${attestation['name']} ${attestation['surname']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _exportAttestation(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateAttestation() {
    if (selectedAttestation != null &&
        nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty) {
      setState(() {
        generatedAttestations.add({
          "type": selectedAttestation!,
          "name": nameController.text,
          "surname": surnameController.text,
          "date": DateTime.now().toString(),
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attestation générée avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }

  void _exportAttestation(int index) {
    // Logique pour exporter l'attestation au format PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attestation exportée avec succès")),
    );
  }
}
