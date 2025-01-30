// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/controler.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/common_pages/sauvegarde_pdf.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/utils/utils.dart';

class InscriptionEtudiantScreen extends StatelessWidget {
  Widget home;
  InscriptionEtudiantScreen({super.key, required this.home,});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: home,),
          const Expanded(
            child: InscriptionEtudiantHome(),
          ),
        ],
      ),
    );
  }
}

class InscriptionEtudiantHome extends StatefulWidget {
  const InscriptionEtudiantHome({super.key});

  @override
  State<InscriptionEtudiantHome> createState() => _InscriptionEtudiantHomeState();
}

class _InscriptionEtudiantHomeState extends State<InscriptionEtudiantHome> {
  final _formKey = GlobalKey<FormState>();

  String? formationSelected;
  String? niveauSelected;
  final classes = ['Informatique', 'Reseaux et Telecom', 'Genie Civil', 'Genie Logiciels', 'Architecture'];

  File? etudiantPhoto;
  TextEditingController? textControllerPrenom;
  TextEditingController? textControllerNom;
  TextEditingController? textControllerDateNaissance;
  TextEditingController? textControllerLieuNaissance;
  int checkboxValueSexe = 10;
  TextEditingController? textControllerNationalite;
  int checkboxValueSituationMatrimonial = 10;
  TextEditingController? textControllerVille;
  TextEditingController? textControllerRegion;
  TextEditingController? textControllerPays;
  TextEditingController? textControllerTel;
  TextEditingController? textControllerEmail;

  TextEditingController? textControllerSocial;
  TextEditingController? textControllerTuteurPrenom;
  TextEditingController? textControllerTuteurNom;
  TextEditingController? textControllerEmailTuteur;
  TextEditingController? textControllerTelTuteur;
  TextEditingController? textControllerVilleEntreprise;
  TextEditingController? textControllerRegionEntreprise;
  TextEditingController? textControllerPaysEntreprise;

  var textControllerMontants = [];

  @override
  void initState() {
    super.initState();

    textControllerPrenom ??= TextEditingController();
    textControllerNom ??= TextEditingController();
    textControllerDateNaissance ??= TextEditingController();
    textControllerLieuNaissance ??= TextEditingController();
    textControllerNationalite ??= TextEditingController();
    textControllerVille ??= TextEditingController();
    textControllerRegion ??= TextEditingController();
    textControllerPays ??= TextEditingController();
    textControllerTel ??= TextEditingController();
    textControllerEmail ??= TextEditingController();

    textControllerSocial ??= TextEditingController();
    textControllerTuteurPrenom ??= TextEditingController();
    textControllerTuteurNom ??= TextEditingController();
    textControllerEmailTuteur ??= TextEditingController();
    textControllerTelTuteur ??= TextEditingController();
    textControllerVilleEntreprise ??= TextEditingController();
    textControllerRegionEntreprise ??= TextEditingController();
    textControllerPaysEntreprise ??= TextEditingController();
  }

