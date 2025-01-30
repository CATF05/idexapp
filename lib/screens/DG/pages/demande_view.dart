import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/demande_inscription_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class DemandeView extends StatelessWidget {
  final DemandeInscription demandeInscription;
  DemandeView({super.key, required this.demandeInscription});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: DGScreen(),
          ),
          Expanded(
            child: DemandeViewHome(demandeInscription: demandeInscription),
          ),
        ],
      ),
    );
  }
}

class DemandeViewHome extends ConsumerStatefulWidget {
  final DemandeInscription demandeInscription;
  const DemandeViewHome({super.key, required this.demandeInscription});

  @override
  ConsumerState<DemandeViewHome> createState() => _DemandeViewHomeState();
}

class _DemandeViewHomeState extends ConsumerState<DemandeViewHome> {
  late DemandeInscription demandeInscription;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    demandeInscription = widget.demandeInscription;
    // try {
    //   final querySnapshot = await FirebaseFirestore.instance.collection('students').doc(DemandeModel.idStudent).get();
    //   setState(() {
    //     etudiantModel = EtudiantModel.fromMap(querySnapshot.data()!);
    //     designationList = etudiantModel!.echeances.where((e)=>e.montantAPayer>e.montantDejaPayer).map((e)=>e.description).toList();
    //   });
    // } catch (e) {
    //   // etudiantModel = EtudiantModel(idStudent: "", prenom: "", nom: "", sexe: "", dateDeNaissance: "", adresse: "", nationalite: "", situationMatrimonial: "", email: "", telephone: "", nomTuteur: "", emailTuteur: "", telephoneTuteur: "", classe: "", scolariteAnnuel: 0, fraisEtudiant: 0, urlPhoto: "", echeances: []);
    //   print('Erreur: $e');
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demande de d'inscription",
            style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                            'Numéro de la demande',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${demandeInscription.numeroDemande}'
                                .padLeft(6, '0'),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Formation',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            demandeInscription.formation,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Statut',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            demandeInscription.statut,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Card(
                      color: Colors.white,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                          bottom: Radius.circular(4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 75,
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
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Information personnels :',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            demandeInscription.statut = "Accéptée";
                                          });
                                          await FirebaseFirestore.instance.collection("demandes")
                                          .doc(demandeInscription.idDemande).set(demandeInscription.toMap());
                                          showSnackBar(context, "Demande Accéptée");
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.green,
                                          ),
                                        ),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.done_outline_rounded,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Retenir",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            demandeInscription.statut = "Rejetée";
                                          });
                                          await FirebaseFirestore.instance.collection("demandes")
                                          .doc(demandeInscription.idDemande).set(demandeInscription.toMap());
                                          showSnackBar(context, "Demande Rejetée");
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            Colors.red,
                                          ),
                                        ),
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close_outlined,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Rejeter",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Nom :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            demandeInscription.nom,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Date de naissance :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${demandeInscription.dateDeNaissance}'
                                                .split(' ')[0],
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Sexe :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            demandeInscription.sexe,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Ville de résidence :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "${demandeInscription.ville}, ${demandeInscription.pays}",
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
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
                                              demandeInscription.nationalite),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
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
                                            demandeInscription.email,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
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
                                            demandeInscription.telephone
                                                .toString(),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Série Bac :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            demandeInscription.serieBac,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: <Widget>[
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Nom du tuteur :",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            demandeInscription.tuteur,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: <Widget>[
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Téléphone du tuteur :",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              demandeInscription.numeroTuteur
                                                  .toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Email du tuteur :",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
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
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Documents Fournis :',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: 200,
                              child: Row(
                                children: [
                                  DocWidget(
                                    url: demandeInscription.cniPassport,
                                    label: "CNI ou Passeport",
                                  ),
                                  const SizedBox(width: 10),
                                  DocWidget(
                                    url: demandeInscription.attestationDiplome,
                                    label: "Attestation ou Diplôme",
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocWidget extends StatelessWidget {
  final String url;
  final String label;
  const DocWidget({super.key, required this.url, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 10, 16),
      child: Container(
        width: 260,
        // height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0x4D9489F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 10, 57, 13),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Color(0xFF15161E),
                  fontSize: 14,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class DemandePdfView extends StatelessWidget {
//   final DemandeModel DemandeModel;
//   DemandePdfView({super.key, required this.DemandeModel});

//   final _controller = SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // extendBodyBehindAppBar: true,
//       body: Row(
//         children: [
//           ExampleSidebarX(controller: _controller, home: DGScreen(),),
//           Expanded(
//             child: DemandePdfViewHome(DemandeModel: DemandeModel),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class DemandePdfViewHome extends StatefulWidget {
//   final DemandeModel DemandeModel;
//   const DemandePdfViewHome({super.key, required this.DemandeModel});

//   @override
//   State<DemandePdfViewHome> createState() => _DemandePdfViewHomeState();
// }

// class _DemandePdfViewHomeState extends State<DemandePdfViewHome> {
//   final DemandeEtudiant = const GenerateInvoice(generateInvoice);

//   Future<void> _saveInvoice(
//     BuildContext context,
//     LayoutCallback build,
//     PdfPageFormat pageFormat,
//   ) async {
//     final bytes = await build(pageFormat);

//     final appDocDir = await getApplicationDocumentsDirectory();
//     final appDocPath = appDocDir.path;
//     final file = File('$appDocPath/IDEX/Demandes/Demande ${widget.DemandeModel.objet} - ${widget.DemandeModel.client} - ${widget.DemandeModel.numero}.pdf');
//     await file.writeAsBytes(bytes);
//     showSnackBar(context, "Demande enregistrer sur ${file.path}");
//     // await OpenFile.open(file.path);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Demande n° ${widget.DemandeModel.numero}", style: const TextStyle(color: Colors.white)),
//         backgroundColor: canvasColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Expanded(
//         child: PdfPreview(
//           maxPageWidth: 700,
//           build: (format) => DemandedemandeInscription.builder(format, widget.DemandeModel),
//           actions: [
//             PdfPreviewAction(
//               icon: const Icon(Icons.save),
//               onPressed: _saveInvoice,
//             )
//           ],
//         )
//       ),
//     );
//   }
// }