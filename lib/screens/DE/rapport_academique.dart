import 'package:flutter/material.dart';

class RapportsAcademiquePage extends StatefulWidget {
  @override
  _RapportsAcademiquePageState createState() =>
      _RapportsAcademiquePageState();
}

class _RapportsAcademiquePageState extends State<RapportsAcademiquePage> {
  TextEditingController reportTitleController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  List<Map<String, dynamic>> rapports = [
    {
      'title': 'Rapport de Mathématiques - 1er Semestre',
      'studentName': 'John Doe',
      'grade': 'A',
      'comments': 'Excellent travail',
    },
    {
      'title': 'Rapport de Physique - 2ème Semestre',
      'studentName': 'Jane Smith',
      'grade': 'B',
      'comments': 'Bon travail, mais des améliorations possibles',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapports Académiques"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Générer un Rapport Académique",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reportTitleController,
              decoration: const InputDecoration(
                labelText: "Titre du Rapport",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studentNameController,
              decoration: const InputDecoration(
                labelText: "Nom de l'Étudiant",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentsController,
              decoration: const InputDecoration(
                labelText: "Commentaires",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Générer le Rapport"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Historique des Rapports Académiques",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rapports.length,
                itemBuilder: (context, index) {
                  final report = rapports[index];
                  return Card(
                    child: ListTile(
                      title: Text(report['title']),
                      subtitle: Text(
                          "${report['studentName']} | Note: ${report['grade']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editReport(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteReport(index),
                          ),
                        ],
                      ),
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

  void _generateReport() {
    if (reportTitleController.text.isNotEmpty &&
        studentNameController.text.isNotEmpty &&
        gradeController.text.isNotEmpty &&
        commentsController.text.isNotEmpty) {
      setState(() {
        rapports.add({
          'title': reportTitleController.text,
          'studentName': studentNameController.text,
          'grade': gradeController.text,
          'comments': commentsController.text,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rapport généré avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }

  void _editReport(int index) {
    setState(() {
      reportTitleController.text = rapports[index]['title'];
      studentNameController.text = rapports[index]['studentName'];
      gradeController.text = rapports[index]['grade'];
      commentsController.text = rapports[index]['comments'];
    });
    _showEditDialog(index);
  }

  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier le Rapport"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reportTitleController,
                decoration: const InputDecoration(labelText: "Titre du Rapport"),
              ),
              TextField(
                controller: studentNameController,
                decoration:
                    const InputDecoration(labelText: "Nom de l'Étudiant"),
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: "Note"),
              ),
              TextField(
                controller: commentsController,
                decoration:
                    const InputDecoration(labelText: "Commentaires"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateReport(index);
              },
              child: const Text("Enregistrer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  void _updateReport(int index) {
    setState(() {
      rapports[index] = {
        'title': reportTitleController.text,
        'studentName': studentNameController.text,
        'grade': gradeController.text,
        'comments': commentsController.text,
      };
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rapport mis à jour")),
    );
  }

  void _deleteReport(int index) {
    setState(() {
      rapports.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rapport supprimé")),
    );
  }
}
