import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/common_pages/fiche_inscription.dart';
import 'package:frontend/screens/secretaire/pages/demandes.dart';
import 'package:frontend/screens/secretaire/pages/emploie_dutemps.dart';
import 'package:frontend/widgets/dashboardItem.dart';
import 'package:frontend/widgets/feature_card.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class SecretaryScreen extends StatelessWidget {
  SecretaryScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: SecretaryScreen(),
          ),
          Expanded(
            child: SecretaireHome(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}

class SecretaireHome extends StatefulWidget {
  final SidebarXController controller;
  const SecretaireHome({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SecretaireHome> createState() => _SecretaireHomeState();
}

class _SecretaireHomeState extends State<SecretaireHome> {
  int nbAbscences = 0;
  int eventsToday = 0;
  int demandesEnAttente = 0;
  int messageNonLus = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final querySnapshot1 =
          await FirebaseFirestore.instance.collection('events').get();
      for(var event in querySnapshot1.docs) {
        final e = EventModel.fromMap(event.data());
        if (e.from.year == DateTime.now().year &&
            e.from.month == DateTime.now().month &&
            e.from.day == DateTime.now().day) {
          setState(() {
            eventsToday++;
          });
        }
      }
    } catch (e) {
      debugPrint('Erreur recuperations evenements: $e');
    }

    try{

      final querySnapshot2 =
          await FirebaseFirestore.instance.collection('demandes_secretaire')
          .where('repondu', isEqualTo: false)
          .get();
      demandesEnAttente = querySnapshot2.docs.length;

      setState(() {});
    } catch (e) {
      debugPrint('Erreur recuperations demandes envoyé a la secretaire: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF004080)], // Dégradé de bleu
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                height: 40), // Augmenter l'espace avant le tableau de bord
            _buildDashboard(), // Tableau de bord secrétaire
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  FeatureCard(
                    icon: Icons.schedule,
                    title: 'Emploi du temps',
                    description:
                        'Gérer et consulter l\'emploi du temps du directeur et du personnel.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmploiDuTemps(
                            home: SecretaryScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.request_page,
                    title: 'Demandes',
                    description:
                        'Suivre les demandes des étudiants et du personnel.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemandesScreen(
                            home: SecretaryScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  // FeatureCard(
                  //   icon: Icons.access_time,
                  //   title: 'Absences & Présences',
                  //   description:
                  //       'Enregistrer et consulter les absences et présences.',
                  //   onPressed: () {
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(
                  //     //     builder: (context) => (
                  //     //       home: SecretaryScreen(),
                  //     //     ),
                  //     //   ),
                  //     // );
                  //   },
                  // ),
                  FeatureCard(
                    icon: Icons.school,
                    title: 'Fiche d\'inscription',
                    description:
                        'Créer une fiche d\'inscription pour les etudiants',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InscriptionEtudiantScreen(
                            home: SecretaryScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.message,
                    title: 'Rapports',
                    description: 'Consulter les rapports d\'absences.',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => (
                      //       home: SecretaryScreen(),
                      //     ),
                      //   ),
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

  // Tableau de bord pour la secrétaire
  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Dashboarditem(
            label: "Evénements de la journée",
            value: "$eventsToday",
            color: Colors.cyan,
            icon: Icons.schedule,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmploiDuTemps(
                    home: SecretaryScreen(),
                  ),
                ),
              );
            },
          ),
          Dashboarditem(
            label: "Abscences aujourdh'hui",
            value: "$nbAbscences",
            color: Colors.orangeAccent,
            icon: Icons.person_search_outlined,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ProfsScreen(
              //             home: DGScreen(),
              //           )),
              // );
            },
          ),
          Dashboarditem(
            label: "Demandes en attentes",
            value: "$demandesEnAttente",
            color: Colors.blueGrey,
            icon: Icons.person_3_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DemandesScreen(
                    home: SecretaryScreen(),
                  ),
                ),
              );
            },
          ),
          Dashboarditem(
            label: "Messages non lus",
            value: "$messageNonLus",
            color: Colors.pink,
            icon: Icons.description,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => FacturePage(
              //             home: DGScreen(),
              //           )),
              // );
            },
          ),
        ],
      ),
    );
  }
}
