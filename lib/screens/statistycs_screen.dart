import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrowthChartsScreen extends StatelessWidget {
  // Datos simulados para los gráficos
  final List<FlSpot> pesoData = [
    FlSpot(1, 14.0),
    FlSpot(2, 15.0),
    FlSpot(3, 16.0),
    FlSpot(4, 16.5),
    FlSpot(5, 17.0),
  ];

  final List<FlSpot> tallaData = [
    FlSpot(1, 80.0),
    FlSpot(2, 82.0),
    FlSpot(3, 85.0),
    FlSpot(4, 87.0),
    FlSpot(5, 90.0),
  ];

  final double porcentajeSano = 70;
  final double porcentajeNoSano = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos de Crecimiento'),
        backgroundColor: const Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Peso por Mes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildLineChart(pesoData, 'Peso (kg)'),
              const SizedBox(height: 24),
              const Text(
                'Talla por Mes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildLineChart(tallaData, 'Talla (cm)'),
              const SizedBox(height: 24),
              const Text(
                'Detecciones Realizadas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  // Construye un gráfico lineal
  Widget _buildLineChart(List<FlSpot> data, String yLabel) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          minX: 1,
          maxX: 5,
          minY: 10,
          maxY: 20,
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              barWidth: 3,
              color: const Color(0xFF83B56A),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  // Construye un gráfico circular tipo dona
  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              value: porcentajeSano,
              color: Colors.green,
              title: '${porcentajeSano.toStringAsFixed(1)}%',
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: porcentajeNoSano,
              color: Colors.red,
              title: '${porcentajeNoSano.toStringAsFixed(1)}%',
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
