import 'package:flutter/material.dart';
import 'package:frontend/screens/surveillant/surveillant_screen.dart';

class SecretaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.white), // Icône représentant une administration
            const SizedBox(width: 8),
            const Text(
              'Thérèze FATOU GUEYE',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurveillantGeneralScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
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
              SizedBox(height: 40), // Augmenter l'espace avant le tableau de bord
              _buildDashboard(), // Tableau de bord secrétaire
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    SecretaryFeatureCard(
                      icon: Icons.schedule,
                      title: 'Emploi du temps',
                      description: 'Gérer et consulter l\'emploi du temps des étudiants et du personnel.',
                      onTap: () {
                        // Naviguer vers l'écran de gestion de l'emploi du temps
                      },
                    ),
                    SecretaryFeatureCard(
                      icon: Icons.message,
                      title: 'Rapports',
                      description: 'Consulter les rapports d\'absences.',
                      onTap: () {
                        // Naviguer vers l'écran de messagerie
                      },
                    ),
                    SecretaryFeatureCard(
                      icon: Icons.access_time,
                      title: 'Absences & Présences',
                      description: 'Enregistrer et consulter les absences et présences.',
                      onTap: () {
                        // Naviguer vers l'écran de gestion des absences
                      },
                    ),
                    SecretaryFeatureCard(
                      icon: Icons.request_page,
                      title: 'Demandes',
                      description: 'Suivre les demandes des étudiants et du personnel.',
                      onTap: () {
                        // Naviguer vers l'écran de gestion des demandes
                      },
                    ),
                    SecretaryFeatureCard(
                      icon: Icons.school,
                      title: 'Fiche d\'inscription',
                      description: 'Créer une fiche d\'inscription pour les etudiants',
                      onTap: () {
                        // Naviguer vers l'écran de gestion des demandes
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

  // Tableau de bord pour la secrétaire
  Widget _buildDashboard() {
    return Card(
      color: Colors.white.withOpacity(0.95),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Tâches en attente', '3'),
                _dashboardItem('Absences aujourd\'hui', '5'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Demandes en attente', '2'),
                _dashboardItem('Messages non lus', '4'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget représentant un item du tableau de bord
  Widget _dashboardItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class SecretaryFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  SecretaryFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blueAccent,
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blueAccent),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          subtitle: Text(description, style: TextStyle(color: Colors.black54)),
        ),
      ),
    );
  }
}
