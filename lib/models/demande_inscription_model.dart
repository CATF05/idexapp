// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DemandeInscription {
  String idDemande;
  int numeroDemande;
  DateTime date;
  String nom;
  DateTime dateDeNaissance;
  String email;
  int telephone;
  String sexe;
  String ville;
  String pays;
  String formation;
  String nationalite;
  String serieBac;
  String attestationDiplome;
  String cniPassport;
  String tuteur;
  int numeroTuteur;
  String statut;
  DemandeInscription({
    required this.idDemande,
    required this.numeroDemande,
    required this.date,
    required this.nom,
    required this.dateDeNaissance,
    required this.email,
    required this.telephone,
    required this.sexe,
    required this.ville,
    required this.pays,
    required this.formation,
    required this.nationalite,
    required this.serieBac,
    required this.attestationDiplome,
    required this.cniPassport,
    required this.tuteur,
    required this.numeroTuteur,
    required this.statut,
  });
  bool selected = false;

  DemandeInscription copyWith({
    String? idDemande,
    int? numeroDemande,
    DateTime? date,
    String? nom,
    DateTime? dateDeNaissance,
    String? email,
    int? telephone,
    String? sexe,
    String? ville,
    String? pays,
    String? formation,
    String? nationalite,
    String? serieBac,
    String? attestationDiplome,
    String? cniPassport,
    String? tuteur,
    int? numeroTuteur,
    String? statut,
  }) {
    return DemandeInscription(
      idDemande: idDemande ?? this.idDemande,
      numeroDemande: numeroDemande ?? this.numeroDemande,
      date: date ?? this.date,
      nom: nom ?? this.nom,
      dateDeNaissance: dateDeNaissance ?? this.dateDeNaissance,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      sexe: sexe ?? this.sexe,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      formation: formation ?? this.formation,
      nationalite: nationalite ?? this.nationalite,
      serieBac: serieBac ?? this.serieBac,
      attestationDiplome: attestationDiplome ?? this.attestationDiplome,
      cniPassport: cniPassport ?? this.cniPassport,
      tuteur: tuteur ?? this.tuteur,
      numeroTuteur: numeroTuteur ?? this.numeroTuteur,
      statut: statut ?? this.statut,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idDemande': idDemande,
      'numeroDemande': numeroDemande,
      'date': date.millisecondsSinceEpoch,
      'nom': nom,
      'dateDeNaissance': dateDeNaissance.millisecondsSinceEpoch,
      'email': email,
      'telephone': telephone,
      'sexe': sexe,
      'ville': ville,
      'pays': pays,
      'formation': formation,
      'nationalite': nationalite,
      'serieBac': serieBac,
      'attestationDiplome': attestationDiplome,
      'cniPassport': cniPassport,
      'tuteur': tuteur,
      'numeroTuteur': numeroTuteur,
      'statut': statut,
    };
  }

  factory DemandeInscription.fromMap(Map<String, dynamic> map) {
    return DemandeInscription(
      idDemande: map['idDemande'] as String,
      numeroDemande: map['numeroDemande'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      nom: map['nom'] as String,
      dateDeNaissance: DateTime.fromMillisecondsSinceEpoch(map['dateDeNaissance'] as int),
      email: map['email'] as String,
      telephone: map['telephone'] as int,
      sexe: map['sexe'] as String,
      ville: map['ville'] as String,
      pays: map['pays'] as String,
      formation: map['formation'] as String,
      nationalite: map['nationalite'] as String,
      serieBac: map['serieBac'] as String,
      attestationDiplome: map['attestationDiplome'] as String,
      cniPassport: map['cniPassport'] as String,
      tuteur: map['tuteur'] as String,
      numeroTuteur: map['numeroTuteur'] as int,
      statut: map['statut'] ?? "Demande",
    );
  }

  String toJson() => json.encode(toMap());

  factory DemandeInscription.fromJson(String source) => DemandeInscription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DemandeInscription(idDemande: $idDemande, numeroDemande: $numeroDemande, date: $date, nom: $nom, dateDeNaissance: $dateDeNaissance, email: $email, telephone: $telephone, sexe: $sexe, ville: $ville, pays: $pays, formation: $formation, nationalite: $nationalite, serieBac: $serieBac, attestationDiplome: $attestationDiplome, cniPassport: $cniPassport, tuteur: $tuteur, numeroTuteur: $numeroTuteur, statut: $statut)';
  }
}



