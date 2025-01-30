import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/common_pages/student_view.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';


class StudentDataSource extends DataTableSource {
  StudentDataSource.empty(this.context) {
    students = [];
    // home = DGScreen();
  }

  StudentDataSource(this.context, this.home, this.students,
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
  late List<EtudiantModel> students;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(
      Comparable<T> Function(EtudiantModel d) getField, bool ascending) {
    students.sort((a, b) {
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
    if (index >= students.length) throw 'index > _students.length';
    final student = students[index];
    return DataRow2.byIndex(
      index: index,
      selected: student.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
              ? WidgetStateProperty.all(Theme.of(context).highlightColor)
              : null),
      onSelectChanged: (value) {
        if (student.selected != value) {
          selectedCount += value! ? 1 : -1;
          assert(selectedCount >= 0);
          student.selected = value;
          notifyListeners();
        }
      },
      // specificRowHeight:
      //     hasRowHeightOverrides && student.abscences >= 25 ? 100 : null,
      cells: [
        DataCell(Text(student.idStudent)),
        DataCell(Text(student.prenom)),
        DataCell(Text(student.nom)),
        DataCell(Text(student.classe)),
        DataCell(
          StatutWidget(
            statut: student.enRegle ? "Payée" : "Impayée",
            color: student.enRegle ? Colors.green : Colors.red,
          ),
        ),
        DataCell(ActionsStudent(
          etudiantModel: student,
          home: home,
        ))
      ],
    );
  }

  @override
  int get rowCount => students.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void selectAll(bool? checked) {
    for (final student in students) {
      student.selected = checked ?? false;
    }
    selectedCount = (checked ?? false) ? students.length : 0;
    notifyListeners();
  }
}

class ActionsStudent extends ConsumerStatefulWidget {
  Widget home;
  EtudiantModel etudiantModel;
  ActionsStudent({
    super.key,
    required this.home,
    required this.etudiantModel,
  });

  @override
  ConsumerState<ActionsStudent> createState() => _ActionsStudentState();
}

class _ActionsStudentState extends ConsumerState<ActionsStudent> {
  // bool isDg = false;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchUserData();
  // }

  // void fetchUserData() async {
  //   final currentUser = await FirebaseAuth.instance.currentUser;
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('admins')
  //       .doc(currentUser!.uid)
  //       .get();
  //   setState(() {
  //     isDg =
  //         UserModel.fromMap(querySnapshot.data()!).role == 'Directeur Général';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => StudentPdfView(
        //           etudiantModel: widget.etudiantModel,
        //         ),
        //       ),
        //     );
        //   },
        //   child: Card(
        //     color: Colors.amber,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        //     child: const SizedBox(
        //       width: 22,
        //       height: 22,
        //       child: Center(
        //         child: Icon(
        //           Icons.remove_red_eye_outlined,
        //           color: Colors.white,
        //           size: 15,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentView(
                  etudiantModel: widget.etudiantModel,
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
