import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final List<Map<String, dynamic>> transactions = []; // Liste fictive des transactions
  double totalIncome = 0;
  double totalExpenses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportTransactions,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Statistiques",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatistics(),
            const SizedBox(height: 20),
            const Text(
              "Liste des Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard("Revenus", totalIncome, Colors.green),
        _buildStatCard("Dépenses", totalExpenses, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, double amount, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "${amount.toStringAsFixed(2)} FCFA",
              style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(
            transaction['type'] == "Revenu" ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction['type'] == "Revenu" ? Colors.green : Colors.red,
          ),
          title: Text(transaction['description']),
          subtitle: Text(
            "Montant : ${transaction['amount']} FCFA\nDate : ${transaction['date']}",
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTransaction(index),
          ),
          onLongPress: () => _deleteTransaction(index),
        );
      },
    );
  }

  void _addTransaction() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String? type;
        String? paymentMethod;
        TextEditingController amountController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ajouter une Transaction",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: type,
                hint: const Text("Type"),
                items: ["Revenu", "Dépense"].map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Montant"),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: paymentMethod,
                hint: const Text("Mode de paiement"),
                items: ["Wave", "Orange Money", "Carte Bancaire", "Espèces"].map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    transactions.add({
                      "type": type,
                      "amount": double.parse(amountController.text),
                      "paymentMethod": paymentMethod,
                      "description": descriptionController.text,
                      "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editTransaction(int index) {
    // Logique de modification
  }

  void _deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  void _exportTransactions() {
    // Logique d'exportation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transactions exportées avec succès")),
    );
  }
}
