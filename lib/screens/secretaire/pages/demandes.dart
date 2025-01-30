import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data_sources/demandes_data_source.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/demande_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/nav_helper.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/sort_icon.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class DemandesScreen extends StatelessWidget {
  Widget home;
  DemandesScreen({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: home,
          ),
          const Expanded(
            child: DemandesHome(),
          ),
        ],
      ),
    );
  }
}

class DemandesHome extends ConsumerStatefulWidget {
  const DemandesHome({super.key});

  @override
  ConsumerState<DemandesHome> createState() => _DemandesHomeState();
}

class _DemandesHomeState extends ConsumerState<DemandesHome> {
  TextEditingController searchController = TextEditingController();
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late DemandesDataSource _demandesDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;
  List<DemandeModel> initialDemandes = [];
  List<DemandeModel> demandes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('demandes_secretaire').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var f in querySnapshot.docs) {
          demandes.add(DemandeModel.fromMap(f.data()));
          initialDemandes.add(DemandeModel.fromMap(f.data()));
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
      _demandesDataSource = DemandesDataSource(
          context,
          demandes,
          // widget.home,
          false,
          currentRouteOption == rowTaps,
          currentRouteOption == rowHeightOverrides,
          currentRouteOption == showBordersWithZebraStripes);
      _initialized = true;
      _demandesDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(DemandeModel d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _demandesDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _demandesDataSource.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const alwaysShowArrows = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Demandes',
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
                  onPressed: ajouterDemande,
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
                        "Ajouter une Demande",
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
                      //   _demandesDataSource = StudentDataSource(
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
                      setState(() => _demandesDataSource.selectAll(val)),
                  columns: [
                    DataColumn2(
                      label: const Text('Identifiants'),
                      size: ColumnSize.S,
                      fixedWidth: 120,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.idDemande, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Date'),
                      size: ColumnSize.S,
                      fixedWidth: 150,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => '${d.date}'.split(' ')[0],
                          columnIndex,
                          ascending),
                    ),
                    const DataColumn2(
                      label: Text('Demandeur'),
                      size: ColumnSize.S,
                    ),
                    const DataColumn2(
                      label: Text('Objet'),
                      size: ColumnSize.S,
                    ),
                    const DataColumn2(
                      label: Text('Statut'),
                      fixedWidth: 120,
                      size: ColumnSize.S,
                    ),
                    const DataColumn2(
                      label: Text('Actions'),
                      size: ColumnSize.S,
                      fixedWidth: 150,
                    ),
                  ],
                  empty: Center(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: const Text('No data'))),
                  rows: getCurrentRouteOption(context) == noData
                      ? []
                      : List<DataRow>.generate(_demandesDataSource.rowCount,
                          (index) => _demandesDataSource.getRow(index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ajouterDemande() async {
    final _formKey = GlobalKey<FormState>();
    DateTime selectedDate = DateTime.now();
    TextEditingController demandeurController = TextEditingController();
    TextEditingController objetController = TextEditingController();
    TextEditingController contenuController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une Demande"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: demandeurController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Demandeur',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: selectedDate.toString().split(' ')[0],
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: objetController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Objet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contenuController,
                  validator: validationNotNull,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Contenu',
                    border: OutlineInputBorder(),
                  ),
                ),
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
                if (_formKey.currentState?.validate() ?? false) {
                  DemandeModel demandeModel = DemandeModel(
                    idDemande: generateIdStudent("D", 4),
                    demandeur: demandeurController.text,
                    objet: objetController.text,
                    contenu: contenuController.text,
                    date: selectedDate,
                    repondu: false,
                  );
                  setState(() {
                    demandes.add(demandeModel);
                  });

                  Navigator.of(context).pop();

                  await FirebaseFirestore.instance
                      .collection('demandes_secretaire')
                      .doc(demandeModel.idDemande)
                      .set(demandeModel.toMap());
                  // await ref
                  //     .watch(demandesControllerProvider.notifier)
                  //     .addDemande(demandeModel, context);
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
