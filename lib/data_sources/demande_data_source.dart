import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/demande_inscription_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/screens/DG/pages/demande_view.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';



class DemandeDataSource extends DataTableSource {
  DemandeDataSource.empty(this.context) {
    demandes = [];
  }

  DemandeDataSource(
    this.context,
    this.demandes,
    [sortedByAbscence = false,
    this.hasRowTaps = false,
    this.hasRowHeightOverrides = false,
    this.hasZebraStripes = false]) {}

  final BuildContext context;
  late List<DemandeInscription> demandes;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(DemandeInscription d) getField, bool ascending) {
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
        DataCell(Text(demande.date.toString().split(' ')[0])),
        DataCell(Text(demande.numeroDemande.toString().padLeft(6, '0'))),
        DataCell(Text(demande.nom)),
        DataCell(Text(demande.formation)),
        // DataCell(student.actions),
        DataCell(
          StatutWidget(
            statut: demande.statut, 
            color: statutsDemande[demande.statut] ?? Colors.cyan,
          ),
        ),
        DataCell(ActionsDemande(demandeInscription: demande, home: DGScreen(),),)
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




class ActionsDemande extends ConsumerStatefulWidget {
  Widget home;
  DemandeInscription demandeInscription;
  ActionsDemande({
    super.key,
    required this.home,
    required this.demandeInscription,
  });

  @override
  ConsumerState<ActionsDemande> createState() => _ActionsDemandeState();
}

class _ActionsDemandeState extends ConsumerState<ActionsDemande> {

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
                builder: (context) => DemandeView(
                  demandeInscription: widget.demandeInscription,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.yellow,
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
