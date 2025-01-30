import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/common_pages/sauvegarde_pdf.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class FactureView extends StatelessWidget {
  Widget home;
  final FactureModel factureModel;
  FactureView({super.key, required this.factureModel, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: home,),
          Expanded(
            child: FactureViewHome(factureModel: factureModel),
          ),
        ],
      ),
    );
  }
}


class FactureViewHome extends ConsumerStatefulWidget {
  final FactureModel factureModel;
  const FactureViewHome({super.key, required this.factureModel});

  @override
  ConsumerState<FactureViewHome> createState() => _FactureViewHomeState();
}

class _FactureViewHomeState extends ConsumerState<FactureViewHome> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod;
  String? selectedDesignation;
  DateTime selectedDate = DateTime.now();
  final TextEditingController amountController = TextEditingController();
  // final TextEditingController designationController = TextEditingController();
  late FactureModel factureModel;
  EtudiantModel? etudiantModel;
  List<String> designationList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    factureModel = widget.factureModel;
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('students').doc(factureModel.idStudent).get();
      setState(() {
        etudiantModel = EtudiantModel.fromMap(querySnapshot.data()!);
        designationList = etudiantModel!.echeances.where((e)=>e.montantAPayer>e.montantDejaPayer).map((e)=>e.description).toList();
      });
    } catch (e) {
      print('Erreur: $e'); 
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement', style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Facture N° ${factureModel.numero} du ${factureModel.date.toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Eleve: ${factureModel.client} (${factureModel.objet})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Card(
                      color: Colors.white,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                          bottom: Radius.circular(4),
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          Container(
                            height: 68,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Échéances de la facture :',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                  onPressed: () {},
                                  child: const Icon(Icons.download, color: Colors.green,),
                                )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                      
                          // DataTable
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Expanded(
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  height: 60 + 4*45,
                                  child: DataTable2(
                                    // minWidth: 500,
                                    // border: TableBorder.all(),
                                    columns: const [
                                      DataColumn(label: Text('Date de paiement')),
                                      DataColumn(label: Text('Désignation')),
                                      DataColumn(label: Text('Montant TTC')),
                                      DataColumn(label: Text('Moyen de paiement')),
                                    ],
                                    rows: factureModel.details
                                        .map(
                                          (paiement) => DataRow(
                                            cells: [
                                              DataCell(Text(paiement.date.toString().split(' ')[0])),
                                              DataCell(Text(paiement.article)),
                                              DataCell(Text(paiement.montant.toString())),
                                              DataCell(Text(paiement.moyenDePaiement)),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
              
                  const SizedBox(width: 20),
                  // Payment form
                  Expanded(
                    flex: 2,
                    child: Card(
                      color: Colors.white,
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                          bottom: Radius.circular(4),
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 68,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 1,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Ajouter un paiement :',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                      
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
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
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    validator: validationNotNull,
                                    decoration: const InputDecoration(
                                      labelText: 'Désignation',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedDesignation,
                                    items: designationList
                                        .map((method) => DropdownMenuItem(
                                              value: method,
                                              child: Text(method),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDesignation = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: amountController,
                                    validator: validateSomme,
                                    decoration: const InputDecoration(
                                      labelText: 'Montant',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    validator: validationNotNull,
                                    decoration: const InputDecoration(
                                      labelText: 'Moyen de paiement',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedPaymentMethod,
                                    items: ['Carte Bancaire', 'Espèces', 'Chèque']
                                        .map((method) => DropdownMenuItem(
                                              value: method,
                                              child: Text(method),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  
                              
                                  // Submit Button
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        Detail detail = Detail(
                                          article: selectedDesignation!, 
                                          date: selectedDate, 
                                          montant: int.parse(amountController.text), 
                                          moyenDePaiement: selectedPaymentMethod!,
                                        );

                                        setState(() {
                                          factureModel.details.add(detail);
                                          factureModel.montant += detail.montant;
                                          etudiantModel!.echeances.where((e) => e.description == selectedDesignation).first.montantDejaPayer+=detail.montant;
                                        });
                                        selectedDesignation = null;
                                        amountController.text = "";
                                        
                                        await ref.watch(factureControllerProvider.notifier).addFacture(factureModel, context, true);
                                        await ref.watch(etudiantControllerProvider.notifier).addStudent(etudiantModel!, context, true);
                                        showSnackBar(context, "Paiement effectué");
                                      }
                                    },
                                    child: const Text('Ajouter un paiement'),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class FacturePdfView extends StatelessWidget {
  final FactureModel factureModel;
  FacturePdfView({super.key, required this.factureModel});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          Expanded(
            child: FacturePdfViewHome(factureModel: factureModel),
          ),
        ],
      ),
    );
  }
}


class FacturePdfViewHome extends StatefulWidget {
  final FactureModel factureModel;
  const FacturePdfViewHome({super.key, required this.factureModel});

  @override
  State<FacturePdfViewHome> createState() => _FacturePdfViewHomeState();
}

class _FacturePdfViewHomeState extends State<FacturePdfViewHome> {
  final factureEtudiant = const GenerateInvoice(generateInvoice);

  Future<void> _saveInvoice(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/IDEX/factures/Facture ${widget.factureModel.objet} - ${widget.factureModel.client} - ${widget.factureModel.numero}.pdf');
    await file.writeAsBytes(bytes);
    showSnackBar(context, "Facture enregistrer sur ${file.path}");
    // await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facture n° ${widget.factureModel.numero}", style: const TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Expanded(
        child: PdfPreview(
          maxPageWidth: 700,
          build: (format) => factureEtudiant.builder(format, widget.factureModel),
          actions: [
            PdfPreviewAction(
              icon: const Icon(Icons.save),
              onPressed: _saveInvoice,
            )
          ],
        )
      ),
    );
  }
}