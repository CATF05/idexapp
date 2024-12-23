import 'package:flutter/material.dart';
import 'package:frontend/screens/DG/analyse.dart';
import 'package:frontend/screens/DG/audit.dart';
import 'package:frontend/screens/DG/bulletins_salaires.dart';
import 'package:frontend/screens/DG/indicateurs.dart';
import 'package:frontend/screens/DG/strategique_screen.dart';
import 'package:frontend/screens/secretaire/fiche_inscription.dart';

class DGScreen extends StatelessWidget {
  const DGScreen({Key? key}) : super(key: key);

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
              'MAMADOU NDIAYE',
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
                    DGFeatureCard(
                      icon: Icons.person,
                      title: 'Gestion des Employés',
                      description: 'Gérer le personnel et les rôles.',
                      onPressed: () {
                        // Action pour la gestion des employés
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Rapports Financiers',
                      description:
                          'Consulter et générer les rapports financiers.',
                      onPressed: () {
                        // Action pour rapports financiers
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.insights,
                      title: 'Analyses de Performance',
                      description: 'Évaluer les performances de l\'entreprise.',
                      onPressed: () {
                        // Action pour analyses de performance
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnalysePage()),
                        );
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.schedule,
                      title: 'Planification Stratégique',
                      description: 'Planifier les stratégies à long terme.',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StrategicPlanningPage()),
                        );
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.analytics,
                      title: 'Audit et Conformité',
                      description: 'Vérifier les processus et la conformité.',
                      onPressed: () {
                        // Action pour audit et conformité
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuditConformitePage()),
                        );
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.file_copy,
                      title: 'Bulletins de Salaire',
                      description:
                          'Gérer et consulter les bulletins de salaire.',
                      onPressed: () {
                        // Action pour bulletins de salaire
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BulletinPage()),
                        );
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.bar_chart,
                      title: 'Indicateurs Clés',
                      description: 'Suivre les KPI de l\'entreprise.',
                      onPressed: () {
                        // Action pour indicateurs clés
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndicateurPage()),
                        );
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.person_search,
                      title: 'Gestion des Professeurs',
                      description:
                          'Gérer les informations et emplois des professeurs.',
                      onPressed: () {
                        // Action pour gestion des professeurs
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.book,
                      title: 'Rapport Pédagogique',
                      description:
                          'Accéder aux rapports et statistiques pédagogiques.',
                      onPressed: () {
                        // Action pour rapport pédagogique
                      },
                    ),
                    DGFeatureCard(
                      icon: Icons.school,
                      title: 'Fiche d\'inscription',
                      description:
                          'Creer des fiches d\'inscription pour les étudiants.',
                      onPressed: () {
                        // Action pour rapport pédagogique
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>RegistrationFormPage()),
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
                _dashboardItem('Etudiants', '120/150'),
                _dashboardItem('Rapports ', 'Mise à jour'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Employés', '50'),
                _dashboardItem('Nouveaux Inscrits', '25'),
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
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DGFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const DGFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)), // Splash color
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          subtitle: Text(description, style: const TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
