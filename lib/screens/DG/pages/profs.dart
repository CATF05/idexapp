import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data_sources/profs_data_source.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/nav_helper.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/sort_icon.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class ProfsScreen extends StatelessWidget {
  Widget home;
  ProfsScreen({super.key, required this.home});

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
            child: ProfsHome(),
          ),
        ],
      ),
    );
  }
}

class ProfsHome extends ConsumerStatefulWidget {
  const ProfsHome({super.key});

  @override
  ConsumerState<ProfsHome> createState() => _ProfsHomeState();
}

class _ProfsHomeState extends ConsumerState<ProfsHome> {
  TextEditingController searchController = TextEditingController();
  bool _sortAscending = true;
  int? _sortColumnIndex;
  late ProfsDataSource _profsDataSource;
  bool _initialized = false;
  bool showCustomArrow = false;
  bool sortArrowsAlwaysVisible = false;
  List<ProfModel> initialProfs = [];
  List<ProfModel> profs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('profs').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var f in querySnapshot.docs) {
          profs.add(ProfModel.fromMap(f.data()));
          initialProfs.add(ProfModel.fromMap(f.data()));
        }
      }
      setState(() {});
    } catch (e) {
      debugPrint('Erreur: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final currentRouteOption = getCurrentRouteOption(context);
      _profsDataSource = ProfsDataSource(
          context,
          profs,
          // widget.home,
          false,
          currentRouteOption == rowTaps,
          currentRouteOption == rowHeightOverrides,
          currentRouteOption == showBordersWithZebraStripes);
      _initialized = true;
      _profsDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  void _sort<T>(
    Comparable<T> Function(ProfModel d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _profsDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _profsDataSource.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const alwaysShowArrows = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Profs',
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
                  onPressed: ajouterProf,
                  style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        side: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Ajouter un Prof",
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
                      //   _profsDataSource = StudentDataSource(
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
                      setState(() => _profsDataSource.selectAll(val)),
                  columns: [
                    DataColumn2(
                      label: const Text('Identifiant'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.idProf, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Nom'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) =>
                          _sort<String>((d) => d.nom, columnIndex, ascending),
                    ),
                    DataColumn2(
                      label: const Text('Nombres de Cours'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.cours.length.toString(),
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
                      : List<DataRow>.generate(_profsDataSource.rowCount,
                          (index) => _profsDataSource.getRow(index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ajouterProf() async {
    final formKey = GlobalKey<FormState>();
    TextEditingController nomController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController telephoneController = TextEditingController();
    TextEditingController nationaliteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Cours"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: nomController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Nom Complet',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: telephoneController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nationaliteController,
                  validator: validationNotNull,
                  decoration: const InputDecoration(
                    labelText: 'Nationalité',
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
                if (formKey.currentState?.validate() ?? false) {
                  ProfModel profModel = ProfModel(
                    idProf: generateIdStudent("P0", 3),
                    nom: nomController.text,
                    email: emailController.text,
                    telephone: int.parse(telephoneController.text),
                    nationalite: nationaliteController.text,
                    urlPhoto: '',
                    cours: [],
                  );
                  setState(() {
                    profs.add(profModel);
                  });

                  Navigator.of(context).pop();

                  await ref
                      .watch(profsControllerProvider.notifier)
                      .addProf(profModel, context);
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
