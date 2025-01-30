// import 'package:flutter/material.dart';

// class GestionProfesseurPage extends StatefulWidget {
//   @override
//   _GestionProfesseurPageState createState() => _GestionProfesseurPageState();
// }

// class _GestionProfesseurPageState extends State<GestionProfesseurPage> {
//   List<Map<String, String>> professeurs = [
//     {"nom": "Diallo", "prenom": "Mamadou", "matiere": "Mathématiques"},
//     {"nom": "Ba", "prenom": "Fatou", "matiere": "Physique"},
//     {"nom": "Sow", "prenom": "Aminata", "matiere": "Chimie"},
//   ];

//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gestion des Professeurs', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blueAccent.shade700,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               _showSearchDialog();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Liste des Professeurs',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _filteredProfesseurs().length,
//                 itemBuilder: (context, index) {
//                   final professeur = _filteredProfesseurs()[index];
//                   return _professeurCard(professeur, index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddOrEditDialog();
//         },
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.blueAccent.shade700,
//       ),
//     );
//   }

//   // Méthode pour filtrer les professeurs selon la recherche
//   List<Map<String, String>> _filteredProfesseurs() {
//     if (searchQuery.isEmpty) {
//       return professeurs;
//     }
//     return professeurs
//         .where((professeur) =>
//             professeur['nom']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
//             professeur['matiere']!.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//   }

//   // Méthode pour afficher la boîte de dialogue d'ajout/édition
//   void _showAddOrEditDialog({Map<String, String>? professeur, int? index}) {
//     TextEditingController nomController = TextEditingController(text: professeur?['nom'] ?? "");
//     TextEditingController prenomController = TextEditingController(text: professeur?['prenom'] ?? "");
//     TextEditingController matiereController = TextEditingController(text: professeur?['matiere'] ?? "");

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(professeur == null ? "Ajouter un Professeur" : "Modifier le Professeur"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nomController,
//                 decoration: const InputDecoration(labelText: 'Nom'),
//               ),
//               TextField(
//                 controller: prenomController,
//                 decoration: const InputDecoration(labelText: 'Prénom'),
//               ),
//               TextField(
//                 controller: matiereController,
//                 decoration: const InputDecoration(labelText: 'Matière'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (professeur == null) {
//                   // Ajouter un nouveau professeur
//                   setState(() {
//                     professeurs.add({
//                       "nom": nomController.text,
//                       "prenom": prenomController.text,
//                       "matiere": matiereController.text,
//                     });
//                   });
//                 } else {
//                   // Modifier le professeur existant
//                   setState(() {
//                     professeurs[index!] = {
//                       "nom": nomController.text,
//                       "prenom": prenomController.text,
//                       "matiere": matiereController.text,
//                     };
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Enregistrer'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Méthode pour afficher la boîte de dialogue de recherche
//   void _showSearchDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Rechercher un Professeur"),
//           content: TextField(
//             controller: searchController,
//             decoration: const InputDecoration(hintText: 'Entrez un nom ou une matière'),
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//               });
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Fermer'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Méthode pour supprimer un professeur
//   void _deleteProfesseur(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Supprimer le Professeur"),
//           content: const Text("Êtes-vous sûr de vouloir supprimer ce professeur ?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   professeurs.removeAt(index);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Carte d'affichage d'un professeur
//   Widget _professeurCard(Map<String, String> professeur, int index) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           child: Text(professeur['nom']![0]),
//           backgroundColor: Colors.blueAccent.shade100,
//         ),
//         title: Text(
//           "${professeur['nom']} ${professeur['prenom']}",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text("Matière : ${professeur['matiere']}"),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.blue),
//               onPressed: () {
//                 _showAddOrEditDialog(professeur: professeur, index: index);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 _deleteProfesseur(index);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
