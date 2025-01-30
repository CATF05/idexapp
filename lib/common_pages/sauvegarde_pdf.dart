import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sidebarx/sidebarx.dart';



String getCurrentDate() {
  DateTime now = DateTime.now();
  return "${now.day}/${now.month}/${now.year}";
}

class BuildFooterColumn extends StatelessWidget {
  final String label;
  const BuildFooterColumn({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: canvasColor)),
        const SizedBox(height: 40), // Espace pour la signature
        Container(
          height: 1,
          width: 100,
          color: canvasColor,
        ),
      ],
    );
  }
}

Future<Uint8List> generateDocument(PdfPageFormat format, EtudiantModel Etudiant) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/logo_idex.jpg')).buffer.asUint8List(),
  );

  doc.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
      ),
      pageFormat: format.copyWith(
        marginTop: 1.2 * PdfPageFormat.cm,
        marginBottom: 0.5 * PdfPageFormat.cm,
        marginLeft: 0.5 * PdfPageFormat.cm,
        marginRight: 0.5 * PdfPageFormat.cm,
      ),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      build: (pw.Context context) => <pw.Widget>[
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(
                  height: 72,
                  child: pw.Image(logo),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Institut D'excellence du Sénégal", 
                      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      "Institut des Métiers de l'avenir", 
                      style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      "Agrément N°:RepSen/Ensup-Priv/AP/2021-394",
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      "FICHE D'INSCRIPTION 2024 - 2025",
                      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      "Fait à Dakar le: ${getCurrentDate()}",
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                    ),
                  ]
                ),
              ]
            ),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Header(
                        level: 1,
                        title: 'Informations Personnelles',
                        child: pw.Text(
                          'INFORMATIONS PERSONNELLES', 
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)
                        )
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Prénom :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.prenom, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Nom :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.nom, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Date de naissance :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.dateDeNaissance, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Sexe :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.sexe, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Adresse :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.adresse, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Nationalité :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.nationalite, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Situation matrimoniale :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.situationMatrimonial, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Email :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.email, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Téléphone :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.telephone, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ]
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Header(
                        level: 1,
                        title: 'Informations sur le Tuteur',
                        child: pw.Text(
                          'INFORMATIONS SUR LE TUTEUR', 
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)
                        )
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Nom du tuteur :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.nomTuteur, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(
                              text: "Email :",
                              style: const pw.TextStyle(fontSize: 10)
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.emailTuteur, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Téléphone :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              Etudiant.telephoneTuteur, 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                    
                      pw.Header(
                        level: 1,
                        title: 'Scolarité',
                        child: pw.Text(
                          'SCOLARITE',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)
                        )
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Scolarité annuelle :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "${Etudiant.scolariteAnnuel} FCFA", 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais d'Etudiant :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              "${Etudiant.fraisEtudiant} FCFA", 
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, 
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais de Soutenance :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais de Stage :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais de Bibliothéque :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais d'Uniforme :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ]
                      ),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Expanded(
                            flex: 1,
                            child: pw.Bullet(text: "Frais d'Assurance :", style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ]
                      ),
                    ]
                  ),
                )
              ]
            ),

            pw.Header(
              level: 1,
              title: 'Paiements Effectués',
              child: pw.Text(
                'PAIEMENTS EFFECTUES', 
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)
            )
            ),
            pw.TableHelper.fromTextArray(
              context: context,
              data: [
                <String>['ECHEANCE', 'MONTANT À PAYE', 'MONTANT DEJA PAYE'],
                for(int i=0; i<Etudiant.echeances.length; i++)
                  [Etudiant.echeances[i].description, Etudiant.echeances[i].montantAPayer, Etudiant.echeances[i].montantDejaPayer]
              ],
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),

            pw.Text(
              "- L'Etudiant sera comptabilisée après règlement des frais et aucune somme ne sera remboursé, sauf si pour des raisons d'effectif,la session n'est pas ouverte.",
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 8),
          
            pw.Text(
              "- Tout Etudiant rend obligatoire le coût annuel de la formation, toute autre modalité de réglement, ne constitut que des facilités accordés aux apprenants qui demandent.",
              style: const pw.TextStyle(fontSize: 10),
              // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
        
            pw.Text(
              "- L'aprenant s'angage à fournir toutes les piéces requises pour son Etudiant ou à completer les piéces manquante, et atteste qu'elles sont toutes authentiques et légales, à defaut il engage sa responsabilité.",
              style: const pw.TextStyle(fontSize: 10),
              // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text("APPRENANT", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text("TUTEUR", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text("DIRECTEUR DES ETUDES", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.Text("LA CAISSE", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
              ],
            ),
      ],
    ),
  );

  return await doc.save();
}


