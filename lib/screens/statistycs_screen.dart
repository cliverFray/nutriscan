import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/child.dart';
import '../models/detection_cat_chart.dart';
import '../models/growth_chart.dart';
import '../services/child_service.dart';
import '../services/statistycs_service.dart';

class GrowthChartsScreen extends StatefulWidget {
  @override
  _GrowthChartsScreenState createState() => _GrowthChartsScreenState();
}

class _GrowthChartsScreenState extends State<GrowthChartsScreen> {
  final ChildService _childService = ChildService();
  final StaticstycService _statsService = StaticstycService();

  List<Child> children = [];
  Child? selectedChild;

  List<FlSpot> pesoData = [];
  List<FlSpot> tallaData = [];
  double porcentajeSano = 0;
  double porcentajeNoSano = 0;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final fetchedChildren = await _childService.getChildren();
      setState(() {
        children = fetchedChildren;
        if (fetchedChildren.isNotEmpty) {
          selectedChild = fetchedChildren.first;
          _loadChartData(selectedChild!.childId!);
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar los niños.';
      });
    }
  }

  Future<void> _loadChartData(int childId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      pesoData = [];
      tallaData = [];
      porcentajeSano = 0;
      porcentajeNoSano = 0;
    });

    try {
      final growth = await _statsService.fetchGrowthChartData(childId);
      final List<DetectionResult> detections =
          await _statsService.fetchDetectionCategoryChart(childId);

      if (growth.weights.isEmpty || growth.heights.isEmpty) {
        setState(() {
          errorMessage =
              'No hay suficientes datos para generar los gráficos. Registre al menos un peso y una talla.';
        });
      } else {
        setState(() {
          pesoData = List.generate(
            growth.weights.length,
            (index) => FlSpot(index.toDouble(), growth.weights[index]),
          );
          tallaData = List.generate(
            growth.heights.length,
            (index) => FlSpot(index.toDouble(), growth.heights[index]),
          );

          final sano = detections
              .firstWhere((d) => d.category.toLowerCase() == 'sano',
                  orElse: () => DetectionResult(category: 'Sano', count: 0))
              .count;
          final noSano = detections
              .firstWhere((d) => d.category.toLowerCase() == 'no sano',
                  orElse: () => DetectionResult(category: 'No Sano', count: 0))
              .count;

          final total = sano + noSano;
          if (total > 0) {
            porcentajeSano = (sano / total) * 100;
            porcentajeNoSano = (noSano / total) * 100;
          }
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Ocurrió un error al cargar los gráficos. Intente nuevamente.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSelectChild(Child? child) {
    setState(() {
      selectedChild = child;
    });
    if (child != null && child.childId != null) {
      _loadChartData(child.childId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos de Crecimiento'),
        backgroundColor: const Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: children.isEmpty
            ? const Center(child: Text('No hay niños registrados.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona un niño',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField2<Child>(
                      isExpanded: true,
                      hint: const Text('Selecciona un niño'),
                      value: selectedChild,
                      items: children
                          .map((child) => DropdownMenuItem<Child>(
                                value: child,
                                child: Text(child.childName),
                              ))
                          .toList(),
                      onChanged: _onSelectChild,
                      buttonStyleData: const ButtonStyleData(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.black),
                          ),
                          color: Colors.white,
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Peso por Mes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildLineChart(pesoData, 'Peso (kg)'),
                          const SizedBox(height: 24),
                          const Text(
                            'Talla por Mes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildLineChart(tallaData, 'Talla (cm)'),
                          const SizedBox(height: 24),
                          const Text(
                            'Detecciones Realizadas',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildDetectionPieChart(),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> data, String yLabel) {
    if (data.isEmpty) return const Text('Sin datos disponibles.');

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          minX: data.first.x,
          maxX: data.last.x,
          minY: data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1,
          maxY: data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1,
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

  Widget _buildDetectionPieChart() {
    if (porcentajeSano == 0 && porcentajeNoSano == 0) {
      return Text(
          'No hay datos suficientes para mostrar el gráfico de detección.');
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: porcentajeSano,
              title: '${porcentajeSano.toStringAsFixed(1)}% Sano',
              radius: 60,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.redAccent,
              value: porcentajeNoSano,
              title: '${porcentajeNoSano.toStringAsFixed(1)}% No Sano',
              radius: 60,
              titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
