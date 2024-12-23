import 'package:flutter/material.dart';

class StrategicPlanningPage extends StatefulWidget {
  const StrategicPlanningPage({Key? key}) : super(key: key);

  @override
  _StrategicPlanningPageState createState() => _StrategicPlanningPageState();
}

class _StrategicPlanningPageState extends State<StrategicPlanningPage> {
  List<Map<String, String>> goals = [
    {"title": "Améliorer la satisfaction client", "timeline": "D'ici à la fin de l'année"},
    {"title": "Augmenter les revenus de 20%", "timeline": "Sur les 6 prochains mois"},
    {"title": "Réduire les coûts de 15%", "timeline": "Au cours du prochain trimestre"}
  ];

  List<Map<String, String>> initiatives = [
    {"title": "Formation des employés", "description": "Renforcer les compétences clés"},
    {"title": "Optimisation des processus", "description": "Réduire les redondances"},
    {"title": "Nouvelles stratégies de marketing", "description": "Atteindre plus de clients"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planification Stratégique', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Action pour les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Action pour les paramètres
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe0f7fa), Color(0xFFffffff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Objectifs Stratégiques',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildGoalList(),
              const SizedBox(height: 20),
              const Text(
                'Initiatives et Priorités',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildInitiativeList(),
              const SizedBox(height: 20),
              const Text(
                'Suivi et Progrès',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildProgressOverview(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter un nouvel objectif
          _showAddGoalDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent.shade700,
      ),
    );
  }

  // Méthode pour afficher la boîte de dialogue d'ajout d'objectif
  void _showAddGoalDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController timelineController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un Nouvel Objectif"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre de l\'objectif'),
              ),
              TextField(
                controller: timelineController,
                decoration: const InputDecoration(labelText: 'Délai'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                setState(() {
                  goals.add({
                    'title': titleController.text,
                    'timeline': timelineController.text,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher la boîte de dialogue d'édition d'objectif
  void _showEditGoalDialog(int index) {
    TextEditingController titleController = TextEditingController(text: goals[index]['title']);
    TextEditingController timelineController = TextEditingController(text: goals[index]['timeline']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier l'Objectif"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre de l\'objectif'),
              ),
              TextField(
                controller: timelineController,
                decoration: const InputDecoration(labelText: 'Délai'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () {
                setState(() {
                  goals[index] = {
                    'title': titleController.text,
                    'timeline': timelineController.text,
                  };
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalList() {
    return Column(
      children: goals.map((goal) {
        int index = goals.indexOf(goal);
        return _goalCard(goal["title"]!, goal["timeline"]!, index);
      }).toList(),
    );
  }

  Widget _goalCard(String title, String timeline, int index) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.flag, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("Délai: $timeline", style: const TextStyle(fontSize: 14)),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
          onPressed: () {
            // Action pour éditer l'objectif
            _showEditGoalDialog(index);
          },
        ),
      ),
    );
  }

  Widget _buildInitiativeList() {
    return Column(
      children: initiatives.map((initiative) {
        return _initiativeCard(initiative["title"]!, initiative["description"]!);
      }).toList(),
    );
  }

  Widget _initiativeCard(String title, String description) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.lightbulb, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.green),
          onPressed: () {
            // Action pour marquer l'initiative comme complétée
          },
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Column(
      children: [
        _progressIndicator("Formation des employés", 0.7),
        _progressIndicator("Optimisation des processus", 0.5),
        _progressIndicator("Nouvelles stratégies de marketing", 0.3),
      ],
    );
  }

  Widget _progressIndicator(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            color: Colors.blueAccent,
            backgroundColor: Colors.grey.shade300,
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
