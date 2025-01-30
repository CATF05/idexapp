import 'package:flutter/material.dart';
import 'package:frontend/common_pages/students.dart';
import 'package:frontend/screens/DE/pages/attestation.dart';
import 'package:frontend/screens/DE/pages/certification.dart';
import 'package:frontend/screens/DE/pages/gestion_cours.dart';
import 'package:frontend/screens/DE/pages/notifications.dart';
import 'package:frontend/screens/DE/pages/parametre.dart';
import 'package:frontend/screens/DE/pages/planification.dart';
import 'package:frontend/screens/DE/pages/rapport_academique.dart';
import 'package:frontend/screens/DE/pages/bulletin_releves.dart';
import 'package:frontend/screens/DG/pages/profs.dart';
import 'package:frontend/widgets/feature_card.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class DirecteurEtudesScreen extends StatelessWidget {
  DirecteurEtudesScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DirecteurEtudesScreen(),),
          Expanded(
            child: DirEtudeHome(),
          ),
        ],
      ),
    );
  }
}

class DirEtudeHome extends StatefulWidget {
  const DirEtudeHome({super.key});


  @override
  State<DirEtudeHome> createState() => _DirEtudeHomeState();
}

class _DirEtudeHomeState extends State<DirEtudeHome> {
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
            const SizedBox(height: 40),
            _buildDashboard(),
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
                          builder: (context) => GestionCours(home: DirecteurEtudesScreen(),)
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.group_add,
                    title: 'Gestion des Étudiants',
                    description: 'Ajouter et gérer les étudiants.',
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => StudentsScreen(home: DirecteurEtudesScreen(),)
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.person_search,
                    title: 'Gestion des Professeurs',
                    description: 'Gérer les informations et emplois des professeurs.',
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ProfsScreen(home: DirecteurEtudesScreen(),)
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.bookmark,
                    title: 'Bulletins et Relevés de Notes',
                    description: 'Consulter et gérer les bulletins et relevés des étudiants.',
                    onPressed: () {
                      
                    },
                  ),
                  FeatureCard(
                    icon: Icons.schedule,
                    title: 'Planification des Examens',
                    description: 'Planifier et organiser les examens.',
                    onPressed: () {
                      // setState(() {
                      //   controller.selectIndex(7);
                      // });
                    },
                  ),
                  FeatureCard(
                    icon: Icons.assessment,
                    title: 'Rapports Académiques',
                    description: 'Consulter et générer des rapports académiques.',
                    onPressed: () {
                      // setState(() {
                      //   controller.selectIndex(8);
                      // });
                    },
                  ),
                  FeatureCard(
                    icon: Icons.file_copy,
                    title: 'Attestation',
                    description: 'Gérer et délivrer des attestations.',
                    onPressed: () {
                      // setState(() {
                      //   controller.selectIndex(9);
                      // });
                    },
                  ),
                  FeatureCard(
                    icon: Icons.verified,
                    title: 'Certification',
                    description: 'Gérer et délivrer des certifications.',
                    onPressed: () {
                      // setState(() {
                      //   controller.selectIndex(10);
                      // });
                    },
                  ),
                  FeatureCard(
                    icon: Icons.school,
                    title: 'Diplômes',
                    description: 'Gérer et délivrer des diplômes.',
                    onPressed: () {
                      // setState(() {
                      //   controller.selectIndex(11);
                      // });
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
    //         return const NotificationsDirEtude();
    //       case 2:
    //         return const ParametreDirEtude();
    //       case 4:
    //         return Container(); // Enregistrement des Étudiants
    //       case 5:
    //         return Container(); // Création des Badges
    //       case 6:
    //         return GestionCoursPage();
    //       case 7:
    //         return PlanificationExamensPage();
    //       case 8:
    //         return RapportsAcademiquePage();
    //       case 9:
    //         return AttestationPage();
    //       case 10:
    //         return CertificatPage();
    //       case 11:
    //         return Container(); // Diplômes
    //       case 12:
    //         return BulletinPage();
    //       default:
    //         return home(context, widget.controller);
    //     }
    //   },
    // );
  }

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
                _dashboardItem('Étudiants Enregistrés', '320/500'),
                _dashboardItem('Examens Planifiés', '5/10'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Badges Créés', '250'),
                _dashboardItem('Rapports Académiques', '12'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardItem(String title, String value) {
    return GestureDetector(
      onTap: () {
        // Action possible ici
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