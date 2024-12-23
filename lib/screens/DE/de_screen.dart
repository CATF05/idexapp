import 'package:flutter/material.dart';
import 'package:frontend/screens/DE/attestation.dart';
import 'package:frontend/screens/DE/certification.dart';
import 'package:frontend/screens/DE/gestion_cours.dart';
import 'package:frontend/screens/DE/planification.dart';
import 'package:frontend/screens/DE/rapport_academique.dart';
import 'package:frontend/screens/DE/bulletin_releves.dart';
import 'package:frontend/screens/DG/dg_screen.dart';

class DirecteurEtudesScreen extends StatelessWidget {
  const DirecteurEtudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'OUSEYNOU DIANKHA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Naviguer vers les notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DGScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Naviguer vers les paramètres
              
            },
          ),
        ],
      ),
      body: Container(
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
                    DirecteurFeatureCard(
                      icon: Icons.group_add,
                      title: 'Enregistrement des Étudiants',
                      description: 'Ajouter et gérer les étudiants.',
                      onPressed: () {
                        // Action pour l'enregistrement des étudiants
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.badge,
                      title: 'Création des Badges',
                      description: 'Créer des badges électroniques pour les étudiants.',
                      onPressed: () {
                        // Action pour création de badges
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.book,
                      title: 'Gestion des Cours',
                      description: 'Gérer les cours et les affectations.',
                      onPressed: () {
                        // Action pour gestion des cours
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GestionCoursPage()),
              );
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.schedule,
                      title: 'Planification des Examens',
                      description: 'Planifier et organiser les examens.',
                      onPressed: () {
                        // Action pour planification des examens
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlanificationExamensPage()),
              );
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.assessment,
                      title: 'Rapports Académiques',
                      description: 'Consulter et générer des rapports académiques.',
                      onPressed: () {
                        // Action pour rapports académiques
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RapportsAcademiquePage()),
              );
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.file_copy,
                      title: 'Attestation',
                      description: 'Gérer et délivrer des attestations.',
                      onPressed: () {
                        // Action pour gestion des attestations
                      Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttestationPage()),
              );
                        
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.verified,
                      title: 'Certification',
                      description: 'Gérer et délivrer des certifications.',
                      onPressed: () {
                        // Action pour gestion des certifications
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CertificatPage()),
              );
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.school,
                      title: 'Diplômes',
                      description: 'Gérer et délivrer des diplômes.',
                      onPressed: () {
                        // Action pour gestion des diplômes
                      },
                    ),
                    DirecteurFeatureCard(
                      icon: Icons.bookmark,
                      title: 'Bulletins et Relevés de Notes',
                      description: 'Consulter et gérer les bulletins et relevés des étudiants.',
                      onPressed: () {
                        // Action pour consulter les bulletins
                          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BulletinPage()),
              );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

class DirecteurFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  DirecteurFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9), // Uniformiser la couleur
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child:ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Splash color
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blueAccent),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          subtitle: Text(description, style: const TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