// ---------------------------
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/firebase/sync_demande.dart';
// import 'package:frontend/models/demande_model.dart';
// import 'package:frontend/screens/DG/dg_screen.dart';
// import 'package:frontend/utils/constants.dart';
// import 'package:frontend/widgets/nav_helper.dart';
// import 'package:frontend/widgets/side_bar.dart';
// import 'package:frontend/widgets/sort_icon.dart';
// import 'package:sidebarx/sidebarx.dart';
// // import 'package:flutter/rendering.dart';

// class NotificationsDGScreen extends StatelessWidget {
//   NotificationsDGScreen({super.key});

//   final _controller = SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Row(
//         children: [
//           ExampleSidebarX(controller: _controller, home: DGScreen(),),
//           const Expanded(
//             child: NotificationsDGScreenHome(),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class NotificationsDGScreenHome extends StatefulWidget {
//   const NotificationsDGScreenHome({super.key});

//   @override
//   State<NotificationsDGScreenHome> createState() => _NotificationsDGScreenHomeState();
// }

// class _NotificationsDGScreenHomeState extends State<NotificationsDGScreenHome> {
//   DateTime? _dateFrom =
//       DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
//   DateTime? _dateTo =
//       DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1)
//           .add(const Duration(days: -1));
//   // final _editFormKey = GlobalKey<FormBuilderState>();
//   // final _datesFormKey = GlobalKey<FormBuilderState>();
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   bool _sortAscending = true;
//   int? _sortColumnIndex;
//   late DemandeDataSource _demandesDataSource;
//   bool _initialized = false;
//   bool showCustomArrow = false;
//   bool sortArrowsAlwaysVisible = false;
//   // List<FactureModel> initialFactures = [];
//   List<DemandeInscription> demandes = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance.collection('demandes').get();
//       if (querySnapshot.docs.isNotEmpty) {
//         for (var f in querySnapshot.docs) {
//           demandes.add(DemandeInscription.fromMap(f.data()));
//         }
//       }
//       setState(() {});
//     } catch (e) {
//       print('Erreur: $e');
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final currentRouteOption = getCurrentRouteOption(context);
//       _demandesDataSource = DemandeDataSource(
//           context,
//           demandes,
//           false,
//           currentRouteOption == rowTaps,
//           currentRouteOption == rowHeightOverrides,
//           currentRouteOption == showBordersWithZebraStripes);
//       _initialized = true;
//       _demandesDataSource.addListener(() {
//         setState(() {});
//       });
//     }
//   }

//   void _sort<T>(
//     Comparable<T> Function(DemandeInscription d) getField,
//     int columnIndex,
//     bool ascending,
//   ) {
//     _demandesDataSource.sort<T>(getField, ascending);
//     setState(() {
//       _sortColumnIndex = columnIndex;
//       _sortAscending = ascending;
//     });
//   }

