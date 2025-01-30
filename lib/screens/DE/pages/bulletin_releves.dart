import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';

class BulletinPage extends StatefulWidget {
  @override
  _BulletinPageState createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {
  String nom = "";
  String prenom = "";
  String lieuNaissance = "";
  String filiere = "";
  String semestre = "";
  File? _image;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> notes = [
    {
      "UE": "Mathématiques",
      "MCC": 15,
      "Examen": 16,
      "Moyenne": 0.0,
      "Coef": 1,
      "Credit": 3,
      "Appréciation": "",
    },
  ];

  void _addRow() {
    setState(() {
      notes.add({
        "UE": "",
        "MCC": 0,
        "Examen": 0,
        "Moyenne": 0.0,
        "Coef": 0,
        "Credit": 0,
        "Appréciation": "",
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _calculateResults() {
    for (var note in notes) {
      double moyenne = (note['MCC'] * 0.4 + note['Examen'] * 0.6);
      note['Moyenne'] = moyenne.toStringAsFixed(2);
      note['Appréciation'] = moyenne >= 10
          ? "Admis"
          : moyenne >= 8
              ? "Rattrapage"
              : "Ajourné";
    }
    setState(() {});
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "Bulletin de Notes",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Nom : $nom"),
            pw.Text("Prénom : $prenom"),
            pw.Text("Lieu de Naissance : $lieuNaissance"),
            pw.Text("Filière : $filiere"),
            pw.Text("Semestre : $semestre"),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ["UE", "MCC", "Examen", "Moyenne", "Coef", "Credit", "Appréciation"],
              data: notes.map((note) {
                return [
                  note["UE"],
                  note["MCC"],
                  note["Examen"],
                  note["Moyenne"],
                  note["Coef"],
                  note["Credit"],
                  note["Appréciation"],
                ];
              }).toList(),
            ),
          ],
        );
      },
    ));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bulletin de Notes",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.calculate),
            onPressed: _calculateResults,
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo de l'école
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.black)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),

            // Informations de l'étudiant
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Nom", (value) => nom = value),
                  _buildTextField("Prénom", (value) => prenom = value),
                  _buildTextField("Lieu de Naissance", (value) => lieuNaissance = value),
                  _buildTextField("Filière", (value) => filiere = value),
                  _buildTextField("Semestre", (value) => semestre = value),
                ],
              ),
            ),

            // Tableau des notes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tableau des Notes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.deepPurple),
                    onPressed: _addRow,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        _buildNoteField("UE", note["UE"], (value) => note["UE"] = value),
                        _buildNoteField("MCC", note["MCC"].toString(), (value) => note["MCC"] = int.tryParse(value) ?? 0),
                        _buildNoteField("Examen", note["Examen"].toString(), (value) => note["Examen"] = int.tryParse(value) ?? 0),
                        _buildNoteField("Coef", note["Coef"].toString(), (value) => note["Coef"] = int.tryParse(value) ?? 0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNoteField(String label, String value, Function(String) onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
