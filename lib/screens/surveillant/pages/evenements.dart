import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/widgets/calandrier_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class Evenements extends StatelessWidget {
  Widget home;
  Evenements({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: home,
          ),
          const Expanded(
            child: EvenementsHome(),
          ),
        ],
      ),
    );
  }
}

class EvenementsHome extends ConsumerStatefulWidget {
  const EvenementsHome({super.key});

  @override
  ConsumerState<EvenementsHome> createState() => _EvenementsHomeState();
}

class _EvenementsHomeState extends ConsumerState<EvenementsHome> {
  List<Evenement> events = <Evenement>[];
  List<String> absents = [];

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  Future<void> _getDataSource() async {
    events = [];
    List<CoursModel> cours = [];

    try {
      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('cours').get();
      for (var f in querySnapshot2.docs) {
        cours.add(CoursModel.fromMap(f.data()));
      }
      setState(() {});
    } catch (e) {
      debugPrint('Erreur recuperations cours: $e');
    }

    for (var c in cours) {
      for (var p in c.programmations) {
        events.add(
          Evenement(
            description: c.nom,
            heureDebut: p.heureDebut,
            heureFin: p.heureFin,
            salle: p.salle,
            idEvent: p.idEvent,
            idCours: p.idCours,
            dejaFait: p.dejaFait,
            classe: p.classe,
            absences: p.absences,
            profAbscent: p.profAbscent,
            background: DateTime.now().compareTo(p.heureFin) == 1
                ? Colors.grey
                : p.background,
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Événements',
            style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              // height: 65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Événements de la journée",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          events
                              .where((e) =>
                                  (e.heureDebut.year == DateTime.now().year &&
                                      e.heureDebut.month == DateTime.now().month &&
                                      e.heureDebut.day == DateTime.now().day))
                              .length
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Événements planifiés",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          events.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(200, 30)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(width: 1)))),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Filtrer",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(200, 30)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(width: 1)))),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Ajouter un Événement",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CalandarWidget(
                evens: events,
                onTap: (calendarTapDetails) {
                  _showAbsenceSheet(context, calendarTapDetails.appointments!.first);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAbsenceSheet(BuildContext context, Evenement evenement) async {
    List<EtudiantModel> etudiants = [];
    
    final querySnapshot1 = await FirebaseFirestore.instance
      .collection('students').where('classe', isEqualTo: evenement.classe)
      .get();
    for (var f in querySnapshot1.docs) {
      etudiants.add(EtudiantModel.fromMap(f.data()));
    }

    final querySnapshot2 = await FirebaseFirestore.instance
      .collection('cours').doc(evenement.idCours).get();
    CoursModel coursModel = CoursModel.fromMap(querySnapshot2.data()!);

    int j = 0;
    for (var i = 0; i < coursModel.programmations.length; i++) {
      if (coursModel.programmations[i].idEvent==evenement.idEvent) {
        j = i;
        break;
      }
    }
    setState(() {
      absents = coursModel.programmations[j].absences;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sélectionnez les absents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text("Professeur"),
                    value: evenement.profAbscent,
                    onChanged: (bool? value) {
                      setModalState(() {
                        evenement.profAbscent = value!;
                        if (value == true) {
                          absents = [];
                        }
                      });
                      setState(() {}); // Met à jour la liste principale
                    },
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: etudiants.length,
                      itemBuilder: (context, index) {
                        final studentName = '${etudiants[index].prenom} ${etudiants[index].nom}';
                        final studentId = etudiants[index].idStudent;
                        return CheckboxListTile(
                          title: Text(studentName),
                          value: absents.contains(studentId),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                absents.add(studentId);
                              } else {
                                absents.remove(studentId);
                              }
                            });
                            setState(() {}); // Met à jour la liste principale
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        coursModel.programmations[j].absences = absents;
                        coursModel.programmations[j].profAbscent = evenement.profAbscent;
                      });
                      ref.watch(coursControllerProvider.notifier).addCour(coursModel, context, true);
                      Navigator.pop(context);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       "Étudiants absents: ${absents.join(', ')}",
                      //     ),
                      //   ),
                      // );
                    },
                    child: const Text('Valider les absents'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void showPicker(Evenement evenement) async {
  //   // DemandeInscription? _selectedDemande;
  //   // EtudiantModel? selectedClasse;
  //   // TextEditingController searchDemandeController = TextEditingController();
  //   List<EtudiantModel> etudiants = [];
    
  //   final querySnapshot1 = await FirebaseFirestore.instance.collection('students').
  //     where(
  //       'classe',
  //       isEqualTo: evenement.classe
  //     ).get();
  //   for (var f in querySnapshot1.docs) {
  //     etudiants.add(EtudiantModel.fromMap(f.data()));
  //   }

  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Sélectionnez les absents',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             Expanded(
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: etudiants.length,
  //                 itemBuilder: (context, index) {
  //                   final studentName = '${etudiants[index].prenom} ${etudiants[index].nom}';
  //                   final studentId = etudiants[index].idStudent;
  //                   return CheckboxListTile(
  //                     title: Text(studentName),
  //                     value: absents.contains(studentId),
  //                     onChanged: (bool? value) {
  //                       // _toggleSelection(studentId);
  //                       // print(studentId);
  //                       // print(absents);
  //                       setModalState(() {
  //                             if (value == true) {
  //                               absents.add(studentName);
  //                             } else {
  //                               absents.remove(studentName);
  //                             }
  //                           });
  //                           setState(() {});
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(
  //                       "Étudiants absents: ${absents.join(', ')}",
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: const Text('Valider les absents'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
