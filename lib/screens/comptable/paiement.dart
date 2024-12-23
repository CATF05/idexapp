import 'package:flutter/material.dart';

class PaiementPage extends StatefulWidget {
  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  String? selectedPaymentMethod;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final List<Map<String, dynamic>> paymentHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showPaymentHistory();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mode de Paiement",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentMethods(),
            const SizedBox(height: 20),
            const Text(
              "Détails du Paiement",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant à payer",
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: recipientController,
              decoration: const InputDecoration(
                labelText: "Destinataire (Nom ou Téléphone)",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmPayment,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Confirmer le Paiement"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = ["Wave", "Orange Money", "Carte Bancaire", "Espèces"];
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: paymentMethods.map((method) {
        return ChoiceChip(
          label: Text(method),
          selected: selectedPaymentMethod == method,
          onSelected: (selected) {
            setState(() {
              selectedPaymentMethod = selected ? method : null;
            });
          },
          selectedColor: Colors.teal,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: selectedPaymentMethod == method ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  void _confirmPayment() {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir un mode de paiement")),
      );
      return;
    }

    if (amountController.text.isEmpty || recipientController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final String recipient = recipientController.text;

    // Simuler la confirmation de paiement
    setState(() {
      paymentHistory.add({
        "method": selectedPaymentMethod,
        "amount": amount,
        "recipient": recipient,
        "date": DateTime.now().toString(),
        "status": "Réussi",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Paiement de $amount FCFA effectué via $selectedPaymentMethod")),
    );

    // Réinitialiser les champs
    amountController.clear();
    recipientController.clear();
    setState(() {
      selectedPaymentMethod = null;
    });
  }

  void _showPaymentHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Historique des Paiements"),
          content: SizedBox(
            width: double.maxFinite,
            child: paymentHistory.isEmpty
                ? const Text("Aucun paiement effectué.")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: paymentHistory.length,
                    itemBuilder: (context, index) {
                      final payment = paymentHistory[index];
                      return ListTile(
                        leading: Icon(
                          Icons.payment,
                          color: payment['status'] == "Réussi" ? Colors.green : Colors.red,
                        ),
                        title: Text("${payment['method']} - ${payment['recipient']}"),
                        subtitle: Text("Montant : ${payment['amount']} FCFA\nDate : ${payment['date']}"),
                        trailing: Text(
                          payment['status'],
                          style: TextStyle(
                            color: payment['status'] == "Réussi" ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}
