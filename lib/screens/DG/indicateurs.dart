import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Utilisé pour les graphiques

class IndicateurPage extends StatefulWidget {
  @override
  _IndicateurPageState createState() => _IndicateurPageState();
}

class _IndicateurPageState extends State<IndicateurPage> {
  // Liste d'exemple de KPI de l'entreprise (données fictives)
  List<Map<String, dynamic>> kpiData = [
    {'month': 'Jan', 'revenue': 30000, 'profit': 5000},
    {'month': 'Feb', 'revenue': 32000, 'profit': 6000},
    {'month': 'Mar', 'revenue': 31000, 'profit': 5500},
    {'month': 'Apr', 'revenue': 35000, 'profit': 7000},
    {'month': 'May', 'revenue': 33000, 'profit': 6000},
    {'month': 'Jun', 'revenue': 34000, 'profit': 6500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suivi des Indicateurs"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Indicateurs Clés de Performance (KPI)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildKpiChart(),
            const SizedBox(height: 20),
            const Text(
              "Résumé des KPI",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: kpiData.length,
                itemBuilder: (context, index) {
                  var kpi = kpiData[index];
                  return Card(
                    child: ListTile(
                      title: Text("Mois: ${kpi['month']}"),
                      subtitle: Text(
                          "Revenue: ${kpi['revenue']} | Profit: ${kpi['profit']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Affiche le graphique des KPI
  Widget _buildKpiChart() {
    List<FlSpot> revenueSpots = [];
    List<FlSpot> profitSpots = [];
    for (var kpi in kpiData) {
      revenueSpots.add(FlSpot(kpiData.indexOf(kpi).toDouble(), kpi['revenue'].toDouble()));
      profitSpots.add(FlSpot(kpiData.indexOf(kpi).toDouble(), kpi['profit'].toDouble()));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: kpiData.length.toDouble() - 1,
          minY: 0,
          maxY: 40000,
          lineBarsData: [
            LineChartBarData(
              spots: revenueSpots,
              isCurved: true,
              color: Colors.blueAccent,
              belowBarData: BarAreaData(show: true,
              color: Colors.blue.shade200),
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: profitSpots,
              isCurved: true,
              color: Colors.greenAccent,
              belowBarData: BarAreaData(show: true, color: 
              Colors.green.shade200),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
