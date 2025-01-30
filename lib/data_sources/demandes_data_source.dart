import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/demande_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/secretaire/secretaire.dart';
import 'package:frontend/utils/constants.dart';

class DemandesDataSource extends DataTableSource {
  DemandesDataSource.empty(this.context) {
    demandes = [];
  }

  DemandesDataSource(this.context, this.demandes,
      [sortedByAbscence = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {}

  final BuildContext context;
  late List<DemandeModel> demandes;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(DemandeModel d) getField, bool ascending) {
    demandes.sort((a, b) {
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
    if (index >= demandes.length) throw 'index > _demandes.length';
    final demande = demandes[index];
    return DataRow2.byIndex(
      index: index,
      selected: demande.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (demande.selected != value) {
          selectedCount += value! ? 1 : -1;
          assert(selectedCount >= 0);
          demande.selected = value;
          notifyListeners();
        }
      },
      // specificRowHeight:
      //     hasRowHeightOverrides && student.abscences >= 25 ? 100 : null,
      cells: [
        DataCell(Text(demande.idDemande)),
        DataCell(Text(demande.date.toString().split(' ')[0])),
        DataCell(Text(demande.demandeur)),
        DataCell(Text(demande.objet)),
        DataCell(StatutWidget(
          color: demande.repondu ? Colors.green : Colors.red,
          statut: demande.repondu ? "Répondu" : "Non Répondu",
        )),
        DataCell(
          ActionsDemandes(
            demandeModel: demande,
            home: SecretaryScreen(),
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => demandes.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool? checked) {
    for (final student in demandes) {
      student.selected = checked ?? false;
    }
    selectedCount = (checked ?? false) ? demandes.length : 0;
    notifyListeners();
  }
}

class ActionsDemandes extends ConsumerStatefulWidget {
  Widget home;
  DemandeModel demandeModel;
  ActionsDemandes({
    super.key,
    required this.home,
    required this.demandeModel,
  });

  @override
  ConsumerState<ActionsDemandes> createState() => _ActionsDemandesState();
}

class _ActionsDemandesState extends ConsumerState<ActionsDemandes> {
  bool isDg = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final currentUser =  FirebaseAuth.instance.currentUser;
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DemandeView(
            //       demandeModel: widget.demandeModel,
            //       home: widget.home,
            //     ),
            //   ),
            // );
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
        GestureDetector(
          onTap: () {
            // showSnackBar(context, "Suppimer l'étudiant");
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
