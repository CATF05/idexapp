import 'package:flutter/material.dart';

class PlanificationExamensPage extends StatefulWidget {
  @override
  _PlanificationExamensPageState createState() =>
      _PlanificationExamensPageState();
}

class _PlanificationExamensPageState extends State<PlanificationExamensPage> {
  TextEditingController examNameController = TextEditingController();
  TextEditingController examCodeController = TextEditingController();
  String? selectedSubject;
  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedRoom;

  List<String> subjects = ["Mathématiques", "Physique", "Informatique"];
  List<String> days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];
  List<String> rooms = ["Salle 101", "Salle 102", "Salle 103"];
  List<Map<String, dynamic>> exams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planification des Examens"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Planifier un Examen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: examNameController,
              decoration: const InputDecoration(
                labelText: "Nom de l'Examen",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: examCodeController,
              decoration: const InputDecoration(
                labelText: "Code de l'Examen",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sélectionner une Matière",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: selectedSubject,
              hint: const Text("Choisir une matière"),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              items: subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sélectionner un Jour",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: selectedDay,
              hint: const Text("Choisir un jour de la semaine"),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
              items: days.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Heure de Début",
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: Text(startTime == null
                  ? 'Sélectionner Heure de Début'
                  : startTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: _selectStartTime,
            ),
            const SizedBox(height: 10),
            const Text(
              "Heure de Fin",
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: Text(endTime == null
                  ? 'Sélectionner Heure de Fin'
                  : endTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: _selectEndTime,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sélectionner une Salle",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: selectedRoom,
              hint: const Text("Choisir une salle"),
              onChanged: (value) {
                setState(() {
                  selectedRoom = value;
                });
              },
              items: rooms.map((room) {
                return DropdownMenuItem<String>(
                  value: room,
                  child: Text(room),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Planifier Examen"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Historique des Examens Planifiés",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  return Card(
                    child: ListTile(
                      title: Text(exam['name']),
                      subtitle: Text(
                          "${exam['subject']} | ${exam['day']} | ${exam['startTime']} - ${exam['endTime']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editExam(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteExam(index),
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

  void _selectStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != startTime)
      setState(() {
        startTime = pickedTime;
      });
  }

  void _selectEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != endTime)
      setState(() {
        endTime = pickedTime;
      });
  }

  void _saveExam() {
    if (examNameController.text.isNotEmpty &&
        examCodeController.text.isNotEmpty &&
        selectedSubject != null &&
        selectedDay != null &&
        startTime != null &&
        endTime != null &&
        selectedRoom != null) {
      setState(() {
        exams.add({
          'name': examNameController.text,
          'code': examCodeController.text,
          'subject': selectedSubject,
          'day': selectedDay,
          'startTime': startTime!.format(context),
          'endTime': endTime!.format(context),
          'room': selectedRoom,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Examen planifié avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }

  void _editExam(int index) {
    // Logic to edit an exam
  }

  void _deleteExam(int index) {
    setState(() {
      exams.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Examen supprimé")),
    );
  }
}
