import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/cours_model.dart';
import 'package:frontend/screens/DE/de_screen.dart';
import 'package:frontend/screens/DE/pages/suivi_cour.dart';
import 'package:frontend/utils/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CoursDataSource extends DataTableSource {
  CoursDataSource.empty(this.context) {
    cours = [];
  }

  CoursDataSource(this.context, this.cours,
      [sortedByAbscence = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]) {}

  final BuildContext context;
  late List<CoursModel> cours;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(CoursModel d) getField, bool ascending) {
    cours.sort((a, b) {
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
    if (index >= cours.length) throw 'index > _cours.length';
    double progression = 0;
    final cour = cours[index];
    final dejaFait = cour.programmations.where((p)=>p.dejaFait);
    if (dejaFait.isNotEmpty) {
      progression = dejaFait.map((p)=>p.heureFin.difference(p.heureDebut).inHours)
      .reduce((a, b)=>a+b) / cour.nbHeures;
    }
    return DataRow2.byIndex(
      index: index,
      selected: cour.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (cour.selected != value) {
          selectedCount += value! ? 1 : -1;
          assert(selectedCount >= 0);
          cour.selected = value;
          notifyListeners();
        }
      },
      // specificRowHeight:
      //     hasRowHeightOverrides && student.abscences >= 25 ? 100 : null,
      cells: [
        DataCell(Text(cour.nom)),
        DataCell(Text(cour.classe)),
        DataCell(Text(cour.nomProf)),
        // DataCell(Text("${cour.nbHeuresDejaFait}H / ${cour.nbHeures}")),
        DataCell(Text(cour.nbEtudiants.toString())),
        DataCell(
          LinearPercentIndicator(
            width: 100,
            animation: true,
            lineHeight: 15.0,
            animationDuration: 2000,
            percent: progression,
            center: Text(
              "${progression * 100}%",
              style: TextStyle(fontSize: 13),
            ),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.greenAccent,
          ),
        ),
        DataCell(
          ActionsCours(
            coursModel: cour,
            home: DirecteurEtudesScreen(),
          ),
        )
      ],
    );
  }

  @override
  int get rowCount => cours.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool? checked) {
    for (final student in cours) {
      student.selected = checked ?? false;
    }
    selectedCount = (checked ?? false) ? cours.length : 0;
    notifyListeners();
  }
}

class ActionsCours extends ConsumerStatefulWidget {
  Widget home;
  CoursModel coursModel;
  ActionsCours({
    super.key,
    required this.home,
    required this.coursModel,
  });

  @override
  ConsumerState<ActionsCours> createState() => _ActionsCoursState();
}

class _ActionsCoursState extends ConsumerState<ActionsCours> {
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
                builder: (context) => SuiviCour(
                  coursModel: widget.coursModel,
                  home: widget.home,
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
