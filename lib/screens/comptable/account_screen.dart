import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common_pages/students.dart';
import 'package:frontend/models/admins_model.dart';
import 'package:frontend/models/employe_model.dart';
import 'package:frontend/models/etudiant_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/models/paiment_model.dart';
import 'package:frontend/models/prof_model.dart';
import 'package:frontend/common_pages/factures.dart';
import 'package:frontend/screens/comptable/pages/notifications.dart';
import 'package:frontend/screens/comptable/pages/paiement.dart';
import 'package:frontend/screens/comptable/pages/parametre.dart';
import 'package:frontend/screens/comptable/pages/rapport.dart';
import 'package:frontend/screens/comptable/pages/transactions.dart';
import 'package:frontend/common_pages/fiche_inscription.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/dashboardItem.dart';
import 'package:frontend/widgets/feature_card.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class AccountantScreen extends StatelessWidget {
  AccountantScreen({super.key});

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
            child: AccountHome(),
          ),
        ],
      ),
    );
  }
}

class AccountHome extends StatefulWidget {
  const AccountHome({super.key});

  @override
  State<AccountHome> createState() => _AccountHomeState();
}

class _AccountHomeState extends State<AccountHome> {
  int solde = 0;
  double paiementRecu = 0;
  int retardDePaiement = 0;
  double paiementEffectue = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot1 =
          await FirebaseFirestore.instance.collection('students').get();
      if (querySnapshot1.docs.isNotEmpty) {
        for (var f in querySnapshot1.docs) {
          retardDePaiement += EtudiantModel.fromMap(f.data()).enRegle ? 0 : 1;
        }
      }

      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('factures').get();
      if (querySnapshot2.docs.isNotEmpty) {
        for (var f in querySnapshot2.docs) {
          setState(() {
            paiementRecu += FactureModel.fromMap(f.data()).montant;
          });
        }
      }

      final querySnapshot3 =
          await FirebaseFirestore.instance.collection('paiements').get();
      if (querySnapshot3.docs.isNotEmpty) {
        for (var p in querySnapshot3.docs) {
          paiementEffectue += PaimentModel.fromMap(p.data()).montant;
        }
      }
      setState(() {});
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), canvasColor], // Gradient de bleu
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDashboard(),
            Expanded(
              child: ListView(
                children: [
                  FeatureCard(
                    icon: Icons.description,
                    title: 'Factures',
                    description: 'Gérer et générer les factures clients.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FacturePage(
                                  home: AccountantScreen(),
                                )),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Transactions',
                    description:
                        'Gérer et consulter les transactions financières.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionPage(
                              home: AccountantScreen(),
                            )),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.payment,
                    title: 'Paiements',
                    description: 'Suivi des paiements en attente et des reçus.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaiementPage()),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.receipt_long,
                    title: 'Rapports Financiers',
                    description:
                        'Consulter les rapports financiers et générer des exports.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RapportPage()),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.school,
                    title: 'Fiche d\'inscription',
                    description:
                        'Creer des fiches d\'inscription pour les étudiants.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InscriptionEtudiantScreen(
                                  home: AccountantScreen(),
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return AnimatedBuilder(
    //   animation: widget.controller,
    //   builder: (context, child) {
    //     switch (widget.controller.selectedIndex) {
    //       case 0:
    //         return home(context, widget.controller);
    //       case 1:
    //         return const NotificationsComptable();
    //       case 2:
    //         return const ParametreComptable();
    //       case 4:
    //         return TransactionPage();
    //       case 5:
    //         return RapportPage();
    //       case 6:
    //         return PaiementPage();
    //       case 7:
    //         return FacturePage();
    //       case 8:
    //         return InscriptionEtudiantScreen();
    //       default:
    //         return home(context, widget.controller);
    //     }
    //   },
    // );
  }

  // Widget home(BuildContext context, SidebarXController controller) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Color(0xFF4A90E2), canvasColor], // Gradient de bleu
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //       ),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           const SizedBox(height: 40), // Augmenter l'espace avant le tableau de bord
  //           _buildDashboard(), // Tableau de bord financier
  //           const SizedBox(height: 20),
  //           Expanded(
  //             child: ListView(
  //               children: [
  //                 FeatureCard(
  //                   icon: Icons.account_balance_wallet,
  //                   title: 'Transactions',
  //                   description: 'Gérer et consulter les transactions financières.',
  //                   onPressed: () {
  //                     setState(() {
  //                       controller.selectIndex(4);
  //                     });
  //                   },
  //                 ),
  //                 FeatureCard(
  //                   icon: Icons.receipt_long,
  //                   title: 'Rapports Financiers',
  //                   description: 'Consulter les rapports financiers et générer des exports.',
  //                   onPressed: () {
  //                     setState(() {
  //                       controller.selectIndex(5);
  //                     });
  //                   },
  //                 ),
  //                 FeatureCard(
  //                   icon: Icons.payment,
  //                   title: 'Paiements',
  //                   description: 'Suivi des paiements en attente et des reçus.',
  //                 onPressed: () {
  //                     setState(() {
  //                       controller.selectIndex(6);
  //                     });
  //                   },
  //                 ),
  //                 // Nouvelle carte pour la gestion des factures
  //                 FeatureCard(
  //                   icon: Icons.description,
  //                   title: 'Factures',
  //                   description: 'Gérer et générer les factures clients.',
  //                   onPressed: () {
  //                     setState(() {
  //                       controller.selectIndex(7);
  //                     });
  //                   },
  //                 ),
  //                 FeatureCard(
  //                   icon: Icons.school,
  //                   title: 'Fiche d\'inscription',
  //                   description:
  //                       'Creer des fiches d\'inscription pour les étudiants.',
  //                   onPressed: () {
  //                     setState(() {
  //                       controller.selectIndex(8);
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Tableau de bord affichant des informations clés
  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Dashboarditem(
            label: "Solde",
            value: formatCurrency(solde.ceilToDouble()),
            color: Colors.cyan,
            icon: Icons.monetization_on,
            textOnButton: "Consulter les rapports financiers",
            onPressed: () {
              // Navigator.push(
              //   context, MaterialPageRoute(
              //     builder: (context) => StudentsScreen()
              //   ),
              // );
            },
          ),
          Dashboarditem(
            label: "Paiement Etudiants",
            value: formatCurrency(paiementRecu),
            color: Colors.orangeAccent,
            icon: Icons.money_rounded,
            textOnButton: "Consulter les Factures",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacturePage(
                      home: AccountantScreen(),
                    ),
                  ),
              );
            },
          ),
          Dashboarditem(
            label: "Paiements effectués",
            value: formatCurrency(paiementEffectue),
            color: Colors.pink,
            icon: Icons.payment,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaiementPage(),
                  ),
              );
            },
          ),
          Dashboarditem(
            label: "Etudiant en retard de Paiment",
            value: "$retardDePaiement",
            color: Colors.blueGrey,
            icon: Icons.person_3_outlined,
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => StudentsScreen(
                    home: AccountantScreen(),
                  )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