   // Méthode pour choisir la photo de l'employé
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          etudiantPhoto = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection de l'image : $e");
    }
  }

  // Méthode pour sauvegarder les données
  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      EtudiantModel etudiantModel = EtudiantModel(
        idStudent: generateIdStudent("E0", 4),
        prenom: textControllerPrenom!.text, 
        nom: textControllerNom!.text, 
        sexe: checkboxValueSexe == 0 ? "Masculin": "Féminin", 
        dateDeNaissance: textControllerDateNaissance!.text, 
        adresse: "${textControllerVille!.text} ${textControllerRegion!.text} ${textControllerPays!.text}", 
        nationalite: textControllerNationalite!.text, 
        situationMatrimonial: getMatrimonialSituation(), 
        email: textControllerEmail!.text, 
        telephone: textControllerTel!.text, 
        nomTuteur: "${textControllerTuteurPrenom!.text} ${textControllerTuteurNom!.text}", 
        emailTuteur: textControllerEmailTuteur!.text, 
        telephoneTuteur: textControllerTelTuteur!.text,
        classe: "",
        scolariteAnnuel: 0,
        fraisEtudiant: 0,
        urlPhoto: "",
        echeances: []
      );

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => InscriptionEtudiantFinalScreen(etudiantModel: etudiantModel),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        )
      );
    }


    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Formulaire enregistré avec succès !")),
    // );
  }

  

  String getMatrimonialSituation() {
    switch (checkboxValueSituationMatrimonial) {
      case 0:
        return "Celibataire";
      case 1:
        return "Marié(e)";
      case 2:
        return "Veuf/ve";
      default:
        return "Divorcé(e)";
    }
  }

  void _selectedDate(TextEditingController textControllerDateNaissance) {
    showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1990),
      lastDate: DateTime(2030))
    .then((value) {
      setState(() {
        textControllerDateNaissance!.text =
            "${value!.day}/${value.month}/${value.year}";
      });
    });
  }

  // Méthode pour créer un champ de texte
  Widget buildRow(String label, Widget widget) {
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: canvasColor,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: widget,
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint, String? Function(String?)? validator, {bool isDate = false}) {
    return TextFormField(
      controller: controller,
      cursorColor: canvasColor,
      readOnly: isDate,
      onTap: isDate ? (){_selectedDate(controller);} : (){},
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: canvasColor,
            width: 1,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: canvasColor,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: isDate ? const Icon(
           Icons.calendar_month_outlined,
          color: canvasColor,
        ) : null,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.bold
      ),
    );
  }

  // Méthode pour afficher les titres des sections
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: canvasColor),
      ),
    );
  }

  Widget buildPaymentSection() {
    return Column(
      children: [
        for(int i = 1; i<=12; i+=3)...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: buildTextField(textControllerMontants[i-1]!, getMonth(i), null),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildTextField(textControllerMontants[i]!, getMonth(i+1), null),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildTextField(textControllerMontants[i+1]!, getMonth(i+2), null),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ]
      ],
    );
  }

  // Méthode pour obtenir le nom du mois
  String getMonth(int monthIndex) {
    List<String> months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet",
      "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[monthIndex - 1];
  }

  // Méthode pour afficher les colonnes de signature
  Widget buildFooterColumn(String label) {
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

  buildCheckBox(String label, int index, bool checkboxValueSx) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            unselectedWidgetColor:
                const Color.fromARGB(255, 87, 99, 108),
          ),
          child: Checkbox(
            value: checkboxValueSx ? checkboxValueSexe == index : checkboxValueSituationMatrimonial == index,
            onChanged: (newValue) {
              setState(() {
                // if (checkboxValueSx) {
                //   checkboxValueSexe = index;
                // } else {
                //   checkboxValueSituationMatrimonial = index;
                // }
                checkboxValueSx ? checkboxValueSexe = index : checkboxValueSituationMatrimonial = index;
              });
            },
            side: const BorderSide(
              width: 2,
              color: Color.fromARGB(255, 87, 99, 108),
            ),
            activeColor: canvasColor,
          ),
        ),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche d'Inscription", style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                // Center(
                //   child: Column(
                //     children: [
                //       const Text(
                //         "INSTITUT D'EXCELLENCE DU SÉNÉGAL",
                //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: canvasColor),
                //         textAlign: TextAlign.center,
                //       ),
                //       const SizedBox(height: 8),
                //       const Text(
                //         "Agrément N°:RepSen/Ensup-Priv/AP/394 -2021",
                //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: canvasColor),
                //         textAlign: TextAlign.center,
                //       ),
                //       const SizedBox(height: 8),
                //       const Text(
                //         "Fiche d'Etudiant 2024 - 2025",
                //         style: TextStyle(fontSize: 14, color: canvasColor),
                //         textAlign: TextAlign.center,
                //       ),
                //       const SizedBox(height: 8),
                //       Text("Fait à Dakar le : ${getCurrentDate()}", style: const TextStyle(color: canvasColor)),
                //     ],
                //   ),
                // ),
                // const Divider(thickness: 2, color: canvasColor),
            
                // // Photo d'identité
                // Center(
                //   child: Column(
                //     children: [
                //       const Text(
                //         "Photo d'identité de l'apprenant",
                //         style: TextStyle(fontWeight: FontWeight.bold, color: canvasColor),
                //       ),
                //       const SizedBox(height: 8),
                //       GestureDetector(
                //         onTap: pickImage,
                //         child: Container(
                //           height: 150,
                //           width: 150,
                //           decoration: BoxDecoration(
                //             border: Border.all(color: canvasColor, width: 2),
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.grey[200],
                //           ),
                //           child: etudiantPhoto == null
                //               ? const Icon(
                //                   Icons.camera_alt,
                //                   size: 50,
                //                   color: canvasColor,
                //                 )
                //               : ClipRRect(
                //                   borderRadius: BorderRadius.circular(10),
                //                   child: Image.file(
                //                   etudiantPhoto!,
                //                     fit: BoxFit.cover,
                //                   ),
                //                 ),
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       ElevatedButton.icon(
                //         onPressed: pickImage,
                //         icon: const Icon(Icons.image),
                //         label: const Text("Choisir une Image"),
                //         style: ElevatedButton.styleFrom(backgroundColor: canvasColor),
                //       ),
                //     ],
                //   ),
                // ),
            
                // const SizedBox(height: 16),
            
                // Identification de l'apprenant
                buildSectionTitle("IDENTIFICATION DE L'APPRENANT"),
                buildRow("Prénom et Nom", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerPrenom!, "Prenom", validateName)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerNom!, "Nom",  validateName)),
                    ],
                  ),
                ),
                buildRow("Date et Lieu de Naissance", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerDateNaissance!, "JJ/MM/AAAA", validationNotNull, isDate: true)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerLieuNaissance!, "Lieu", validationNotNull)),
                    ],
                  ),
                ),
                buildRow("Sexe", 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCheckBox("Masculin", 0, true),
                      const SizedBox(width: 15),
                      buildCheckBox("Féminin", 1, true),
                    ],
                  ),
                ),
                buildRow("Nationalité", buildTextField(textControllerNationalite!, "", validationNotNull)),
                buildRow("Statut Matrimonial", 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildCheckBox("Celibataire", 0, false),
                      const SizedBox(width: 15),
                      buildCheckBox("Marié(e)", 1, false),
                      const SizedBox(width: 15),
                      buildCheckBox("Veuf/ve", 2, false),
                      const SizedBox(width: 15),
                      buildCheckBox("Divorcé(e)", 3, false),
                    ],
                  ),
                ),
                buildRow("Adresse", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerVille!, "Ville", validationNotNull)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerRegion!, "Région", null)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerPays!, "Pays", null)),
                    ],
                  ),
                ),
                buildRow("Contacts", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerTel!, "Téléphone", validatePhoneNumber)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerEmail!, "Email", null))
                    ],
                  ),
                ),
                const SizedBox(height: 16),
            
                // Identification du tuteur
                buildSectionTitle("IDENTIFICATION DU TUTEUR OU DE L'ENTREPRISE"),
                buildRow("Raison Sociale", buildTextField(textControllerSocial!, "", null)),
                buildRow("Nom du Tuteur", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerTuteurPrenom!, "Prenom", validateName)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerTuteurNom!, "Nom", validateName)),
                    ],
                  ),
                ),
                buildRow("Adresse", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerVilleEntreprise!, "Ville", validationNotNull)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerRegionEntreprise!, "Région", null)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerPaysEntreprise!, "Pays", null)),
                    ],
                  ),
                ),
                buildRow("Contacts", 
                  Row(
                    children: [
                      Expanded(child: buildTextField(textControllerEmailTuteur!, "Téléphone", validatePhoneNumber)),
                      const SizedBox(width: 15),
                      Expanded(child: buildTextField(textControllerTelTuteur!, "Email", null))
                    ],
                  ),
                ),
            
                const SizedBox(height: 16),
                ButtonWidget(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  onTap: _saveForm,
                  text: "Suivant",
                  color: canvasColor,
                ),

            
                // // // Engagements
                // // buildSectionTitle("ENGAGEMENTS"),
                // // buildRow("Scolarité Annuelle", buildTextField(textControllerScolariteAnnuel!, "", validateSomme)),
                // // buildRow("Frais d'Etudiant", buildTextField(textControllerFraisEtudiant!, "", validateSomme)),
                // // buildRow("Frais Soutenance", buildTextField(textControllerFraisSoutenance!, "", null)),
                // // buildRow("Frais Assurance", buildTextField(textControllerFraisAssusance!, "", null)),
                // // buildRow("Frais de Stage", buildTextField(textControllerFraisStage!, "", null)),
            
                // buildSectionTitle("ENGAGEMENTS"),
                // buildRow("Formation", 
                //   Row(
                //     children: [
                //       Expanded(
                //         child: DropdownButtonFormField<String>(
                //           // hint: const Text("Formation"),
                //           items: [
                //             for(int i=0; i<classes.length; i++)
                //               DropdownMenuItem<String>(
                //                 value: classes[i],
                //                 child: Text(
                //                   classes[i], 
                //                 ),
                //               ),
                //           ],
                //           value: formationSelected,
                //           onChanged: (val) =>
                //               setState(() => formationSelected = val),
                //           style: const TextStyle(
                //             color: canvasColor,
                //             fontFamily: 'Roboto',
                //             fontSize: 16,
                //             letterSpacing: 0,
                //             fontWeight: FontWeight.w600,
                //           ),
                //           icon: const Icon(
                //             Icons.keyboard_arrow_down_rounded,
                //             size: 24,
                //           ),
                //           elevation: 2,
                //           decoration: InputDecoration(
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(20),
                //               borderSide: const BorderSide(
                //                 color: canvasColor,
                //                 width: 1,
                //               ),
                //             ),
                //           ),
                //         )
                //       ),
                //     // const SizedBox(width: 15),
                //     // Expanded(
                //     //   child: DropdownButtonFormField<String>(
                //     //   hint: const Text("Définir une période"),
                //     //   items: [
                //     //     for(int i=1; i<=3; i++)
                //     //       DropdownMenuItem<String>(
                //     //         value: "Licence $i",
                //     //         child: Text(
                //     //           "Licence $i", 
                //     //         ),
                //     //       ),
                //     //   ],
                //     //   value: niveauSelected,
                //     //   onChanged: (val) =>
                //     //       setState(() => niveauSelected = val),
                //     //   style: const TextStyle(
                //     //     color: canvasColor,
                //     //     fontFamily: 'Roboto',
                //     //     fontSize: 16,
                //     //     letterSpacing: 0,
                //     //     fontWeight: FontWeight.w600,
                //     //   ),
                //     //   icon: const Icon(
                //     //     Icons.keyboard_arrow_down_rounded,
                //     //     size: 24,
                //     //   ),
                //     //   elevation: 2,
                //     //   decoration: InputDecoration(
                //     //     border: OutlineInputBorder(
                //     //       borderRadius: BorderRadius.circular(20),
                //     //       borderSide: const BorderSide(
                //     //         color: canvasColor,
                //     //         width: 1,
                //     //       ),
                //     //     ),
                //     //   ),
                //     // )),
                //     // const SizedBox(width: 15),
                //     // Expanded(child: buildTextField(textControllerRegion!, "Scolarité Annuelle", validateSomme)),
                //     ],
                //   ),
                // ),
                // buildRow("Paiement", 
                //   Row(
                //     children: [
                //       Expanded(child: buildTextField(textControllerScolariteAnnuel!, "Scolarité Annuelle", validateSomme)),
                //       const SizedBox(width: 15),
                //       Expanded(child: buildTextField(textControllerFraisInscription!, "Frais d'inscription", validateSomme)),
                //     ],
                //   ),
                // ),
                // buildRow("Autres frais", 
                //   Row(
                //     children: [
                //       Expanded(child: buildTextField(textControllerFraisSoutenance!, "Soutenance", null)),
                //       const SizedBox(width: 8),
                //       Expanded(child: buildTextField(textControllerFraisAssusance!, "Assurance", null)),
                //       const SizedBox(width: 8),
                //       Expanded(child: buildTextField(textControllerFraisStage!, "Stage", null)),
                //     ],
                //   )
                // ),
                // const SizedBox(height: 16),
            
                // // Paiement
                // buildSectionTitle("PAIEMENT"),
                // buildPaymentSection(),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


















