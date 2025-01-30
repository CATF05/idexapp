import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/classe_model.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/common_pages/sauvegarde_pdf.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/calandrier_widget.dart';
import 'package:frontend/widgets/get_initial_widget.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class StudentView extends StatelessWidget {
  Widget home;
  final EtudiantModel etudiantModel;
  StudentView({super.key, required this.etudiantModel, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: home,),
          Expanded(
            child: StudentViewHome(etudiantModel: etudiantModel),
          ),
        ],
      ),
    );
  }
}


class StudentViewHome extends ConsumerStatefulWidget {
  final EtudiantModel etudiantModel;
  const StudentViewHome({super.key, required this.etudiantModel});

  @override
  ConsumerState<StudentViewHome> createState() => _StudentViewHomeState();
}

class _StudentViewHomeState extends ConsumerState<StudentViewHome>
  with SingleTickerProviderStateMixin {
  List<FactureModel> factures = [];
  List<Evenement> events = <Evenement>[];
  List<Evenement> eventsAbscent = <Evenement>[];
  TabController? tabBarController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: 1,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabBarController?.dispose();

    super.dispose();
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
        title: const Text('Etudiant', style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Row(
                      children: [
                        EtudiantProfilWidget(
                          fullName: '${widget.etudiantModel.prenom} ${widget.etudiantModel.nom}',
                          urlPhoto: widget.etudiantModel.urlPhoto,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.etudiantModel.prenom} ${widget.etudiantModel.nom}",
                              style: const TextStyle(fontWeight: FontWeight.bold),),
                            Text("Date de naissance: ${widget.etudiantModel.dateDeNaissance}"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                      child: VerticalDivider(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Classe :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.etudiantModel.classe,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Email :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.etudiantModel.email,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Téléphone :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.etudiantModel.telephone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Nationalité :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.etudiantModel.nationalite,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            Card(
              color: Colors.white,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(0),
                  bottom: Radius.circular(4),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height - 280,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: const Alignment(0, 0),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelStyle:
                                const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                            unselectedLabelStyle: const TextStyle(),
                            // indicatorColor: Constants.second,
                            tabs: const [
                              Tab(
                                text: 'Fiche Etudiant',
                              ),
                              Tab(
                                text: 'Emploi du temps',
                              ),
                              Tab(
                                text: 'Abscences',
                              ),
                              Tab(
                                text: 'Notes',
                              ),
                              Tab(
                                text: 'Factures',
                              ),
                              Tab(
                                text: 'Documents',
                              ),
                            ],
                            controller: tabBarController,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabBarController,
                            children: [
                              PdfPreview(
                                maxPageWidth: 700, 
                                build: (format) => ficheEtudiant.builder(format, widget.etudiantModel),
                                actions: <PdfPreviewAction>[
                                  if (!kIsWeb)
                                    PdfPreviewAction(
                                      icon: const Icon(Icons.save),
                                      onPressed: saveDoc,
                                    )
                                ],
                              ),
                              CalandarWidget(
                                evens: events,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height: 60 + 4 * 45,
                                    child: DataTable2(
                                      columns: const [
                                        DataColumn(
                                            label: Text('Date')),
                                        DataColumn(label: Text('Cours')),
                                        DataColumn(label: Text('Heures')),
                                        DataColumn(
                                            label: Text('Justifié')),
                                      ],
                                      rows: eventsAbscent
                                          .map(
                                            (cour) => DataRow(
                                              cells: [
                                                DataCell(Text(cour.heureDebut
                                                    .toString()
                                                    .split(' ')[0])),
                                                DataCell(
                                                    Text(cour.description)),
                                                DataCell(Text(cour.nbHeures.toString())),
                                                const DataCell(Text("Non")),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    height: 60 + 4 * 45,
                                    child: DataTable2(
                                      columns: const [
                                        DataColumn(
                                            label: Text('Date')),
                                        DataColumn(label: Text('Numéro')),
                                        DataColumn(label: Text('Débit')),
                                        DataColumn(
                                            label: Text('Etat')),
                                      ],
                                      rows: factures
                                          .map(
                                            (f) => DataRow(
                                              cells: [
                                                DataCell(Text(f.date
                                                    .toString()
                                                    .split(' ')[0])),
                                                DataCell(
                                                    Text(f.numero)),
                                                DataCell(Text(f.montant.toString())),
                                                DataCell(StatutWidget(
                                                  statut: f.isValidate ? "Validée" : "Non Validée",
                                                  color: f.isValidate ? Colors.green : Colors.red,
                                                ),),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getDataSource() {
    _getEvents();
    _getFactures();
  }

  Future<void> _getEvents() async {
    events = [];
    eventsAbscent = [];
    List<CoursModel> cours = [];

    try {
      final querySnapshot1 =
          await FirebaseFirestore.instance.collection('classes').where("nom", isEqualTo: widget.etudiantModel.classe).get();
          assert(querySnapshot1.docs.isNotEmpty);
      ClasseModel classe = ClasseModel.fromMap(querySnapshot1.docs.first.data());
      
      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('cours').where("id", whereIn: classe.idCours).get();
      for (var f in querySnapshot2.docs) {
        cours.add(CoursModel.fromMap(f.data()));
        for (var p in CoursModel.fromMap(f.data()).programmations) {
          if (p.profAbscent) {
            eventsAbscent.add(
              Evenement(
                description: CoursModel.fromMap(f.data()).nom,
                heureDebut: p.heureDebut,
                heureFin: p.heureFin,
                idEvent: p.idEvent,
                idCours: p.idCours,
                salle: p.salle,
                dejaFait: p.dejaFait,
                classe: p.classe,
                absences: p.absences,
                background: p.background,
                profAbscent: p.profAbscent,
              ),
            );
          }
        }
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
              background: p.background,
              profAbscent: p.profAbscent,
            ),
          );
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }


  Future<void> _getFactures() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('factures').
        where(
          'idStudent',
          isEqualTo: widget.etudiantModel.idStudent,
        ).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var f in querySnapshot.docs) {
          factures.add(FactureModel.fromMap(f.data()));
        }
      }
      setState(() {});
    } catch (e) {
      print('Erreur: $e');
    }
  }


  Future<void> saveDoc(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/IDEX/fiches/Fiche ${widget.etudiantModel.classe} - ${widget.etudiantModel.prenom} ${widget.etudiantModel.nom}.pdf');
    await file.writeAsBytes(bytes);
    showSnackBar(context, "Fiche enregistrer sur ${file.path}");
  }
}




class StudentPdfView extends StatelessWidget {
  final EtudiantModel etudiantModel;
  StudentPdfView({super.key, required this.etudiantModel});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          Expanded(
            child: StudentPdfViewHome(etudiantModel: etudiantModel),
          ),
        ],
      ),
    );
  }
}


class StudentPdfViewHome extends StatefulWidget {
  final EtudiantModel etudiantModel;
  const StudentPdfViewHome({super.key, required this.etudiantModel});

  @override
  State<StudentPdfViewHome> createState() => _StudentPdfViewHomeState();
}

class _StudentPdfViewHomeState extends State<StudentPdfViewHome> {
  final ficheEtudiant = const GenerateDocument(generateDocument);

  Future<void> _saveInvoice(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/IDEX/fiches/Fiche ${widget.etudiantModel.classe} - ${widget.etudiantModel.prenom} ${widget.etudiantModel.nom}.pdf');
    await file.writeAsBytes(bytes);
    showSnackBar(context, "Fiche enregistrer sur ${file.path}");
    // await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiche ${widget.etudiantModel.prenom} ${widget.etudiantModel.nom}", style: const TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Expanded(
        child: PdfPreview(
          maxPageWidth: 700,
          build: (format) => ficheEtudiant.builder(format, widget.etudiantModel),
          actions: [
            PdfPreviewAction(
              icon: const Icon(Icons.save),
              onPressed: _saveInvoice,
            )
          ],
        )
      ),
    );
  }
}