import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/employe_model.dart';
import 'package:frontend/models/paiment_model.dart';
import 'package:frontend/screens/comptable/account_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class PaiementPage extends StatelessWidget {
  PaiementPage({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: AccountantScreen(),
          ),
          const Expanded(
            child: PaiementPageHome(),
          ),
        ],
      ),
    );
  }
}

class PaiementPageHome extends StatefulWidget {
  const PaiementPageHome({super.key});

  @override
  State<PaiementPageHome> createState() => _PaiementPageHomeState();
}

class _PaiementPageHomeState extends State<PaiementPageHome> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod;
  EmployeModel? selectedRecipient;
  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  // TextEditingController recipientController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  // final TextEditingController designationController = TextEditingController();
  // late FactureModel factureModel;
  List<EmployeModel> employes = [];
  List<PaimentModel> paiements = [];
  List<PaimentModel> initialPaiements = [];

  double montantPaiements = 0;
  double montantPaiementsCeMois = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  void fetchData() async {
    paiements = [];
    initialPaiements = [];
    montantPaiements = 0;
    montantPaiementsCeMois = 0;
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('paiements').get();
      for (var p in querySnapshot.docs) {
        setState(() {
          final pm = PaimentModel.fromMap(p.data());
          paiements.add(pm);
          initialPaiements.add(pm);
          montantPaiements += pm.montant;
          montantPaiementsCeMois += pm.date.month == DateTime.now().month 
            ? pm.montant : 0;
        });
      }

      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('employes').get();
      for (var e in querySnapshot2.docs) {
        setState(() {
          employes.add(EmployeModel.fromMap(e.data()));
        });
      }
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
        title: const Text('Paiements', style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              // height: 65,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Montant total des paiements",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          formatCurrency(montantPaiements),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Montant des paiements de ce mois",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          formatCurrency(montantPaiementsCeMois),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
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
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          Container(
                            // height: 68,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Liste des paiements',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height: 45,
                                    child: TextFormField(
                                      controller: searchController,
                                      onChanged: (value) async {
                                        setState(() {
                                          paiements = _filteredPaiements(initialPaiements);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Recherchez un destinataire ou une date',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // DataTable
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: 60 + 4 * 45,
                                child: DataTable2(
                                  columns: const [
                                    DataColumn(
                                        label: Text('Date de paiement')),
                                    DataColumn(label: Text('Destinataire')),
                                    DataColumn(label: Text('Montant TTC')),
                                    DataColumn(
                                        label: Text('Moyen de paiement')),
                                  ],
                                  rows: paiements
                                      .map(
                                        (paiement) => DataRow(
                                          cells: [
                                            DataCell(Text(paiement.date
                                                .toString()
                                                .split(' ')[0])),
                                            DataCell(
                                                Text(paiement.destinataire)),
                                            DataCell(Text(
                                                formatCurrency(paiement.montant))),
                                            DataCell(Text(
                                                paiement.moyenDePaiement)),
                                          ],
                                        ),
                                      )
                                      .toList(),
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
                      )),
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                      text:
                                          selectedDate.toString().split(' ')[0],
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
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
                                  DropdownButtonFormField<EmployeModel>(
                                    validator: (EmployeModel? value) {
                                      if (value == null) return 'Ce champ est requis';
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Destinataire',
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(),
                                    ),
                                    value: selectedRecipient,
                                    items: employes.map((rec) => DropdownMenuItem(
                                                  value: rec,
                                                  child: Text(rec.nom),
                                                ))
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRecipient = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: designationController,
                                    validator: validationNotNull,
                                    maxLines: 2,
                                    decoration: const InputDecoration(
                                      labelText: "Designation",
                                      border: OutlineInputBorder(),
                                    ),
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
                                    items:
                                        ['Carte Bancaire', 'Espèces', 'Chèque']
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
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        PaimentModel paimentModel =
                                            PaimentModel(
                                          idPaiement:
                                              generateIdStudent("P0", 5),
                                          destinataire: selectedRecipient!.nom,
                                          idDestinataire: selectedRecipient!.idEmploye,
                                          designation:
                                              designationController.text,
                                          montant: double.parse(amountController.text),
                                          moyenDePaiement: selectedPaymentMethod!,
                                          date: selectedDate,
                                        );

                                        setState(() {
                                          paiements.add(paimentModel);
                                          // factureModel.montant += detail.montant;
                                          selectedPaymentMethod = null;
                                          selectedRecipient = null;
                                        });
                                        designationController.clear();
                                        amountController.clear();

                                        await FirebaseFirestore.instance
                                          .collection('paiements')
                                          .doc(paimentModel.idPaiement)
                                          .set(paimentModel.toMap());
                                        showSnackBar(context, "Paiement effectué");
                                      }
                                    },
                                    child: const Text('Ajouter le paiement'),
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

  List<PaimentModel> _filteredPaiements(List<PaimentModel> paiements) {
    if (searchController.text.isEmpty) {
      return paiements;
    }
    return paiements.where((paiement) {
      return paiement.destinataire.toLowerCase().contains(searchController.text.toLowerCase()) ||
          paiement.date.toString().contains(searchController.text.toLowerCase());
    }).toList();
  }
}

// class PaiementPageHome extends StatefulWidget {
//   const PaiementPageHome({super.key});

//   @override
//   State<PaiementPageHome> createState() => _PaiementPageHomeState();
// }

// class _PaiementPageHomeState extends State<PaiementPageHome> {
//   String? selectedPaymentMethod;
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController recipientController = TextEditingController();
//   final List<Map<String, dynamic>> paymentHistory = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Paiement", style: TextStyle(color: Colors.white)),
//         backgroundColor: canvasColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Mode de Paiement",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             _buildPaymentMethods(),
//             const SizedBox(height: 20),
//             const Text(
//               "Détails du Paiement",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Montant à payer",
//                 prefixIcon: Icon(Icons.money),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: recipientController,
//               decoration: const InputDecoration(
//                 labelText: "Destinataire (Nom ou Téléphone)",
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _confirmPayment,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//               child: const Text("Confirmer le Paiement"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _showPaymentHistory,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//               child: const Text("Voir les Paiements"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentMethods() {
//     final paymentMethods = ["Wave", "Orange Money", "Carte Bancaire", "Espèces"];
//     return Wrap(
//       spacing: 10.0,
//       runSpacing: 10.0,
//       children: paymentMethods.map((method) {
//         return ChoiceChip(
//           label: Text(method),
//           selected: selectedPaymentMethod == method,
//           onSelected: (selected) {
//             setState(() {
//               selectedPaymentMethod = selected ? method : null;
//             });
//           },
//           selectedColor: Colors.teal,
//           backgroundColor: Colors.grey[200],
//           labelStyle: TextStyle(
//             color: selectedPaymentMethod == method ? Colors.white : Colors.black,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   void _confirmPayment() {
//     if (selectedPaymentMethod == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Veuillez choisir un mode de paiement")),
//       );
//       return;
//     }

//     if (amountController.text.isEmpty || recipientController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Veuillez remplir tous les champs")),
//       );
//       return;
//     }

//     final double amount = double.tryParse(amountController.text) ?? 0.0;
//     final String recipient = recipientController.text;

//     // Simuler la confirmation de paiement
//     setState(() {
//       paymentHistory.add({
//         "method": selectedPaymentMethod,
//         "amount": amount,
//         "recipient": recipient,
//         "date": DateTime.now().toString(),
//         "status": "Réussi",
//       });
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Paiement de $amount FCFA effectué via $selectedPaymentMethod")),
//     );

//     // Réinitialiser les champs
//     amountController.clear();
//     recipientController.clear();
//     setState(() {
//       selectedPaymentMethod = null;
//     });
//   }

//   void _showPaymentHistory() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Historique des Paiements"),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: paymentHistory.isEmpty
//                 ? const Text("Aucun paiement effectué.")
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: paymentHistory.length,
//                     itemBuilder: (context, index) {
//                       final payment = paymentHistory[index];
//                       return ListTile(
//                         leading: Icon(
//                           Icons.payment,
//                           color: payment['status'] == "Réussi" ? Colors.green : Colors.red,
//                         ),
//                         title: Text("${payment['method']} - ${payment['recipient']}"),
//                         subtitle: Text("Montant : ${payment['amount']} FCFA\nDate : ${payment['date']}"),
//                         trailing: Text(
//                           payment['status'],
//                           style: TextStyle(
//                             color: payment['status'] == "Réussi" ? Colors.green : Colors.red,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
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
