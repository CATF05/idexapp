// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart'; // Utilisé pour les graphiques
// import 'package:frontend/screens/DG/dg_screen.dart';
// import 'package:frontend/utils/constants.dart';
// import 'package:frontend/widgets/side_bar.dart';
// import 'package:sidebarx/sidebarx.dart'; // Utilisé pour les graphiques


// class AuditConformiteScreen extends StatelessWidget {
//   AuditConformiteScreen({super.key});

//   final _controller = SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Row(
//         children: [
//           ExampleSidebarX(controller: _controller, home: DGScreen(),),
//           const Expanded(
//             child: AuditConformiteHome(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AuditConformiteHome extends StatefulWidget {
//   const AuditConformiteHome({super.key});

//   @override
//   State<AuditConformiteHome> createState() => _AuditConformiteHomeState();
// }

// class _AuditConformiteHomeState extends State<AuditConformiteHome> {
//   // Liste d'exemples d'audits de conformité (données fictives)
//   List<Map<String, dynamic>> audits = [
//     {'auditName': 'Audit de sécurité', 'date': '2024-10-10', 'result': 'Conforme'},
//     {'auditName': 'Audit environnemental', 'date': '2024-10-15', 'result': 'Non conforme'},
//     {'auditName': 'Audit administratif', 'date': '2024-10-18', 'result': 'Conforme'},
//     {'auditName': 'Audit financier', 'date': '2024-10-20', 'result': 'Non conforme'},
//   ];

//   // Données de graphique fictives pour l'audit de conformité au fil du temps
//   List<FlSpot> auditConformityData = [
//     FlSpot(0, 1), // Conforme
//     FlSpot(1, 0), // Non conforme
//     FlSpot(2, 1), // Conforme
//     FlSpot(3, 0), // Non conforme
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Audit de Conformité", style: TextStyle(color: Colors.white)),
//         backgroundColor: canvasColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Analyse de la Conformité des Audits",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             _buildAuditConformityChart(),
//             const SizedBox(height: 20),
//             const Text(
//               "Liste des Audits",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: audits.length,
//                 itemBuilder: (context, index) {
//                   var audit = audits[index];
//                   return Card(
//                     child: ListTile(
//                       title: Text(audit['auditName']),
//                       subtitle: Text("Date: ${audit['date']} | Résultat: ${audit['result']}"),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.info),
//                         onPressed: () {
//                           _showAuditDetails(audit);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Affiche un graphique de la conformité des audits au fil du temps
//   Widget _buildAuditConformityChart() {
//     return SizedBox(
//       height: 300,
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(show: true),
//           titlesData: FlTitlesData(show: true),
//           borderData: FlBorderData(show: true),
//           minX: 0,
//           maxX: audits.length.toDouble() - 1,
//           minY: 0,
//           maxY: 1,
//           lineBarsData: [
//             LineChartBarData(
//               spots: auditConformityData,
//               isCurved: true,
//               color:Colors.green,
//               belowBarData: BarAreaData(show: true, color: Colors.green.shade200),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Affiche les détails d'un audit
//   void _showAuditDetails(Map<String, dynamic> audit) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("${audit['auditName']} - Détails de l'Audit"),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Date de l'audit: ${audit['date']}"),
//               Text("Résultat: ${audit['result']}"),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Fermer"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
