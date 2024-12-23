import 'package:flutter/material.dart';

class GestionCoursPage extends StatefulWidget {
  @override
  _GestionCoursPageState createState() => _GestionCoursPageState();
}

class _GestionCoursPageState extends State<GestionCoursPage> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseDescriptionController = TextEditingController();
  String? selectedProfessor;
  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedRoom;

  List<String> professors = ["Professeur A", "Professeur B", "Professeur C"];
  List<String> days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];
  List<String> rooms = ["Salle 101", "Salle 102", "Salle 103"];
  List<Map<String, dynamic>> courses = [];
  List<String> students = ["Étudiant 1", "Étudiant 2", "Étudiant 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des Cours"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ajouter un Cours",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: courseNameController,
              decoration: const InputDecoration(
                labelText: "Nom du Cours",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: courseCodeController,
              decoration: const InputDecoration(
                labelText: "Code du Cours",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: courseDescriptionController,
              decoration: const InputDecoration(
                labelText: "Description du Cours",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sélectionner un Professeur",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: selectedProfessor,
              hint: const Text("Choisir un professeur"),
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value;
                });
              },
              items: professors.map((prof) {
                return DropdownMenuItem<String>(
                  value: prof,
                  child: Text(prof),
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
              onPressed: _saveCourse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Enregistrer Cours"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Historique des Cours",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(course['name']),
                      subtitle: Text(
                          "${course['professor']} | ${course['day']} | ${course['startTime']} - ${course['endTime']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editCourse(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteCourse(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gestion des Étudiants",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedProfessor,
              hint: const Text("Choisir un cours"),
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value;
                });
              },
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course['name'],
                  child: Text(course['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sélectionner un Étudiant",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: null,
              hint: const Text("Choisir un étudiant"),
              onChanged: (value) {
                setState(() {});
              },
              items: students.map((student) {
                return DropdownMenuItem<String>(
                  value: student,
                  child: Text(student),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic to enroll/un-enroll student
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text("Gérer l'Étudiant"),
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

  void _saveCourse() {
    if (courseNameController.text.isNotEmpty &&
        courseCodeController.text.isNotEmpty &&
        selectedProfessor != null &&
        selectedDay != null &&
        startTime != null &&
        endTime != null &&
        selectedRoom != null) {
      setState(() {
        courses.add({
          'name': courseNameController.text,
          'code': courseCodeController.text,
          'description': courseDescriptionController.text,
          'professor': selectedProfessor,
          'day': selectedDay,
          'startTime': startTime!.format(context),
          'endTime': endTime!.format(context),
          'room': selectedRoom,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cours enregistré avec succès")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
    }
  }

  void _editCourse(int index) {
    // Logic to edit a course
  }

  void _deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cours supprimé")),
    );
  }
}
