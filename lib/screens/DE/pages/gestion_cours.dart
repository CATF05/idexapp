import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data_sources/cours_data_source.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/classe_model.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/screens/DE/de_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/nav_helper.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/sort_icon.dart';
import 'package:sidebarx/sidebarx.dart';

class GestionCours extends StatelessWidget {
  Widget home;
  GestionCours({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: DirecteurEtudesScreen(),
          ),
          Expanded(
            child: GestionCoursHome(
              home: home,
            ),
          ),
        ],
      ),
    );
  }
}

class GestionCoursHome extends ConsumerStatefulWidget {
  Widget home;
  GestionCoursHome({super.key, required this.home});

  @override
  ConsumerState<GestionCoursHome> createState() => _GestionCoursHomeState();
}

class _GestionCoursHomeState extends ConsumerState<GestionCoursHome> {
  TextEditingController searchController = TextEditingController();
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late CoursDataSource _coursDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;
  List<CoursModel> initialCours = [];
  List<CoursModel> cours = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('cours').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var f in querySnapshot.docs) {
          cours.add(CoursModel.fromMap(f.data()));
          initialCours.add(CoursModel.fromMap(f.data()));
        }
      }
      setState(() {});
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final currentRouteOption = getCurrentRouteOption(context);
      _coursDataSource = CoursDataSource(
          context,
          cours,
          // widget.home,
          false,
          currentRouteOption == rowTaps,
          currentRouteOption == rowHeightOverrides,
          currentRouteOption == showBordersWithZebraStripes);
      _initialized = true;
      _coursDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(CoursModel d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _coursDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coursDataSource.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const alwaysShowArrows = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Cours',
            style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const Text(
            //   'Liste des Etudiants',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: AjouterCours,
                  style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                      shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(side: BorderSide(width: 1)))),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Ajouter un Cours",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 440,
                  height: 45,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) async {
                      // setState(() {
                      //   etudiants = _filteredFactures(initialEtudiants);
                      //   final currentRouteOption =
                      //       getCurrentRouteOption(context);
                      //   _coursDataSource = StudentDataSource(
                      //     context,
                      //     widget.home,
                      //     etudiants,
                      //     false,
                      //     currentRouteOption == rowTaps,
                      //     currentRouteOption == rowHeightOverrides,
                      //     currentRouteOption == showBordersWithZebraStripes,
                      //   );
                      // });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Recherchez un nom ou un identifiant',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Theme(
              data: ThemeData(
                iconTheme: const IconThemeData(color: Colors.white),
                scrollbarTheme: ScrollbarThemeData(
                  thickness: WidgetStateProperty.all(5),
                ),
              ),
              child: SizedBox(
                height: 495,
                child: DataTable2(
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.grey[850]!),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  headingCheckboxTheme: const CheckboxThemeData(
                      side: BorderSide(color: Colors.white, width: 2.0)),
                  isHorizontalScrollBarVisible: true,
                  isVerticalScrollBarVisible: true,
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  sortArrowBuilder: getCurrentRouteOption(context) == custArrows
                      ? (ascending, sorted) => sorted || alwaysShowArrows
                          ? Stack(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: SortIcon(
                                        ascending: true,
                                        active: sorted && ascending)),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SortIcon(
                                        ascending: false,
                                        active: sorted && !ascending)),
                              ],
                            )
                          : null
                      : null,
                  border: getCurrentRouteOption(context) == fixedColumnWidth
                      ? TableBorder(
                          top: const BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.grey[300]!),
                          left: BorderSide(color: Colors.grey[300]!),
                          right: BorderSide(color: Colors.grey[300]!),
                          verticalInside: BorderSide(color: Colors.grey[300]!),
                          horizontalInside:
                              const BorderSide(color: Colors.grey, width: 1))
                      : (getCurrentRouteOption(context) ==
                              showBordersWithZebraStripes
                          ? TableBorder.all()
                          : null),
                  dividerThickness:
                      1, // this one will be ignored if [border] is set above
                  bottomMargin: 10,
                  minWidth: 900,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
                  sortArrowAnimationDuration: const Duration(
                      milliseconds: 500), // custom animation duration
                  onSelectAll: (val) =>
                      setState(() => _coursDataSource.selectAll(val)),
                  columns: [
                    DataColumn2(
                      label: const Text('Nom'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.nom, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Classe'),
                      size: ColumnSize.S,
                      fixedWidth: 220,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.classe, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Prof'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.nomProf, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Nombres Etudiants'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.nbEtudiants.toString(),
                          columnIndex,
                          ascending),
                    ),
                    DataColumn2(
                      label: const Text('Progréssion'),
                      size: ColumnSize.S,
                      // fixedWidth: 200,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.nbHeuresDejaFait.toString(),
                          columnIndex,
                          ascending),
                    ),
                    const DataColumn2(
                      label: Text('Actions'),
                      size: ColumnSize.S,
                    ),
                  ],
                  empty: Center(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: const Text('No data'))),
                  rows: getCurrentRouteOption(context) == noData
                      ? []
                      : List<DataRow>.generate(_coursDataSource.rowCount,
                          (index) => _coursDataSource.getRow(index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<EtudiantModel> _filteredFactures(List<EtudiantModel> etudiants) {
  //   if (searchController.text.isEmpty) {
  //     return etudiants;
  //   }
  //   return etudiants.where((etudiant) {
  //     return etudiant.idStudent
  //             .toLowerCase()
  //             .contains(searchController.text.toLowerCase()) ||
  //         '${etudiant.prenom} ${etudiant.nom}'
  //             .toLowerCase()
  //             .contains(searchController.text.toLowerCase());
  //   }).toList();
  // }

  void AjouterCours() async {
    final _formKey = GlobalKey<FormState>();
    List<ClasseModel> classes = [];
    List<ProfModel> profs = [];
    ClasseModel? selectedClasse;
    ProfModel? selectedProf;
    TextEditingController nomController = TextEditingController();
    TextEditingController descriptionController =
        TextEditingController(text: '');
    TextEditingController salleController = TextEditingController(text: '');
    TextEditingController nbHeuresController = TextEditingController();

    try {
      final querySnapshot1 =
          await FirebaseFirestore.instance.collection('classes').get();
      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('profs').get();
      for (var f in querySnapshot1.docs) {
        classes.add(ClasseModel.fromMap(f.data()));
      }
      for (var f in querySnapshot2.docs) {
        profs.add(ProfModel.fromMap(f.data()));
      }
      setState(() {});
    } catch (e) {
      print('Erreur: $e');
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Cours"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<ClasseModel>(
                  // validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Pour la classe',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedClasse,
                  items: classes
                      // .map((c) => c.nom)
                      .map((classe) => DropdownMenuItem(
                            value: classe,
                            child: Text(classe.nom),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClasse = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<ProfModel>(
                  // validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Prof en charge du cours',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedProf,
                  items: profs
                      // .map((c) => "${c.nom}|${c.idProf}")
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method.nom),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProf = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nomController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Décrire le cours',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nbHeuresController,
                  decoration: const InputDecoration(
                    labelText: "Nombre d'heures",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false){
                  CoursModel coursModel = CoursModel(
                    id: generateIdStudent("C0", 3),
                    nom: nomController.text,
                    classe: selectedClasse!.nom,
                    description: descriptionController.text,
                    idProf: selectedProf!.idProf,
                    nomProf: selectedProf!.nom,
                    salle: salleController.text,
                    programmations: [],
                    nbHeures: int.parse(nbHeuresController.text),
                    nbHeuresDejaFait: 0,
                    nbEtudiants: 0,
                  );
                  setState(() {
                    cours.add(coursModel);
                  });

                  // mettre a jour la classe
                  selectedClasse!.idCours.add(coursModel.id);
                  await ref.watch(classesControllerProvider.notifier).addClasse(selectedClasse!, context);
                  // mettre a jour le prof
                  selectedProf!.cours.add(coursModel.id);
                  await ref.watch(profsControllerProvider.notifier).addProf(selectedProf!, context, true);

                  await ref.watch(coursControllerProvider.notifier).addCour(coursModel, context);

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}

// class GestionCoursHome extends StatefulWidget {
//   Widget home;
//   GestionCoursHome({super.key, required this.home});

//   @override
//   _GestionCoursHomeState createState() => _GestionCoursHomeState();
// }

// class _GestionCoursHomeState extends State<GestionCoursHome> {
//   TextEditingController courseNameController = TextEditingController();
//   TextEditingController courseCodeController = TextEditingController();
//   TextEditingController courseDescriptionController = TextEditingController();
//   String? selectedProfessor;
//   String? selectedDay;
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;
//   String? selectedRoom;

//   List<String> professors = ["Professeur A", "Professeur B", "Professeur C"];
//   List<String> days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"];
//   List<String> rooms = ["Salle 101", "Salle 102", "Salle 103"];
//   List<Map<String, dynamic>> courses = [];
//   List<String> students = ["Étudiant 1", "Étudiant 2", "Étudiant 3"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Gestion des Cours"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Ajouter un Cours",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: courseNameController,
//                 decoration: const InputDecoration(
//                   labelText: "Nom du Cours",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: courseCodeController,
//                 decoration: const InputDecoration(
//                   labelText: "Code du Cours",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: courseDescriptionController,
//                 decoration: const InputDecoration(
//                   labelText: "Description du Cours",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Sélectionner un Professeur",
//                 style: TextStyle(fontSize: 16),
//               ),
//               DropdownButton<String>(
//                 value: selectedProfessor,
//                 hint: const Text("Choisir un professeur"),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedProfessor = value;
//                   });
//                 },
//                 items: professors.map((prof) {
//                   return DropdownMenuItem<String>(
//                     value: prof,
//                     child: Text(prof),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Sélectionner un Jour",
//                 style: TextStyle(fontSize: 16),
//               ),
//               DropdownButton<String>(
//                 value: selectedDay,
//                 hint: const Text("Choisir un jour de la semaine"),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedDay = value;
//                   });
//                 },
//                 items: days.map((day) {
//                   return DropdownMenuItem<String>(
//                     value: day,
//                     child: Text(day),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Heure de Début",
//                 style: TextStyle(fontSize: 16),
//               ),
//               ListTile(
//                 title: Text(startTime == null
//                     ? 'Sélectionner Heure de Début'
//                     : startTime!.format(context)),
//                 trailing: Icon(Icons.access_time),
//                 onTap: _selectStartTime,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Heure de Fin",
//                 style: TextStyle(fontSize: 16),
//               ),
//               ListTile(
//                 title: Text(endTime == null
//                     ? 'Sélectionner Heure de Fin'
//                     : endTime!.format(context)),
//                 trailing: Icon(Icons.access_time),
//                 onTap: _selectEndTime,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Sélectionner une Salle",
//                 style: TextStyle(fontSize: 16),
//               ),
//               DropdownButton<String>(
//                 value: selectedRoom,
//                 hint: const Text("Choisir une salle"),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedRoom = value;
//                   });
//                 },
//                 items: rooms.map((room) {
//                   return DropdownMenuItem<String>(
//                     value: room,
//                     child: Text(room),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveCourse,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 ),
//                 child: const Text("Enregistrer Cours"),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Historique des Cours",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: [
//                   for(var course in courses)
//                     Card(
//                     child: ListTile(
//                       title: Text(course['name']),
//                       subtitle: Text(
//                           "${course['professor']} | ${course['day']} | ${course['startTime']} - ${course['endTime']}"),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () => _editCourse(0),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () => _deleteCourse(0),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Gestion des Étudiants",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               DropdownButton<String>(
//                 value: selectedProfessor,
//                 hint: const Text("Choisir un cours"),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedProfessor = value;
//                   });
//                 },
//                 items: courses.map((course) {
//                   return DropdownMenuItem<String>(
//                     value: course['name'],
//                     child: Text(course['name']),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Sélectionner un Étudiant",
//                 style: TextStyle(fontSize: 16),
//               ),
//               DropdownButton<String>(
//                 value: null,
//                 hint: const Text("Choisir un étudiant"),
//                 onChanged: (value) {
//                   setState(() {});
//                 },
//                 items: students.map((student) {
//                   return DropdownMenuItem<String>(
//                     value: student,
//                     child: Text(student),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   // Logic to enroll/un-enroll student
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                 ),
//                 child: const Text("Gérer l'Étudiant"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _selectStartTime() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null && pickedTime != startTime)
//       setState(() {
//         startTime = pickedTime;
//       });
//   }

//   void _selectEndTime() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null && pickedTime != endTime)
//       setState(() {
//         endTime = pickedTime;
//       });
//   }

//   void _saveCourse() {
//     if (courseNameController.text.isNotEmpty &&
//         courseCodeController.text.isNotEmpty &&
//         selectedProfessor != null &&
//         selectedDay != null &&
//         startTime != null &&
//         endTime != null &&
//         selectedRoom != null) {
//       setState(() {
//         courses.add({
//           'name': courseNameController.text,
//           'code': courseCodeController.text,
//           'description': courseDescriptionController.text,
//           'professor': selectedProfessor,
//           'day': selectedDay,
//           'startTime': startTime!.format(context),
//           'endTime': endTime!.format(context),
//           'room': selectedRoom,
//         });
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Cours enregistré avec succès")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Veuillez remplir tous les champs")),
//       );
//     }
//   }

//   void _editCourse(int index) {
//     // Logic to edit a course
//   }

//   void _deleteCourse(int index) {
//     setState(() {
//       courses.removeAt(index);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Cours supprimé")),
//     );
//   }
// }