Future<Uint8List> generateInvoice(PdfPageFormat format, FactureModel Facture) async {
  final pdf = pw.Document();

  final logo = await imageFromAssetBundle('assets/logo_idex.jpg');

  pdf.addPage(
    pw.Page(
      pageFormat: format.copyWith(
        marginTop: 1.4 * PdfPageFormat.cm,
        marginBottom: 1.4 * PdfPageFormat.cm,
        marginLeft: 1.4 * PdfPageFormat.cm,
        marginRight: 1.4 * PdfPageFormat.cm,
      ),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Logo et en-tête
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // width: 200, height: 100,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Image(logo, width: 200, height: 100)
                ),
                pw.Container(
                  width: 200, height: 60,
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.005)),
                  child: pw.Center(
                    child: pw.Text(
                      'FACTURE',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Informations Facture
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Institut d'Excellence du Sénégal - IDEX",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text("Liberté 6, Dakar, Sénégal"),
                    pw.SizedBox(height: 6),
                    pw.Text('Tél. +221 77 547 24 57'),
                    pw.SizedBox(height: 6),
                    pw.Text('idex.institut@gmail.com'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('N° de FACTURE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 6),
                        pw.Text(Facture.numero),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('DATE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 6),
                        pw.Text(Facture.date.toString().split(' ')[0]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Informations Client
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('CLIENT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6),
                    pw.Text(Facture.client),
                    pw.SizedBox(height: 6),
                    pw.Text('Dakar - Sénégal'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('OBJET', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 6),
                    pw.Text(Facture.objet),
                  ],
                ),
              ]
            ),
            pw.SizedBox(height: 30),

            // Tableau des Détails
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(4),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('DESIGNATION'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('QTE'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('PRIX UNITAIRE'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('MONTANT'),
                    ),
                  ],
                ),
                for(var dejaPayer in Facture.details)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("${dejaPayer.article} (XOF)"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("1"),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(dejaPayer.montant.toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(dejaPayer.montant.toString()),
                      ),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 25),

            // Résumé Montant
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('TOTAL À PAYER (XOF): ${Facture.montantAPayer.ceil()}'),
                    pw.Text('Déjà Payé (XOF): ${Facture.montant.ceil()}'),
                    pw.Text(
                      'Reste à Payer (XOF): ${(Facture.montantAPayer - Facture.montant).ceil()}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ]
            ),
            pw.SizedBox(height: 25),

            // Informations bancaires
            pw.Text(
              "Veuillez libeller votre chèque à l'ordre de Institut d'Excellence du Sénégal",
              // style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              'En cas de virement merci de mettre en libellé le numéro de la facture.\nPour toute question concernant cette facture, veuillez nous contacter au +221 77 547 24 57 - idex.institut@gmail.com.',
              // style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}





class ViewPdf extends StatelessWidget {
  final EtudiantModel etudiantModel;
  final FactureModel factureModel;
  ViewPdf({super.key, required this.etudiantModel, required this.factureModel});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          Expanded(
            child: ViewPdfHome(
              etudiantModel: etudiantModel,
              factureModel: factureModel
            ),
          ),
        ],
      ),
    );
  }
}

class ViewPdfHome extends ConsumerStatefulWidget {
  final EtudiantModel etudiantModel;
  final FactureModel factureModel;
  const ViewPdfHome({super.key, required this.etudiantModel, required this.factureModel});

  @override
  ConsumerState<ViewPdfHome> createState() => _ViewPdfHomeState();
}

class _ViewPdfHomeState extends ConsumerState<ViewPdfHome>  with SingleTickerProviderStateMixin {
  PrintingInfo? printingInfo;
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // String periode = "Journalier";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabBarController?.dispose();

    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveDoc(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/IDEX/fiches/document.pdf');
    await ref.watch(etudiantControllerProvider.notifier).addStudent(widget.etudiantModel, context);
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<void> _saveInvoice(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/IDEX/factures/facture.pdf');
    await ref.watch(factureControllerProvider.notifier).addFacture(widget.factureModel, context);
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actionsForDoc = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveDoc,
        )
    ];
    final actionsForInvoice = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveInvoice,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription d'Etudiant", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: canvasColor,
      ),
      body: Expanded(
        child: Column(
          children: [
            Align(
              alignment: const Alignment(0, 0),
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                    const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                unselectedLabelStyle: const TextStyle(),
                // indicatorColor: Constants.second,
                tabs: const [
                  Tab(
                    text: 'Fiche Etudiant',
                  ),
                  Tab(
                    text: 'Facture',
                  ),
                ],
                controller: tabBarController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabBarController,
                children: [
                  PdfPreview(
                    maxPageWidth: 700, 
                    build: (format) => ficheEtudiant.builder(format, widget.etudiantModel),
                    actions: actionsForDoc,
                    onPrinted: _showPrintedToast,
                    onShared: _showSharedToast,
                  ),
                  PdfPreview(
                    maxPageWidth: 700,
                    build: (format) => factureEtudiant.builder(format, widget.factureModel),
                    actions: actionsForInvoice,
                    onPrinted: _showPrintedToast,
                    onShared: _showSharedToast,
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



const ficheEtudiant = GenerateDocument(generateDocument);
const factureEtudiant = GenerateInvoice(generateInvoice);


typedef LayoutCallbackWithDataDoc = Future<Uint8List> Function(
    PdfPageFormat pageFormat, EtudiantModel Etudiant);

typedef LayoutCallbackWithDataInvoice = Future<Uint8List> Function(
    PdfPageFormat pageFormat, FactureModel Facture);



class GenerateDocument {
  const GenerateDocument(this.builder, [this.needsData = false]);

  final LayoutCallbackWithDataDoc builder;

  final bool needsData;
}



class GenerateInvoice {
  const GenerateInvoice(this.builder, [this.needsData = false]);

  final LayoutCallbackWithDataInvoice builder;

  final bool needsData;
}