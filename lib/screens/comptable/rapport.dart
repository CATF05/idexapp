import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RapportPage extends StatefulWidget {
  @override
  _RapportPageState createState() => _RapportPageState();
}

class _RapportPageState extends State<RapportPage> {
  DateTimeRange? selectedDateRange;
  String? selectedTransactionType;
  String? selectedPaymentMethod;
  final List<Map<String, dynamic>> transactions = []; // Liste fictive des transactions
  double totalIncome = 0;
  double totalExpenses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapports Financiers"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filtres",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(selectedDateRange == null
                        ? "Sélectionner une période"
                        : "${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}"),
                    onPressed: _selectDateRange,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedTransactionType,
                  hint: const Text("Type de transaction"),
                  items: ["Revenus", "Dépenses", "Tous"].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTransactionType = value;
                    });
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  hint: const Text("Mode de paiement"),
                  items: ["Wave", "Orange Money", "Carte Bancaire", "Espèces"].map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Statistiques",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatistics(),
            const SizedBox(height: 20),
            const Text(
              "Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTransactionTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard("Total Revenus", totalIncome, Colors.green),
        _buildStatCard("Total Dépenses", totalExpenses, Colors.red),
        _buildStatCard("Solde Net", totalIncome - totalExpenses, Colors.blue),
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

  Widget _buildTransactionTable() {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(
            transaction['type'] == "Revenus" ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction['type'] == "Revenus" ? Colors.green : Colors.red,
          ),
          title: Text("${transaction['description']}"),
          subtitle: Text(
            "Montant : ${transaction['amount']} FCFA\nDate : ${transaction['date']}",
          ),
          trailing: Text(
            transaction['type'],
            style: TextStyle(
              color: transaction['type'] == "Revenus" ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }

  void _selectDateRange() async {
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (range != null) {
      setState(() {
        selectedDateRange = range;
      });
    }
  }

  void _exportReport() {
    // Logique d'exportation en PDF ou Excel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rapport exporté avec succès")),
    );
  }
}
