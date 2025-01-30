// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/firebase/controlers/controler.dart';
// import 'package:frontend/models/demande_model.dart';
// import 'package:frontend/models/etudiant_model.dart';
// import 'package:frontend/models/facture_model.dart';
// import 'package:frontend/models/user_model.dart';
// import 'package:frontend/pages/facture_view.dart';
// import 'package:frontend/pages/student_view.dart';
// import 'package:frontend/screens/DG/pages/demande_view.dart';
// import 'package:frontend/utils/utils.dart';

// class ActionsWidget extends ConsumerStatefulWidget {
//   Widget home;
//   FactureModel? factureModel;
//   EtudiantModel? etudiantModel;
//   DemandeInscription? demandeInscription;
//   ActionsWidget({
//     super.key,
//     required this.home,
//     this.factureModel,
//     this.etudiantModel,
//     this.demandeInscription,
//   });

//   @override
//   ConsumerState<ActionsWidget> createState() => _ActionsWidgetState();
// }

// class _ActionsWidgetState extends ConsumerState<ActionsWidget> {
//   bool isDg = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchUserData();
//   }

//   void fetchUserData() async {
//     final currentUser = await FirebaseAuth.instance.currentUser;
//     final querySnapshot = await FirebaseFirestore.instance
//         .collection('admins')
//         .doc(currentUser!.uid)
//         .get();
//     setState(() {
//       isDg =
//           UserModel.fromMap(querySnapshot.data()!).role == 'Directeur Général';
//     });
//   }

//   void editDoc(BuildContext context) {
//     if (widget.factureModel != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => FactureView(
//             factureModel: widget.factureModel!,
//             home: widget.home,
//           ),
//         ),
//       );
//     }
//     if (widget.etudiantModel != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => StudentView(
//             etudiantModel: widget.etudiantModel!,
//             home: widget.home,
//           ),
//         ),
//       );
//     }
//     if (widget.demandeInscription != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DemandeView(
//             demandeInscription: widget.demandeInscription!,
//           ),
//         ),
//       );
//     }
//   }

//   void viewPdfDoc(BuildContext context) {
//     if (widget.factureModel != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 FacturePdfView(factureModel: widget.factureModel!)),
//       );
//     }
//     if (widget.etudiantModel != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 StudentPdfView(etudiantModel: widget.etudiantModel!)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       // mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         if (widget.demandeInscription == null)
//           GestureDetector(
//             onTap: () {
//               // _showSnackbar(context, "Modifier les infos de l'étudiant");
//               viewPdfDoc(context);
//             },
//             child: Card(
//               color: Colors.amber,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4)),
//               child: const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: Center(
//                   child: Icon(
//                     Icons.remove_red_eye_outlined,
//                     color: Colors.white,
//                     size: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         GestureDetector(
//           onTap: () {
//             editDoc(context);
//             // _showSnackbar(context, "Modifier les infos de l'étudiant");
//           },
//           child: Card(
//             color: Colors.cyan,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//             child: const SizedBox(
//               width: 22,
//               height: 22,
//               child: Center(
//                 child: Icon(
//                   Icons.edit_document,
//                   color: Colors.white,
//                   size: 15,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (isDg && widget.factureModel != null)
//           GestureDetector(
//             onTap: () {
//               showDialog<String>(
//                 context: context,
//                 builder: (BuildContext context) => AlertDialog(
//                   title: const Text('Validation'),
//                   content: Text(
//                       'Vous confirmer que la Facture n° ${widget.factureModel!.numero} est conforme et signée ?'),
//                   actions: <Widget>[
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, 'Cancel'),
//                       child: const Text('Non'),
//                     ),
//                     TextButton(
//                       onPressed: () async {
//                         Navigator.pop(context);
//                         setState(() {
//                           widget.factureModel!.isValidate = true;
//                         });
//                         await ref
//                             .watch(factureControllerProvider.notifier)
//                             .addFacture(widget.factureModel!, context, true);
//                         setState(() {});
//                       },
//                       child: const Text(
//                         'Oui',
//                         style: TextStyle(color: Colors.green),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//               // _showSnackbar(context, "Télécharger le dossier de l'étudiant");
//             },
//             child: Card(
//               color: Colors.green,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4)),
//               child: const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: Center(
//                   child: Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         GestureDetector(
//           onTap: () {
//             showSnackBar(context, "Suppimer l'étudiant");
//           },
//           child: Card(
//             color: Colors.red,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//             child: const SizedBox(
//               width: 22,
//               height: 22,
//               child: Center(
//                 child: Icon(
//                   Icons.delete_outlined,
//                   color: Colors.white,
//                   size: 15,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // // IconButton(onPressed: (){}, icon: Icon(Icons.)),
//       ],
//     );
//   }
// }
