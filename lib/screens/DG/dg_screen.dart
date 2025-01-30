import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/models/facture_model.dart';
import 'package:frontend/screens/DG/pages/employees.dart';
import 'package:frontend/screens/DG/pages/notifications.dart';
import 'package:frontend/screens/DG/pages/profs.dart';
import 'package:frontend/common_pages/fiche_inscription.dart';
import 'package:frontend/common_pages/factures.dart';
import 'package:frontend/common_pages/students.dart';
import 'package:frontend/screens/comptable/pages/transactions.dart';
import 'package:frontend/screens/secretaire/pages/emploie_dutemps.dart';
import 'package:frontend/widgets/dashboardItem.dart';
import 'package:frontend/widgets/feature_card.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class DGScreen extends StatelessWidget {
  DGScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: DGScreen(),
            notif: NotificationsDGScreen(),
          ),
          const Expanded(
            child: DirGeneralHome(),
          ),
        ],
      ),
    );
  }
}

class DirGeneralHome extends StatefulWidget {
  const DirGeneralHome({super.key});

  @override
  State<DirGeneralHome> createState() => _DirGeneralHomeState();
}

class _DirGeneralHomeState extends State<DirGeneralHome> {
  int nbEtudiant = 0;
  int nbFactureInvalide = 0;
  int nbEvents = 0;
  int nbEmployees = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Recupération etudiants
    try {
      final querySnapshot1 =
          await FirebaseFirestore.instance.collection('students').get();
      setState(() {
        nbEtudiant = querySnapshot1.docs.length;
      });
    } catch (e) {
      debugPrint('Erreur recupération etudiants: $e');
    }

    // Recupération evenements
    try {
      List<EventModel> events = <EventModel>[];
      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('events').get();
      for (var f in querySnapshot2.docs) {
        events.add(EventModel.fromMap(f.data()));
      }
      setState(() {
        nbEvents = events
            .where((e) => (e.from.year == DateTime.now().year &&
                e.from.month == DateTime.now().month &&
                e.from.day == DateTime.now().day))
            .length;
      });
    } catch (e) {
      debugPrint('Erreur recupération evenements: $e');
    }

    // Recupération factures
    try {
      List<FactureModel> facturesInvalides = [];
      final querySnapshot3 =
          await FirebaseFirestore.instance.collection('factures').get();
      nbFactureInvalide = querySnapshot3.docs.length;
      if (querySnapshot3.docs.isNotEmpty) {
        for (var f in querySnapshot3.docs) {
          if (!FactureModel.fromMap(f.data()).isValidate) {
            facturesInvalides.add(FactureModel.fromMap(f.data()));
          }
        }
      }
      setState(() {
        nbFactureInvalide = facturesInvalides.length;
      });
    } catch (e) {
      debugPrint('Erreur recupération factures: $e');
    }

    // Recupération employes
    try {
      final querySnapshot4 =
          await FirebaseFirestore.instance.collection('employes').get();
      setState(() {
        nbEmployees = querySnapshot4.docs.length;
      });
    } catch (e) {
      debugPrint('Erreur recupération employes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF004080)],
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
                    icon: Icons.analytics,
                    title: 'Mon emploi du temps',
                    description: 'Gérer et suivre mes rendez-vous et activités',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmploiDuTemps(
                            home: DGScreen(),
                          ),
                        ),
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
                            home: DGScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.person_search,
                    title: 'Gestion des Professeurs',
                    description:
                        'Gérer les informations et emplois des professeurs.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfsScreen(
                            home: DGScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  // FeatureCard(
                  //   icon: Icons.person,
                  //   title: 'Gestion des Employés',
                  //   description: 'Gérer le personnel et les rôles.',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => EmployesScreen(
                  //             home: DGScreen(),
                  //           )),
                  //     );
                  //   },
                  // ),
                  FeatureCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Rapports Financiers',
                    description:
                        'Consulter et générer les rapports financiers.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPage(
                            home: DGScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  // FeatureCard(
                  //   icon: Icons.insights,
                  //   title: 'Analyses de Performance',
                  //   description: 'Évaluer les performances de l\'entreprise.',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => AnalysePageScreen()),
                  //     );
                  //   },
                  // ),
                  // FeatureCard(
                  //   icon: Icons.schedule,
                  //   title: 'Planification Stratégique',
                  //   description: 'Planifier les stratégies à long terme.',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => StrategicPlanningScreen()),
                  //     );
                  //   },
                  // ),
                  // FeatureCard(
                  //   icon: Icons.file_copy,
                  //   title: 'Bulletins de Salaire',
                  //   description: 'Gérer et consulter les bulletins de salaire.',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => BulletinSalaireScreen()),
                  //     );
                  //   },
                  // ),
                  // FeatureCard(
                  //   icon: Icons.bar_chart,
                  //   title: 'Indicateurs Clés',
                  //   description: 'Suivre les KPI de l\'entreprise.',
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => IndicateursScreen()),
                  //     );
                  //   },
                  // ),
                  FeatureCard(
                    icon: Icons.book,
                    title: 'Rapport Pédagogique',
                    description:
                        """Accéder aux rapports et 
                        statistiques pédagogiques.""",
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => RapportPedagogiqueScreen()),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Dashboarditem(
            label: "Etudiants",
            value: "$nbEtudiant",
            color: Colors.cyan,
            icon: Icons.school_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentsScreen(
                    home: DGScreen(),
                  ),
                ),
              );
            },
          ),
          Dashboarditem(
            label: "Evénements de la journée",
            value: "$nbEvents",
            color: Colors.orangeAccent,
            icon: Icons.schedule,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmploiDuTemps(
                    home: DGScreen(),
                  ),
                ),
              );
            },
          ),
          // Dashboarditem(
          //   label: "Professeurs",
          //   value: "$nbProfs",
          //   color: Colors.orangeAccent,
          //   icon: Icons.person_search_outlined,
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => ProfsScreen(
          //                 home: DGScreen(),
          //               )),
          //     );
          //   },
          // ),
          Dashboarditem(
            label: "Employées",
            value: "$nbEmployees",
            color: Colors.blueGrey,
            icon: Icons.person_3_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployesScreen(
                    home: DGScreen(),
                  ),
                ),
              );
            },
          ),
          Dashboarditem(
            label: "Factures non validées",
            value: "$nbFactureInvalide",
            color: Colors.pink,
            icon: Icons.description,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacturePage(
                    home: DGScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
