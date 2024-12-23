import 'package:flutter/material.dart';

class FacturePage extends StatefulWidget {
  @override
  _FacturePageState createState() => _FacturePageState();
}

class _FacturePageState extends State<FacturePage> {
  List<Map<String, dynamic>> factures = [
    {
      "numero": "F001",
      "client": "Aliou Ndiaye",
      "date": "15/11/2024",
      "montant": 15000.0,
      "details": [
        {"article": "Produit A", "quantite": 2, "prix": 5000.0},
        {"article": "Produit B", "quantite": 1, "prix": 5000.0},
      ],
    },
    {
      "numero": "F002",
      "client": "Fatou Diop",
      "date": "14/11/2024",
      "montant": 20000.0,
      "details": [
        {"article": "Produit C", "quantite": 4, "prix": 5000.0},
      ],
    },
  ];

  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Factures'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Fonction pour exporter les factures
              _exportFactures();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Liste des Factures',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFactures().length,
                itemBuilder: (context, index) {
                  final facture = _filteredFactures()[index];
                  return _factureCard(facture, index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrEditDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  List<Map<String, dynamic>> _filteredFactures() {
    if (searchQuery.isEmpty) {
      return factures;
    }
    return factures.where((facture) {
      return facture['numero'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          facture['client'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          facture['date'].contains(searchQuery);
    }).toList();
  }

  void _showAddOrEditDialog({Map<String, dynamic>? facture, int? index}) {
    TextEditingController numeroController =
        TextEditingController(text: facture?['numero'] ?? "");
    TextEditingController clientController =
        TextEditingController(text: facture?['client'] ?? "");
    TextEditingController montantController =
        TextEditingController(text: facture?['montant']?.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(facture == null ? "Créer une Facture" : "Modifier la Facture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Numéro de Facture'),
              ),
              TextField(
                controller: clientController,
                decoration: const InputDecoration(labelText: 'Nom du Client'),
              ),
              TextField(
                controller: montantController,
                decoration: const InputDecoration(labelText: 'Montant Total'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (facture == null) {
                  // Ajouter une nouvelle facture
                  setState(() {
                    factures.add({
                      "numero": numeroController.text,
                      "client": clientController.text,
                      "date": DateTime.now().toString().split(' ')[0],
                      "montant": double.tryParse(montantController.text) ?? 0.0,
                      "details": [],
                    });
                  });
                } else {
                  // Modifier une facture existante
                  setState(() {
                    factures[index!] = {
                      "numero": numeroController.text,
                      "client": clientController.text,
                      "date": facture['date'],
                      "montant": double.tryParse(montantController.text) ?? 0.0,
                      "details": facture['details'],
                    };
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rechercher une Facture"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: 'Entrez un numéro ou un client'),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _exportFactures() {
    // Logique pour exporter les factures en PDF/Excel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exportation des factures...")),
    );
  }

  void _deleteFacture(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer la Facture"),
          content: const Text("Êtes-vous sûr de vouloir supprimer cette facture ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  factures.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _factureCard(Map<String, dynamic> facture, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text("Facture ${facture['numero']} - ${facture['client']}"),
        subtitle: Text("Date : ${facture['date']} - Montant : ${facture['montant']} FCFA"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: () {
                _showAddOrEditDialog(facture: facture, index: index);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteFacture(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
