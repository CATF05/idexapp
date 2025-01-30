import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/transaction_model.dart';
import 'package:frontend/screens/comptable/account_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/dashboardItem.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:intl/intl.dart';
import 'package:sidebarx/sidebarx.dart';

class TransactionPage extends StatelessWidget {
  Widget home;
  TransactionPage({super.key, required this.home});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(
            controller: _controller,
            home: home,
          ),
          const Expanded(
            child: TransactionPageHome(),
          ),
        ],
      ),
    );
  }
}

class TransactionPageHome extends StatefulWidget {
  const TransactionPageHome({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionPageHomeState();
}

class _TransactionPageHomeState extends State<TransactionPageHome> {
  List<TransactionModel> transactions = []; // Liste fictive des transactions
  List<TransactionModel> initialTransactions =
      []; // Liste fictive des transactions
  double totalIncome = 0;
  double totalExpenses = 0;

  void fetchData() async {
    transactions = [];
    initialTransactions = [];
    // totalIncome = 0;
    // totalExpenses = 0;
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('transactions').get();
      for (var p in querySnapshot.docs) {
        setState(() {
          final tm = TransactionModel.fromMap(p.data());
          transactions.add(tm);
          initialTransactions.add(tm);
          // tm.type == "Revenu" ? totalIncome += tm.montant : totalExpenses += tm.montant;
        });
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final lesRevenus = transactions.where((t)=>t.type=="Revenu");
    final lesDepenses = transactions.where((t)=>t.type!="Revenu");
    if (lesRevenus.isNotEmpty) {
      totalIncome = lesRevenus.map((t)=>t.montant).reduce((a,b)=>a+b);
    }
    if (lesDepenses.isNotEmpty) {
      totalIncome = lesDepenses.map((t)=>t.montant).reduce((a,b)=>a+b);
    }
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Transactions", style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildStatistics(),
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
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Dashboarditem(
          label: "Solde",
          value: formatCurrency((totalExpenses - totalIncome).ceilToDouble()),
          color: Colors.blue,
          icon: Icons.money_rounded,
        ),
        Dashboarditem(
          label: "Revenus",
          value: formatCurrency(totalIncome),
          color: Colors.green,
          icon: Icons.monetization_on,
        ),
        Dashboarditem(
          label: "Dépenses",
          value: formatCurrency(totalExpenses),
          color: Colors.redAccent,
          icon: Icons.payment,
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(
            transaction.type == "Revenu"
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: transaction.type == "Revenu" ? Colors.green : Colors.red,
          ),
          title: Text(transaction.description),
          subtitle: Text(
            "Montant : ${formatCurrency(transaction.montant)}\nDate : ${transaction.date}",
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editTransaction(index),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => _deleteTransaction(index, transaction),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTransaction() {
    final _formKey = GlobalKey<FormState>();
    String? type;
    String? paymentMethod;
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ajouter une Transaction",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: paymentMethod,
                      validator: validationNotNull,
                      decoration: const InputDecoration(
                        labelText: "Type",
                        border: OutlineInputBorder(),
                      ),
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
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      validator: validateSomme,
                      decoration: const InputDecoration(
                        labelText: "Montant",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: paymentMethod,
                      validator: validationNotNull,
                      decoration: const InputDecoration(
                        labelText: "Mode de paiement",
                        border: OutlineInputBorder(),
                      ),
                      items: ["Wave", "Orange Money", "Carte Bancaire", "Espèces"]
                          .map((m) {
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
                    TextFormField(
                      controller: descriptionController,
                      validator: validationNotNull,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text:
                            selectedDate.toString().split(' ')[0],
                      ),
                      onTap: () async {
                        DateTime? pickedDate =
                            await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setModalState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          TransactionModel transactionModel = TransactionModel(
                            idTransaction: generateIdStudent('TR', 5),
                            type: type!,
                            description: descriptionController.text,
                            montant: double.parse(amountController.text),
                            moyenDePaiement: paymentMethod!,
                            date: selectedDate,
                          );
                          setState(() {
                            // transactions.add({
                            //   "type": type,
                            //   "amount": double.parse(amountController.text),
                            //   "paymentMethod": paymentMethod,
                            //   "description": descriptionController.text,
                            //   "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            // });
                            transactions.add(transactionModel);
                          });
            
                          await FirebaseFirestore.instance
                              .collection('transactions')
                              .doc(transactionModel.idTransaction)
                              .set(transactionModel.toMap());
            
                            showSnackBar(context, "Transaction effectué");
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Ajouter"),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _editTransaction(int index) {
    // Logique de modification
  }

  void _deleteTransaction(int index, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Supprimer la transaction"),
          content: const Text("Etes vous sur de vouloir supprimer la transaction ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  transactions.removeAt(index);
                });
                await FirebaseFirestore.instance
                  .collection('transactions')
                  .doc(transaction.idTransaction)
                  .delete();

                showSnackBar(context, "Transaction supprimée");
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
            ),
          ],
        );
      }
    );
  }
}
