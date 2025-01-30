import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/common_pages/facture_view.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';


class FactureDataSource extends DataTableSource {
  FactureDataSource.empty(this.context) {
    factures = [];
    home = DGScreen();
  }

  FactureDataSource(this.home, this.context, this.factures,
      [sortedByAbscence = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {
    // students = _students;
    // if (sortedByAbscence) {
    //   sort((d) => d.abscences, true);
    // }
  }

  final BuildContext context;
  late Widget home;
  late List<FactureModel> factures;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(FactureModel d) getField, bool ascending) {
    factures.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= factures.length) throw 'index > _factures.length';
    final facture = factures[index];
    return DataRow2.byIndex(
      index: index,
      selected: facture.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (facture.selected != value) {
          selectedCount += value! ? 1 : -1;
          assert(selectedCount >= 0);
          facture.selected = value;
          notifyListeners();
        }
      },
      // specificRowHeight:
      //     hasRowHeightOverrides && student.abscences >= 25 ? 100 : null,
      cells: [
        DataCell(Text(facture.date.toString().split(' ')[0])),
        DataCell(Text(facture.numero)),
        DataCell(Text(facture.client)),
        DataCell(Text('${facture.montant.ceil()} Fcfa')),
        // DataCell(student.actions),
        DataCell(
          StatutWidget(
            statut: facture.isValidate ? "Validée" : "Non Validée",
            color: facture.isValidate ? Colors.green : Colors.red,
          ),
        ),
        DataCell(ActionsFacture(
          factureModel: facture,
          home: home,
        ))
      ],
    );
  }

  @override
  int get rowCount => factures.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool? checked) {
    for (final student in factures) {
      student.selected = checked ?? false;
    }
    selectedCount = (checked ?? false) ? factures.length : 0;
    notifyListeners();
  }
}



class ActionsFacture extends ConsumerStatefulWidget {
  Widget home;
  FactureModel factureModel;
  ActionsFacture({
    super.key,
    required this.home,
    required this.factureModel,
  });

  @override
  ConsumerState<ActionsFacture> createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends ConsumerState<ActionsFacture> {
  bool isDg = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('admins')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      isDg =
          UserModel.fromMap(querySnapshot.data()!).role == 'Directeur Général';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FacturePdfView(
                  factureModel: widget.factureModel,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.amber,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: const SizedBox(
              width: 22,
              height: 22,
              child: Center(
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FactureView(
                  factureModel: widget.factureModel,
                  home: widget.home,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.cyan,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: const SizedBox(
              width: 22,
              height: 22,
              child: Center(
                child: Icon(
                  Icons.edit_document,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        if (isDg)
          GestureDetector(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Validation'),
                  content: Text(
                      'Vous confirmer que la Facture n° ${widget.factureModel.numero} est conforme et signée ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Non'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          widget.factureModel.isValidate = true;
                        });
                        await ref
                            .watch(factureControllerProvider.notifier)
                            .addFacture(widget.factureModel, context, true);
                        setState(() {});
                      },
                      child: const Text(
                        'Oui',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
              // _showSnackbar(context, "Télécharger le dossier de l'étudiant");
            },
            child: Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              child: const SizedBox(
                width: 22,
                height: 22,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            showSnackBar(context, "Suppimer l'étudiant");
          },
          child: Card(
            color: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: const SizedBox(
              width: 22,
              height: 22,
              child: Center(
                child: Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ),
        // // IconButton(onPressed: (){}, icon: Icon(Icons.)),
      ],
    );
  }
}
