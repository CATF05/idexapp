import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/common_pages/sauvegarde_pdf.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class SuiviCour extends StatelessWidget {
  Widget home;
  final CoursModel coursModel;
  SuiviCour({super.key, required this.coursModel, required this.home});

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
          Expanded(
            child: SuiviCourHome(coursModel: coursModel),
          ),
        ],
      ),
    );
  }
}

class SuiviCourHome extends ConsumerStatefulWidget {
  final CoursModel coursModel;
  const SuiviCourHome({super.key, required this.coursModel});

  @override
  ConsumerState<SuiviCourHome> createState() => _SuiviCourHomeState();
}

class _SuiviCourHomeState extends ConsumerState<SuiviCourHome> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod;
  String? selectedDesignation;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();
  TextEditingController descriptionController = TextEditingController(text: "");
  double progression = 0;
  int dejaProg = 0;
  TextEditingController nbSemaineController = TextEditingController(text: "1"); 
  bool repetition = false;
  // final TextEditingController designationController = TextEditingController();
  // late CoursModel coursModel;
  // EtudiantModel? etudiantModel;
  // List<String> designationList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // void fetchData() async {
  //   coursModel = widget.coursModel;
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance.collection('students').doc(factureModel.idStudent).get();
  //     setState(() {
  //       etudiantModel = EtudiantModel.fromMap(querySnapshot.data()!);
  //       designationList = etudiantModel!.echeances.where((e)=>e.montantAPayer>e.montantDejaPayer).map((e)=>e.description).toList();
  //     });
  //   } catch (e) {
  //     print('Erreur: $e');
  //   }
  // }

  void refreche() {
    setState(() {
      final dejaFait = widget.coursModel.programmations.where((p)=>p.dejaFait);
      final courDejaProg = widget.coursModel.programmations.sortWithDate((getDate)=>DateTime.now());
      if (dejaFait.isNotEmpty) {
        progression = dejaFait.map((p)=>p.nbHeures)
        .reduce((a, b)=>a+b) / widget.coursModel.nbHeures;
      }
      if (courDejaProg.isNotEmpty) {
        widget.coursModel.programmations.sort((e1, e2)=>e1.heureDebut.compareTo(e2.heureDebut));
        dejaProg = courDejaProg.map((p)=>p.nbHeures).reduce((a, b)=>a+b);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreche();
  }

  @override
  Widget build(BuildContext context) {
    refreche();
    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi du cours de ${widget.coursModel.nom}',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 90,
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
                          'Désignation',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.coursModel.nom,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Classe',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.coursModel.classe,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Prof',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.coursModel.nomProf,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Progréssion',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        LinearPercentIndicator(
                          width: 100,
                          animation: true,
                          lineHeight: 15.0,
                          animationDuration: 2000,
                          percent: progression,
                          center: Text(
                            "${progression * 100}%",
                            style: const TextStyle(fontSize: 13),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.greenAccent,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Card(
                      color: Colors.white,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(4),
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          Container(
                            height: 68,
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
                              child: Text(
                                'Programmation : $dejaProg H / ${widget.coursModel.nbHeures} déja programmé',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // DataTable
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: 380,
                                child: DataTable2(
                                  // minWidth: 500,
                                  // border: TableBorder.all(),
                                  columns: const [
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('Déscription')),
                                    DataColumn(label: Text("Nombre d'heure")),
                                    DataColumn(
                                      label: Text('Marquer fait'),
                                      numeric: true,
                                    ),
                                    // DataColumn(label: Text('Moyen de paiement')),
                                  ],
                                  rows: widget.coursModel.programmations
                                      // .sort((e1, e2)=>e1.heureDebut.difference(e2.heureDebut) == 1)
                                      .map(
                                        (p) => DataRow(
                                          cells: [
                                            DataCell(Text(p.heureDebut
                                                .toString()
                                                .split(' ')[0])),
                                            DataCell(Text(p.description)),
                                            DataCell(Text("${p.heureFin.difference(p.heureDebut).inHours}")),
                                            DataCell(
                                              Checkbox(
                                                value: p.dejaFait,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    p.dejaFait = value!;
                                                  });
                                                  await ref
                                                      .watch(
                                                          coursControllerProvider
                                                              .notifier)
                                                      .addCour(
                                                        widget.coursModel,
                                                        context,
                                                        true,
                                                      );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),
                  // Payment form
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: Colors.white,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(0),
                        bottom: Radius.circular(4),
                      )),
                      child: Column(
                        children: [
                          Container(
                            height: 68,
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
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Programmer une date :',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Déscription (facultative)',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(),
                                    ),
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text:
                                          selectedDate.toString().split(' ')[0],
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Démarre à',
                                            border: OutlineInputBorder(),
                                          ),
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: selectedTimeStart
                                                  .format(context)),
                                          onTap: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (pickedTime != null) {
                                              setState(() {
                                                selectedTimeStart = pickedTime;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Arréte à',
                                            border: OutlineInputBorder(),
                                          ),
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: selectedTimeEnd
                                                  .format(context)),
                                          onTap: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (pickedTime != null) {
                                              setState(() {
                                                selectedTimeEnd = pickedTime;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: repetition, 
                                        onChanged: (value) async {
                                          setState(() {
                                            repetition = value!;
                                          });
                                        }
                                      ),
                                      const Text("Répéter"),
                                      const SizedBox(width: 15),
                                      if(repetition)
                                        Expanded(
                                          child: TextFormField(
                                            controller: nbSemaineController,
                                            validator: validateNumber,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "x fois",
                                              labelStyle: TextStyle(color: Colors.grey),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Submit Button
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        setState(() {
                                          for (var i = 0; i < int.parse(nbSemaineController.text); i++) {
                                          Evenement coursDuJours =
                                              Evenement(
                                                description:
                                                    descriptionController.text,
                                                    idEvent: generateIdStudent("EV0", 6),
                                                idCours: widget.coursModel.id,
                                                heureDebut: selectedDate.add(Duration(days: i*7 , hours: selectedTimeStart.hour, minutes: selectedTimeStart.minute,)),
                                                heureFin: selectedDate.add(Duration(days: i*7 , hours: selectedTimeEnd.hour, minutes: selectedTimeEnd.minute,)),
                                                absences: [],
                                                background: Colors.green,
                                                salle: "",
                                                classe: widget.coursModel.classe,
                                                dejaFait: false,
                                                profAbscent: false,
                                              );

                                            widget.coursModel.programmations.add(coursDuJours);
                                          }
                                          // factureModel.montant += detail.montant;
                                          // etudiantModel!.echeances.where((e) => e.description == selectedDesignation).first.montantDejaPayer+=detail.montant;
                                        });
                                        // amountController.text = "";

                                        await ref.watch(coursControllerProvider.notifier)
                                          .addCour(
                                            widget.coursModel,
                                            context,
                                            true,
                                          );
                                        showSnackBar(
                                            context, "Cours Programmé");
                                      }
                                    },
                                    child: const Text('Ajouter'),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
