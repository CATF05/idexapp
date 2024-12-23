import 'package:flutter/material.dart';
import 'package:frontend/screens/comptable/facture.dart';
import 'package:frontend/screens/comptable/paiement.dart';
import 'package:frontend/screens/comptable/rapport.dart';
import 'package:frontend/screens/comptable/transaction.dart';
import 'package:frontend/screens/secretaire/secretaire.dart';

class AccountantScreen extends StatelessWidget {
  const AccountantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.white), // Icône représentant la finance
            const SizedBox(width: 8),
            const Text(
              'AÏTA GUEYE SARR',
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
              // Remplacez 'SecretaireScreen()' par le nom de la page de secrétaire
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecretaryScreen()),
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
            colors: [Color(0xFF4A90E2), Color(0xFF004080)], // Gradient de bleu
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
              _buildDashboard(), // Tableau de bord financier
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    AccountantFeatureCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Transactions',
                      description: 'Gérer et consulter les transactions financières.',
                    onPressed: () {
                        // Naviguer vers l'écran des transactions
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionPage()),
              );
                        
                      },
                    ),
                    AccountantFeatureCard(
                      icon: Icons.receipt_long,
                      title: 'Rapports Financiers',
                      description: 'Consulter les rapports financiers et générer des exports.',
                      onPressed: () {
                        // Naviguer vers l'écran des rapports financiers
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RapportPage()),
              );
                      },
                    ),
                    AccountantFeatureCard(
                      icon: Icons.payment,
                      title: 'Paiements',
                      description: 'Suivi des paiements en attente et des reçus.',
                    onPressed: () {
                        // Naviguer vers l'écran des paiements
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaiementPage()),
              );
                      },
                    ),
                    // Nouvelle carte pour la gestion des factures
                    AccountantFeatureCard(
                      icon: Icons.description,
                      title: 'Factures',
                      description: 'Gérer et générer les factures clients.',
                      onPressed: () {
                        // Naviguer vers l'écran des factures
                        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FacturePage()),
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

  // Tableau de bord affichant des informations clés
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
            Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Total Transactions', 'FCFA 500,000'),
                _dashboardItem('Paiements Recus', 'FCFA 800,000'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardItem('Solde Actuel', 'FCFA 100,000'),
                _dashboardItem('Dépenses', 'FCFA 100,200'),
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
        // Ajoutez une action ici si nécessaire
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              offset: Offset(2, 4),
              blurRadius: 6,
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
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

class AccountantFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onPressed;

  AccountantFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(
        onPressed: onPressed,
          style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Splash color
        ),
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
