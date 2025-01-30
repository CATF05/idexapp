import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/common_pages/prof_view.dart';
import 'package:frontend/screens/DE/de_screen.dart';
import 'package:frontend/utils/constants.dart';



class ProfsDataSource extends DataTableSource {
  ProfsDataSource.empty(this.context) {
    profs = [];
  }

  ProfsDataSource(
    this.context,
    this.profs,
    [sortedByAbscence = false,
    this.hasRowTaps = false,
    this.hasRowHeightOverrides = false,
    this.hasZebraStripes = false]) {}

  final BuildContext context;
  late List<ProfModel> profs;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(ProfModel d) getField, bool ascending) {
    profs.sort((a, b) {
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
    if (index >= profs.length) throw 'index > _profs.length';
    final prof = profs[index];
    return DataRow2.byIndex(
      index: index,
      selected: prof.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (prof.selected != value) {
          selectedCount += value! ? 1 : -1;
          assert(selectedCount >= 0);
          prof.selected = value;
          notifyListeners();
        }
      },
      // specificRowHeight:
      //     hasRowHeightOverrides && student.abscences >= 25 ? 100 : null,
      cells: [
        DataCell(Text(prof.idProf)),
        DataCell(Text(prof.nom)),
        DataCell(Text(prof.cours.length.toString())),
        DataCell(ActionsProfs(profModel: prof, home: DirecteurEtudesScreen(),),)
      ],
    );
  }

  @override
  int get rowCount => profs.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool? checked) {
    for (final student in profs) {
      student.selected = checked ?? false;
    }
    selectedCount = (checked ?? false) ? profs.length : 0;
    notifyListeners();
  }
}


class ActionsProfs extends ConsumerStatefulWidget {
  Widget home;
  ProfModel profModel;
  ActionsProfs({
    super.key,
    required this.home,
    required this.profModel,
  });

  @override
  ConsumerState<ActionsProfs> createState() => _ActionsProfsState();
}

class _ActionsProfsState extends ConsumerState<ActionsProfs> {
  bool isDg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
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
                builder: (context) => ProfView(
                  profModel: widget.profModel,
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