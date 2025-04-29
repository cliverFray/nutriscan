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
  bool detectionError = false; // Bandera para error en detecciones

  bool isLoading = false;
  String? errorMessage;
  double porcentajeNormal = 0;
  double porcentajeDesnutrido = 0;
  double porcentajeRiesgo = 0;

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
      detectionError = false; // Resetear bandera de error
    });

    try {
      final growth = await _statsService.fetchGrowthChartData(childId);

      if (growth.weights.isEmpty || growth.heights.isEmpty) {
        setState(() {
          errorMessage =
              'No hay suficientes datos para generar los gráficos de crecimiento.';
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
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Ocurrió un error al cargar los datos de crecimiento.';
      });
    }

    // Ahora intenta cargar el segundo gráfico aparte
    try {
      final List<DetectionResult> detections =
          await _statsService.fetchDetectionCategoryChart(childId);

      final normal = detections
          .firstWhere((d) => d.category.toLowerCase() == 'normal',
              orElse: () => DetectionResult(category: 'Normal', count: 0))
          .count;
      final desnutrido = detections
          .firstWhere((d) => d.category.toLowerCase() == 'con desnutrición',
              orElse: () =>
                  DetectionResult(category: 'Con desnutrición', count: 0))
          .count;
      final riesgo = detections
          .firstWhere(
              (d) => d.category.toLowerCase() == 'riesgo en desnutrición',
              orElse: () =>
                  DetectionResult(category: 'Riesgo en desnutrición', count: 0))
          .count;

      final total = normal + desnutrido + riesgo;
      if (total > 0) {
        setState(() {
          porcentajeNormal = (normal / total) * 100;
          porcentajeDesnutrido = (desnutrido / total) * 100;
          porcentajeRiesgo = (riesgo / total) * 100;
        });
      }
    } catch (e) {
      // Aquí puedes crear un error específico sólo para detecciones
      setState(() {
        detectionError = true; // Flag para indicar que hubo error
        porcentajeNormal = 0;
        porcentajeDesnutrido = 0;
        porcentajeRiesgo = 0;
      });
      // Opcional: podrías agregar un SnackBar para advertir que no se pudo cargar detecciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudieron cargar las detecciones.')),
      );
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

    double minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

    // Calcular intervalo automáticamente
    double interval = ((maxY - minY) / 5).clamp(1, double.infinity);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval, // Aquí se controla la separación
                reservedSize: 40, // Más espacio para los números
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.left,
                  );
                },
              ),
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
          minY: minY,
          maxY: maxY,
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

  Widget buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetectionPieChart() {
    if (detectionError) {
      return const Text(
          'No se pudieron cargar los datos de detección. Intenta nuevamente.');
    }

    if (porcentajeNormal == 0 &&
        porcentajeDesnutrido == 0 &&
        porcentajeRiesgo == 0) {
      return const Text(
          'No hay datos suficientes para mostrar el gráfico de detección.');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: porcentajeNormal,
                  title: '${porcentajeNormal.toStringAsFixed(1)}% Normal',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.redAccent,
                  value: porcentajeDesnutrido,
                  title:
                      '${porcentajeDesnutrido.toStringAsFixed(1)}% Desnutrido',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.orange,
                  value: porcentajeRiesgo,
                  title: '${porcentajeRiesgo.toStringAsFixed(1)}% Riesgo',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            buildLegendItem(Colors.green, 'Normal'),
            buildLegendItem(Colors.redAccent, 'Desnutrido'),
            buildLegendItem(Colors.orange, 'Riesgo'),
          ],
        ),
      ],
    );
  }
}