//   @override
//   void dispose() {
//     _demandesDataSource.dispose();
//     searchController.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     const alwaysShowArrows = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Liste des Factures', style: TextStyle(color: Colors.white)),
//         backgroundColor: canvasColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: (){},
//                       style: const ButtonStyle(
//                         fixedSize: WidgetStatePropertyAll(Size(200, 45)),
//                         shape: WidgetStatePropertyAll(RoundedRectangleBorder(
//                           side: BorderSide(width: 1)
//                         ))
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(
//                             Icons.add,
//                             color: Colors.black,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             "Ajouter une Facture", 
//                             style: TextStyle(color: Colors.black),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width - 440,
//                       height: 50,
//                       child: TextFormField(
//                         controller: searchController,
//                         onChanged: (value) {
//                           setState(() {
//                             // demandes = _filteredFactures(initialFactures);
//                             final currentRouteOption = getCurrentRouteOption(context);
//                             _demandesDataSource = DemandeDataSource(
//                               context,
//                               demandes,
//                               false,
//                               currentRouteOption == rowTaps,
//                               currentRouteOption == rowHeightOverrides,
//                               currentRouteOption == showBordersWithZebraStripes,
//                             );
//                           });
//                         },
//                         decoration: const InputDecoration(
//                           hintText: 'Recherchez un nom',
//                           hintStyle: TextStyle(
//                             color: Colors.grey,
//                             fontWeight: FontWeight.normal
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.black,
//                               width: 1,
//                             ),
//                           ),
//                           suffixIcon: Icon(
//                             Icons.search,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Theme(
//               data: ThemeData(
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 scrollbarTheme: ScrollbarThemeData(
//                   thickness: WidgetStateProperty.all(5),
//                 )
//               ),
//               child: SizedBox(
//                 height: 450,
//                 child: DataTable2(
//                   headingRowColor:
//                       WidgetStateColor.resolveWith((states) => Colors.grey[850]!),
//                   headingTextStyle: const TextStyle(color: Colors.white),
//                   headingCheckboxTheme: const CheckboxThemeData(
//                       side: BorderSide(color: Colors.white, width: 2.0)),
//                   isHorizontalScrollBarVisible: true,
//                   isVerticalScrollBarVisible: true,
//                   columnSpacing: 12,
//                   horizontalMargin: 12,
//                   sortArrowBuilder: getCurrentRouteOption(context) == custArrows
//                       ? (ascending, sorted) => sorted || alwaysShowArrows
//                           ? Stack(
//                               children: [
//                                 Padding(
//                                     padding: const EdgeInsets.only(right: 0),
//                                     child: SortIcon(
//                                         ascending: true,
//                                         active: sorted && ascending)),
//                                 Padding(
//                                     padding: const EdgeInsets.only(left: 10),
//                                     child: SortIcon(
//                                         ascending: false,
//                                         active: sorted && !ascending)),
//                               ],
//                             )
//                           : null
//                       : null,
//                   border: getCurrentRouteOption(context) == fixedColumnWidth
//                       ? TableBorder(
//                           top: const BorderSide(color: Colors.black),
//                           bottom: BorderSide(color: Colors.grey[300]!),
//                           left: BorderSide(color: Colors.grey[300]!),
//                           right: BorderSide(color: Colors.grey[300]!),
//                           verticalInside: BorderSide(color: Colors.grey[300]!),
//                           horizontalInside:
//                               const BorderSide(color: Colors.grey, width: 1))
//                       : (getCurrentRouteOption(context) == showBordersWithZebraStripes
//                           ? TableBorder.all()
//                           : null),
//                   dividerThickness:
//                       1, // this one will be ignored if [border] is set above
//                   bottomMargin: 10,
//                   minWidth: 900,
//                   sortColumnIndex: _sortColumnIndex,
//                   sortAscending: _sortAscending,
//                   sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
//                   sortArrowAnimationDuration:
//                       const Duration(milliseconds: 500), // custom animation duration
//                   onSelectAll: (val) =>
//                       setState(() => _demandesDataSource.selectAll(val)),
//                   columns: [
//                     DataColumn2(
//                       label: const Text('Date'),
//                       size: ColumnSize.S,
//                       onSort: (columnIndex, ascending) =>
//                           _sort<String>((d) => d.date.toString(), columnIndex, ascending),
//                     ),
//                     DataColumn2(
//                       label: const Text('Numéro'),
//                       size: ColumnSize.S,
//                       onSort: (columnIndex, ascending) =>
//                           _sort<int>((d) => d.numeroDemande, columnIndex, ascending),
//                     ),
//                     DataColumn2(
//                       label: const Text('Prénom et nom'),
//                       size: ColumnSize.S,
//                       onSort: (columnIndex, ascending) =>
//                           _sort<String>((d) => d.nom, columnIndex, ascending),
//                     ),
//                     DataColumn2(
//                       label: const Text('Formation demandée'),
//                       size: ColumnSize.S,
//                       fixedWidth: 200,
//                       onSort: (columnIndex, ascending) =>
//                           _sort<String>((d) => d.formation, columnIndex, ascending),
//                     ),
//                     const DataColumn2(
//                       label: Text('Statut'),
//                       size: ColumnSize.S,
//                     ),
//                     const DataColumn2(
//                       label: Text('Actions'),
//                       size: ColumnSize.S,
//                     ),
//                   ],
//                   empty: Center(
//                       child: Container(
//                           padding: const EdgeInsets.all(20),
//                           color: Colors.grey[200],
//                           child: const Text('No data'))),
//                   rows: getCurrentRouteOption(context) == noData
//                       ? []
//                       : List<DataRow>.generate(_demandesDataSource.rowCount,
//                           (index) => _demandesDataSource.getRow(index)),
//                 ),
//               ))
//           ],
//         ),
//       ),
//     );
//   }
// }