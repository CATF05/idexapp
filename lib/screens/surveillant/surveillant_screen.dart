import 'package:flutter/material.dart';
import 'package:frontend/common_pages/fiche_inscription.dart';
import 'package:frontend/screens/DE/pages/gestion_cours.dart';
import 'package:frontend/screens/surveillant/pages/evenements.dart';
import 'package:frontend/widgets/feature_card.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class SurveillantGeneralScreen extends StatelessWidget {
  SurveillantGeneralScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: SurveillantGeneralScreen(),),
          Expanded(
            child: SurveillantHome(
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}


class SurveillantHome extends StatefulWidget {
  final SidebarXController controller;
  const SurveillantHome({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SurveillantHome> createState() => _SurveillantHomeState();
}

class _SurveillantHomeState extends State<SurveillantHome> {
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
            const SizedBox(height: 40), // Espacement avant le tableau de bord
            _buildDashboard(), // Tableau de bord du surveillant général
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  FeatureCard(
                    icon: Icons.book,
                    title: 'Gestion des Cours',
                    description: 'Gérer les cours et les affectations.',
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => GestionCours(home: SurveillantGeneralScreen(),)
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.assessment,
                    title: 'Suivi des Événements',
                    description: 'Suivi des événements importants et anomalies.',
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => Evenements(home: SurveillantGeneralScreen(),)
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.room,
                    title: 'Gestion des Salles',
                    description: 'Surveiller et gérer les affectations de salles.',
                    onPressed: () {
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder: (context) => ()
                      //   ),
                      // );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.person_add,
                    title: 'Enregistrement des Étudiants',
                    description: 'Ajouter un nouvel étudiant au système.',
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => InscriptionEtudiantScreen(
                            home: SurveillantGeneralScreen(),
                          )
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.report,
                    title: 'Rapports',
                    description: 'Consulter les rapports des surveillants.',
                    onPressed: () {
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder: (context) => ()
                      //   ),
                      // );
                    },
                  ),
                  // Ajout des boutons pour l'enregistrement des étudiants et la création des badges
                  FeatureCard(
                    icon: Icons.card_membership,
                    title: 'Création des Badges',
                    description: 'Créer des badges électroniques pour les étudiants.',
                    onPressed: () {
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder: (context) => ()
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

  // Tableau de bord avec les informations clés du surveillant
  Widget _buildDashboard() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tableau de Bord',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Présences Actuelles', '100/200'),
                _dashboardItem('Salles Occupées', '12/15'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Événements Critiques', '5'),
                _dashboardItem('Rapports Générés', '8'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget représentant un item du tableau de bord
  Widget _dashboardItem(String title, String value) {
    return GestureDetector(
      onTap: () {
        // Ajouter une action ici si nécessaire
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}