class InscriptionEtudiantFinalScreen extends StatelessWidget {
  final EtudiantModel etudiantModel;
  InscriptionEtudiantFinalScreen({super.key, required this.etudiantModel});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          Expanded(
            child: InscriptionEtudiantFinal(etudiantModel: etudiantModel),
          ),
        ],
      ),
    );
  }
}


class InscriptionEtudiantFinal extends ConsumerStatefulWidget {
  final EtudiantModel etudiantModel;
  const InscriptionEtudiantFinal({super.key, required this.etudiantModel});

  @override
  ConsumerState<InscriptionEtudiantFinal> createState() => _InscriptionEtudiantFinalState();
}

class _InscriptionEtudiantFinalState extends ConsumerState<InscriptionEtudiantFinal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? textControllerScolariteAnnuel;
  TextEditingController? textControllerFraisInscription;
  TextEditingController? textControllerFraisAssusance;
  TextEditingController? textControllerFraisSoutenance;
  TextEditingController? textControllerFraisStage;

  String? formationSelected;
  String? niveauSelected;
  final classes = ['Informatique', 'Reseaux et Telecom', 'Genie Civil', 'Genie Logiciels', 'Architecture'];
  List<Echeance> paiements = [
    Echeance(description: "Frais d'inscription", montantAPayer: 0, montantDejaPayer: 0, dernierDelais: DateTime.now()),
  ];
  int indexEcheance = 1;
  // var textControllerMontants = [
  //   for(int i=0; i<12; i++)
  //     [TextEditingController(), TextEditingController(), TextEditingController()]
  // ];

  @override
  void initState() {
    super.initState();

    textControllerScolariteAnnuel ??= TextEditingController();
    textControllerFraisInscription ??= TextEditingController();
    textControllerFraisAssusance ??= TextEditingController();
    textControllerFraisSoutenance ??= TextEditingController();
    textControllerFraisStage ??= TextEditingController();
  }

  

  void _selectedDate(TextEditingController textControllerDateNaissance) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100))
    .then((value) {
      setState(() {
        textControllerDateNaissance.text = value.toString().split(' ')[0];
      });
    });
  }

  


    // Méthode pour créer un champ de texte
  Widget buildRow(String label, Widget widget) { 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: canvasColor,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: widget,
          ),
        ],
      ),
    );
  }

    // Méthode pour obtenir le nom du mois
  String getMonth(int monthIndex) {
    List<String> months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet",
      "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    return months[monthIndex - 1];
  }


  Widget buildTextField(
      TextEditingController controller, 
      String hint, 
      String? Function(String?)? validator, 
      {bool isDate = false,
      void Function(String)? onChanged}
    ) {
    return TextFormField(
      controller: controller,
      cursorColor: canvasColor,
      readOnly: isDate,
      onTap: isDate ? (){_selectedDate(controller);} : (){},
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: canvasColor,
            width: 1,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: canvasColor,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 3,
          ),
          // borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: isDate ? const Icon(
           Icons.calendar_month_outlined,
          color: canvasColor,
        ) : null,
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.bold
      ),
    );
  }

  // Méthode pour afficher les titres des sections
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: canvasColor),
      ),
    );
  }

  // Widget buildPaymentSection() {
  //   return Column(
  //     children: [
  //       for(int i = 0; i<12; i++)...[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               flex: 1,
  //               child: Text(
  //                 "Echeance N°${i+1}",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: canvasColor,
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: buildTextField(textControllerMontants[i][0], "", null),
  //             ),
  //             const SizedBox(width: 15),
  //             Expanded(
  //               child: buildTextField(textControllerMontants[i][1], "", null),
  //             ),
  //             const SizedBox(width: 15),
  //             Expanded(
  //               child: buildTextField(textControllerMontants[i][2], "", null, isDate: true),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 15),
  //       ]
  //     ],
  //   );
  // }

  
 

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      EtudiantModel etudiantModel = EtudiantModel(
        idStudent: widget.etudiantModel.idStudent,
        prenom: widget.etudiantModel.prenom, 
        nom: widget.etudiantModel.nom, 
        sexe: widget.etudiantModel.sexe, 
        dateDeNaissance: widget.etudiantModel.dateDeNaissance, 
        adresse: widget.etudiantModel.adresse, 
        nationalite: widget.etudiantModel.nationalite, 
        situationMatrimonial: widget.etudiantModel.situationMatrimonial, 
        email: widget.etudiantModel.email, 
        telephone: widget.etudiantModel.telephone, 
        nomTuteur: widget.etudiantModel.nomTuteur, 
        emailTuteur: widget.etudiantModel.emailTuteur, 
        telephoneTuteur: widget.etudiantModel.telephoneTuteur,
        classe: "${formationSelected!.split(" ").join().toLowerCase()}_${DateTime.now().year}",
        scolariteAnnuel: int.parse(textControllerScolariteAnnuel!.text),
        fraisEtudiant: int.parse(textControllerFraisInscription!.text),
        urlPhoto: "",
        echeances: [
          for(var paiement in paiements)
              Echeance(
                description: paiement.description, 
                montantAPayer: paiement.montantAPayer, 
                montantDejaPayer: paiement.montantDejaPayer,
                dernierDelais: paiement.dernierDelais,
              )
        ]
      );

      FactureModel factureModel = FactureModel(
        numero: generateNumInvoice(), 
        client: "${etudiantModel.prenom} ${etudiantModel.nom}",
        idStudent: etudiantModel.idStudent,
        date: DateTime.now(), 
        montant: paiements.map((p)=>p.montantDejaPayer).toList().reduce((a, b)=>a+b), 
        objet: "Formation $formationSelected",
        montantAPayer: int.parse(textControllerScolariteAnnuel!.text),
        isValidate: false,
        details: [
          for(var paiement in paiements)
            if(paiement.montantDejaPayer > 0)
              Detail(
                article: paiement.description, 
                date: DateTime.now(), 
                montant: paiement.montantDejaPayer,
                moyenDePaiement: "Espèce"
              )
        ],
      );

      await ref.watch(etudiantControllerProvider.notifier).addStudent(etudiantModel, context);
      await ref.watch(factureControllerProvider.notifier).addFacture(factureModel, context);
      // for(var paiement in paiements)
      //   print(paiement);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewPdf(
            etudiantModel: etudiantModel,
            factureModel: factureModel
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche d'Inscription", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [            
                buildSectionTitle("ENGAGEMENTS"),
                buildRow("Formation", 
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          // hint: const Text("Formation"),
                          items: [
                            for(int i=0; i<classes.length; i++)
                              DropdownMenuItem<String>(
                                value: classes[i],
                                child: Text(
                                  classes[i], 
                                ),
                              ),
                          ],
                          value: formationSelected,
                          onChanged: (val) =>
                              setState(() => formationSelected = val),
                          style: const TextStyle(
                            color: canvasColor,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 24,
                          ),
                          elevation: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: canvasColor,
                                width: 1,
                              ),
                            ),
                          ),
                        )
                      ),
                    // const SizedBox(width: 15),
                    // Expanded(
                    //   child: DropdownButtonFormField<String>(
                    //   hint: const Text("Définir une période"),
                    //   items: [
                    //     for(int i=1; i<=3; i++)
                    //       DropdownMenuItem<String>(
                    //         value: "Licence $i",
                    //         child: Text(
                    //           "Licence $i", 
                    //         ),
                    //       ),
                    //   ],
                    //   value: niveauSelected,
                    //   onChanged: (val) =>
                    //       setState(() => niveauSelected = val),
                    //   style: const TextStyle(
                    //     color: canvasColor,
                    //     fontFamily: 'Roboto',
                    //     fontSize: 16,
                    //     letterSpacing: 0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    //   icon: const Icon(
                    //     Icons.keyboard_arrow_down_rounded,
                    //     size: 24,
                    //   ),
                    //   elevation: 2,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(20),
                    //       borderSide: const BorderSide(
                    //         color: canvasColor,
                    //         width: 1,
                    //       ),
                    //     ),
                    //   ),
                    // )),
                    // const SizedBox(width: 15),
                    // Expanded(child: buildTextField(textControllerRegion!, "Scolarité Annuelle", validateSomme)),
                    ],
                  ),
                ),
                buildRow("Paiement", 
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          textControllerScolariteAnnuel!, 
                          "Scolarité Annuelle", 
                          (value) {
                            final x = paiements.map((p)=>p.montantAPayer).toList().reduce((a, b)=>a+b);
                            final validation = validateSomme(value);
                            if(validation != null) return validation;
                            if(int.parse(value!) != x) return 'Scolarité annuelle doit être égale à la somme des montant à payer.';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: buildTextField(
                          textControllerFraisInscription!, 
                          "Frais d'inscription", 
                          validateSomme, 
                          onChanged: (value) {
                            setState(() {
                              paiements[0].montantAPayer = int.parse(value.isNotEmpty ? value : "0");
                              // On suppose que l'étudiant a deja payer les frais d'inscriptions
                              paiements[0].montantDejaPayer = paiements[0].montantAPayer;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                buildRow("Autres frais", 
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: ajouterFrais,
                          style: const ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(width: 1)
                            ))
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Ajouter un frais", 
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextButton(
                          onPressed: supprimerFrais,
                          style: const ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(width: 1)
                            ))
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Supprimer un frais", 
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                buildRow("Paiements mensuels", 
                  TextButton(
                    onPressed: (){ajouterFrais(isEcheance: true);},
                    style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(200, 45)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        side: BorderSide(width: 1)
                      ))
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Ajouter un Echeance Mensuel", 
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
            
                // Paiement
                buildSectionTitle("PAIEMENT"),
                // buildPaymentSection(),
                TableExample(paiements: paiements),
                const SizedBox(height: 16),
                ButtonWidget(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  onTap: _saveForm,
                  text: "Confirmer",
                  color: canvasColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ajouterFrais({bool isEcheance = false}) {
    TextEditingController descriptionController = TextEditingController(text: isEcheance ? 'Echeance $indexEcheance':'');
    TextEditingController montantAPayerController = TextEditingController();
    TextEditingController montantDejaPayerController = TextEditingController();
    TextEditingController dernierDelaisController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Frais"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Déscription du frias',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montantAPayerController,
                decoration: const InputDecoration(labelText: 'Montant À Payer'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montantDejaPayerController,
                decoration: const InputDecoration(labelText: 'Montant Déja Payer'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dernierDelaisController,
                onTap: (){_selectedDate(dernierDelaisController);},
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Dernier délai de Paiement'),
                keyboardType: TextInputType.datetime,
              ),
            ],
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
                setState(() {
                  paiements.add(
                    Echeance(
                      description: descriptionController.text, 
                      montantAPayer: int.parse(montantAPayerController.text), 
                      montantDejaPayer: int.parse(montantDejaPayerController.text), 
                      dernierDelais: DateTime.parse(dernierDelaisController.text),
                    ),
                  );
                  if(isEcheance){
                    indexEcheance++;
                  }
                });
              
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void supprimerFrais() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Frais"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(var paiement in paiements)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(paiement.description),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          paiements.remove(paiement);
                        });
                      }, 
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red,)
                    )
                  ],
                )
            ],
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
                setState(() {
                  // paiements.add(
                  //   Paiement(
                  //     description: descriptionController.text, 
                  //     montantAPayer: int.parse(montantAPayerController.text), 
                  //     montantDejaPayer: int.parse(montantDejaPayerController.text), 
                  //     dernierDelais: dernierDelaisController.text,
                  //   ),
                  // );
                });

                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}



class TableExample extends StatelessWidget {
  List<Echeance> paiements;
  TableExample({super.key, required this.paiements});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        const TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Déscription"),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Montant À Payer"),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Montant Déja Payer"),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Dernier Delai"),
              ),
            ),
          ],
        ),
        for(int i=0; i<paiements.length; i++)
          TableRow(
            children: <Widget>[
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(paiements[i].description),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(paiements[i].montantAPayer.toString()),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(paiements[i].montantDejaPayer.toString()),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(paiements[i].dernierDelais.toString().split(' ')[0]),
                ),
              ),
            ],
          ),
        TableRow(
          children: <Widget>[
            const TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Total"),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(paiements.map((p)=>p.montantAPayer).toList().reduce((a, b)=>a+b).toString()),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(paiements.map((p)=>p.montantDejaPayer).toList().reduce((a, b)=>a+b).toString()),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(paiements.last.dernierDelais.toString().split(' ')[0]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
