// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/data_sources/facture_data_source.dart';
import 'package:frontend/models/classe_model.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/demande_inscription_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/common_pages/facture_view.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/nav_helper.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/sort_icon.dart';

// ignore: must_be_immutable
class FacturePage extends StatelessWidget {
  Widget home;
  FacturePage({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // drawer: ExampleSidebarX(controller: _controller),
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: home,),
          Expanded(
            child: FacturePageHome(home: home,),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FacturePageHome extends ConsumerStatefulWidget {
  Widget home;
  FacturePageHome({
    required this.home,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FacturePageHomeState();
}

class _FacturePageHomeState extends ConsumerState<FacturePageHome> {
  DateTime? _dateFrom =
      DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _dateTo =
      DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1)
          .add(const Duration(days: -1));
  // final _editFormKey = GlobalKey<FormBuilderState>();
  final _datesFormKey = GlobalKey<FormBuilderState>();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late FactureDataSource _facturesDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;
  List<FactureModel> initialFactures = [];
  List<FactureModel> factures = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('factures').
        where(
          'date',
          isGreaterThanOrEqualTo: _dateFrom!.millisecondsSinceEpoch,
          isLessThan: _dateTo!.millisecondsSinceEpoch,
        ).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var f in querySnapshot.docs) {
          factures.add(FactureModel.fromMap(f.data()));
          initialFactures.add(FactureModel.fromMap(f.data()));
        }
      }

      // final querySnapshot2 = await FirebaseFirestore.instance.collection('demandes').
      //   where(
      //     'statut',
      //     isEqualTo: "Accéptée"
      //   ).get();
      // for (var f in querySnapshot2.docs) {
      //   demandes.add(DemandeInscription.fromMap(f.data()));
      // }

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
      _facturesDataSource = FactureDataSource(
          widget.home,
          context,
          factures,
          false,
          currentRouteOption == rowTaps,
          currentRouteOption == rowHeightOverrides,
          currentRouteOption == showBordersWithZebraStripes);
      _initialized = true;
      _facturesDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(FactureModel d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _facturesDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    _facturesDataSource.dispose();
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    const alwaysShowArrows = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Factures', style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Text(
                    //   'Liste des Factures',
                    //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    // ),               
                    FormBuilder(
                      key: _datesFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 45,
                            child: FormBuilderDateTimePicker(
                              name: 'date_from',
                              inputType: InputType.date,
                              initialValue: _dateFrom,
                              decoration: const InputDecoration(
                                labelText: 'Du',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: canvasColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: canvasColor,
                                    width: 3,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: canvasColor,
                                ),
                                contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
                              ),
                              validator: FormBuilderValidators.required(),
                              onChanged: (DateTime? value) async {
                                setState(() {
                                  _dateFrom = value;
                                  fetchData();
                                  final currentRouteOption = getCurrentRouteOption(context);
                                  _facturesDataSource = FactureDataSource(
                                    widget.home,
                                    context,
                                    factures,
                                    false,
                                    currentRouteOption == rowTaps,
                                    currentRouteOption == rowHeightOverrides,
                                    currentRouteOption == showBordersWithZebraStripes,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          SizedBox(
                            width: 150,
                            height: 45,
                            child: FormBuilderDateTimePicker(
                              name: 'date_to',
                              inputType: InputType.date,
                              initialValue: _dateTo,
                              decoration: const InputDecoration(
                                labelText: 'Au',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: canvasColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: canvasColor,
                                    width: 3,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: canvasColor,
                                ),
                                contentPadding:
                                    EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
                              ),
                              validator: FormBuilderValidators.required(),
                              onChanged: (DateTime? value) async {
                                setState(() {
                                  _dateTo = value;
                                });
                                // factures = await FactureRepository().allByDates(
                                //     _dateFrom, _dateTo);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: showPicker,
                      style: const ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          side: BorderSide(width: 1)
                        ))
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Ajouter une Facture", 
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 440,
                      height: 50,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            factures = _filteredFactures(initialFactures);
                            final currentRouteOption = getCurrentRouteOption(context);
                            _facturesDataSource = FactureDataSource(
                              widget.home,
                              context,
                              factures,
                              false,
                              currentRouteOption == rowTaps,
                              currentRouteOption == rowHeightOverrides,
                              currentRouteOption == showBordersWithZebraStripes,
                            );
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Recherchez un numéro ou un client',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal
                          ),
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
              ],
            ),
            const SizedBox(height: 10),
            Theme(
              data: ThemeData(
                iconTheme: const IconThemeData(color: Colors.white),
                scrollbarTheme: ScrollbarThemeData(
                  thickness: WidgetStateProperty.all(5),
                )
              ),
              child: SizedBox(
                height: 450,
                child: DataTable2(
                  headingRowColor:
                      WidgetStateColor.resolveWith((states) => Colors.grey[850]!),
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
                      : (getCurrentRouteOption(context) == showBordersWithZebraStripes
                          ? TableBorder.all()
                          : null),
                  dividerThickness:
                      1, // this one will be ignored if [border] is set above
                  bottomMargin: 10,
                  minWidth: 900,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  sortArrowIcon: Icons.keyboard_arrow_up, // custom arrow
                  sortArrowAnimationDuration:
                      const Duration(milliseconds: 500), // custom animation duration
                  onSelectAll: (val) =>
                      setState(() => _facturesDataSource.selectAll(val)),
                  columns: [
                    DataColumn2(
                      label: const Text('Date'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.date.toString(), columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Numéro'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.numero, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Client'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.client, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Débit'),
                      size: ColumnSize.S,
                      fixedWidth: 200,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => '${d.montant.ceil()} Fcfa', columnIndex, ascending),
                    ),
                    const DataColumn2(
                      label: Text('Etat'),
                      size: ColumnSize.S,
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
                      : List<DataRow>.generate(_facturesDataSource.rowCount,
                          (index) => _facturesDataSource.getRow(index)),
                ),
              ))
          ],
        ),
      ),
    );
  }


  List<FactureModel> _filteredFactures(List<FactureModel> factures) {
    if (searchController.text.isEmpty) {
      return factures;
    }
    return factures.where((facture) {
      return facture.numero.toLowerCase().contains(searchController.text.toLowerCase()) ||
          facture.client.toLowerCase().contains(searchController.text.toLowerCase()) ||
          facture.date.toString().contains(searchController.text);
    }).toList();
  }

  List<DemandeInscription> _filteredDemandes(List<DemandeInscription> demandes, TextEditingController searchDemandeController) {
    if (searchDemandeController.text.isEmpty) {
      return demandes;
    }
    return demandes.where((demande) {
      return demande.nom.toLowerCase().contains(searchController.text.toLowerCase()) ||
          demande.formation.toString().contains(searchController.text.toLowerCase());
    }).toList();
  }

  void showPicker() async {
    DemandeInscription? _selectedDemande;
    String? selectedClasse;
    TextEditingController searchDemandeController = TextEditingController();
    List<DemandeInscription> demandes = [];
    List<DemandeInscription> initailDemandes = [];
    List<ClasseModel> classes = [];

    
    final querySnapshot1 = await FirebaseFirestore.instance.collection('cours').get();
    for (var f in querySnapshot1.docs) {
      classes.add(ClasseModel.fromMap(f.data()));
    }

    final querySnapshot2 = await FirebaseFirestore.instance.collection('demandes').
      where(
        'statut',
        isEqualTo: "Accéptée"
      ).get();
    for (var f in querySnapshot2.docs) {
      demandes.add(DemandeInscription.fromMap(f.data()));
      initailDemandes.add(DemandeInscription.fromMap(f.data()));
    }

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        validator: validationNotNull,
                        decoration: const InputDecoration(
                          labelText: 'Alasse',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedClasse,
                        items: classes
                            .map((c) => c.nom)
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClasse = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: searchDemandeController,
                        onChanged: (value) {
                          setState(() {
                            demandes = _filteredDemandes(initailDemandes, searchDemandeController);
                            print(demandes);
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Recherchez un nom',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: demandes.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(
                        Icons.school,
                        color: Colors.black,
                      ),
                      title: Text(
                        demandes[index].nom,
                        style:
                            const TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        _selectedDemande = demandes[index];
                        searchDemandeController.text = '${demandes[index].nom} (${demandes[index].formation})';
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ButtonWidget(
                        onTap: (){
                          Navigator.of(context).pop();
                        }, 
                        text: "Annuler",
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 100,
                      child: ButtonWidget(
                        onTap: _selectedDemande == null 
                          ? () {} 
                          : () async {
                              EtudiantModel etudiantModel = EtudiantModel(
                                idStudent: generateIdStudent("E0", 4),
                                prenom: _selectedDemande!.nom.split(' ').dropRight().join(" "), 
                                nom: _selectedDemande!.nom.split(' ').last, 
                                sexe: _selectedDemande!.sexe, 
                                dateDeNaissance: '${_selectedDemande!.dateDeNaissance}'.split(' ')[0], 
                                adresse: "${_selectedDemande!.ville}, ${_selectedDemande!.pays}", 
                                nationalite: _selectedDemande!.nationalite, 
                                situationMatrimonial: "", 
                                email: _selectedDemande!.email, 
                                telephone: _selectedDemande!.telephone.toString(), 
                                nomTuteur: _selectedDemande!.tuteur, 
                                emailTuteur: "", 
                                telephoneTuteur: _selectedDemande!.numeroTuteur.toString(),
                                classe: selectedClasse!,
                                // classe: "${_selectedDemande!.formation.replaceAll(" ", "_").toLowerCase()}_${DateTime.now().year}",
                                scolariteAnnuel: Constants.echeancier[_selectedDemande!.formation]!.map((e)=>e.montantAPayer).reduce((a, b)=>a+b),
                                fraisEtudiant: Constants.echeancier[_selectedDemande!.formation]![0].montantAPayer,
                                urlPhoto: "",
                                echeances: Constants.echeancier[_selectedDemande!.formation]!
                              );

                              FactureModel factureModel = FactureModel(
                                numero: generateNumInvoice(), 
                                client: "${etudiantModel.prenom} ${etudiantModel.nom}",
                                idStudent: etudiantModel.idStudent,
                                date: DateTime.now(), 
                                montant: 0, 
                                objet: "Formation ${_selectedDemande!.formation}",
                                montantAPayer: etudiantModel.scolariteAnnuel,
                                isValidate: false,
                                details: [],
                              );
                              
                              await ref.watch(etudiantControllerProvider.notifier).addStudent(etudiantModel, context);
                              await ref.watch(factureControllerProvider.notifier).addFacture(factureModel, context);

                              Navigator.of(context).pop();
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => FactureView(factureModel: factureModel, home: widget.home,)
                                ),
                              );
                            }, 
                        text: "Suivant",
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          );
        }
      );
  }

  // void _deleteFacture(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Supprimer la Facture"),
  //         content: const Text("Êtes-vous sûr de vouloir supprimer cette facture ?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Annuler'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 // factures.removeAt(index);
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}