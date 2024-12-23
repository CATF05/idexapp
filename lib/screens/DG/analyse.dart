import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Utilisé pour les graphiques

class AnalysePage extends StatefulWidget {
  @override
  _AnalysePageState createState() => _AnalysePageState();
}

class _AnalysePageState extends State<AnalysePage> {
  // Liste des performances des étudiants (données fictives)
  List<Map<String, dynamic>> performances = [
    {'student': 'John Doe', 'math': 85, 'physics': 90, 'chemistry': 75},
    {'student': 'Jane Smith', 'math': 78, 'physics': 85, 'chemistry': 80},
    {'student': 'Alice Johnson', 'math': 92, 'physics': 88, 'chemistry': 89},
    {'student': 'Bob Brown', 'math': 80, 'physics': 70, 'chemistry': 85},
  ];

  // Liste des matières à analyser
  List<String> subjects = ['math', 'physics', 'chemistry'];
  String selectedSubject = 'math';

  double _getAverage(String subject) {
    double total = 0;
    for (var performance in performances) {
      total += performance[subject];
    }
    return total / performances.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyse de Performance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Analyse de Performance des Étudiants",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedSubject,
              onChanged: (String? newSubject) {
                setState(() {
                  selectedSubject = newSubject!;
                });
              },
              items: subjects.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject.capitalize()),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildPerformanceChart(),
            const SizedBox(height: 20),
            const Text(
              "Résumé des Performances",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildStatistics(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: performances.length,
                itemBuilder: (context, index) {
                  var performance = performances[index];
                  return Card(
                    child: ListTile(
                      title: Text(performance['student']),
                      subtitle: Text(
                          "Math: ${performance['math']} | Physics: ${performance['physics']} | Chemistry: ${performance['chemistry']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          _showPerformanceDetails(performance);
                        },
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

  // Affiche un graphique de la performance des étudiants pour une matière sélectionnée
  Widget _buildPerformanceChart() {
    List<FlSpot> spots = [];
    for (var performance in performances) {
      spots.add(FlSpot(performances.indexOf(performance).toDouble(),
          performance[selectedSubject].toDouble()));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: performances.length.toDouble() - 1,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blueAccent,
              belowBarData: BarAreaData(show: true,
              color: Colors.blue.shade200),
            ),
          ],
        ),
      ),
    );
  }

  // Affiche les statistiques agrégées (moyenne, etc.)
  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Moyenne de $selectedSubject: ${_getAverage(selectedSubject).toStringAsFixed(2)}"),
        // Ajoutez d'autres statistiques ici si nécessaire (ex. médiane, max, min)
      ],
    );
  }

  // Affiche les détails de la performance d'un étudiant
  void _showPerformanceDetails(Map<String, dynamic> performance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${performance['student']} - Détails des Performances"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Math: ${performance['math']}"),
              Text("Physics: ${performance['physics']}"),
              Text("Chemistry: ${performance['chemistry']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}

// Extension pour capitaliser les premières lettres des matières
extension StringCapitalization on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
