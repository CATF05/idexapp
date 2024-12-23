import 'package:flutter/material.dart';
import 'package:frontend/screens/DE/de_screen.dart';

class SurveillantGeneralScreen extends StatelessWidget {
  const SurveillantGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.white), // Icône représentant la sécurité
            SizedBox(width: 8),
            Text(
              'SAER NDIAYE',
              style: TextStyle(
                fontSize: 26,
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
              // Naviguer vers la page des notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DirecteurEtudesScreen()),
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
                    SurveillantFeatureCard(
                      icon: Icons.group,
                      title: 'Gestion des Présences',
                      description: 'Gérer et consulter les présences des employés.',
                      onTap: () {
                        // Naviguer vers la gestion des présences
                      },
                    ),
                    SurveillantFeatureCard(
                      icon: Icons.room,
                      title: 'Gestion des Salles',
                      description: 'Surveiller et gérer les affectations de salles.',
                      onTap: () {
                        // Naviguer vers la gestion des salles
                      },
                    ),
                    SurveillantFeatureCard(
                      icon: Icons.report,
                      title: 'Rapports',
                      description: 'Consulter les rapports des surveillants.',
                      onTap: () {
                        // Naviguer vers la page des rapports
                      },
                    ),
                    SurveillantFeatureCard(
                      icon: Icons.assessment,
                      title: 'Suivi des Événements',
                      description: 'Suivi des événements importants et anomalies.',
                      onTap: () {
                        // Naviguer vers la page de suivi des événements
                      },
                    ),
                    // Ajout des boutons pour l'enregistrement des étudiants et la création des badges
                    SurveillantFeatureCard(
                      icon: Icons.person_add,
                      title: 'Enregistrement des Étudiants',
                      description: 'Ajouter un nouvel étudiant au système.',
                      onTap: () {
                        // Naviguer vers la page d'enregistrement des étudiants
                      },
                    ),
                    SurveillantFeatureCard(
                      icon: Icons.card_membership,
                      title: 'Création des Badges',
                      description: 'Créer des badges électroniques pour les étudiants.',
                      onTap: () {
                        // Naviguer vers la page de création des badges
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

class SurveillantFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  SurveillantFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.blueAccent,
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
