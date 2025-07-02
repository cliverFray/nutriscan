import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nutriscan/screens/manage_child_profile_screen.dart';
import '../models/child.dart';
import '../models/detection_cat_chart.dart';
import '../models/growth_chart.dart';
import '../services/child_service.dart';
import '../services/statistycs_service.dart';

import 'package:intl/intl.dart';

import '../widgets/custom_elevated_buton.dart';
import 'edit_child_profile_screen.dart';
import 'register_child_screen.dart';

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

  List<DateTime> fechas = []; // Lista de fechas

  double porcentajeSano = 0;
  double porcentajeNoSano = 0;
  bool detectionError = false; // Bandera para error en detecciones

  bool isLoading = false;
  String? errorMessage;
  double porcentajeNormal = 0;
  double porcentajeDesnutrido = 0;
  double porcentajeRiesgo = 0;

  bool growthError = false; // en lugar de usar solo errorMessage
  String? growthErrorMessage;

  int? nnormal;
  int? nriesgo;
  int? ndesnutrido;

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
      fechas = []; // Limpiar lista de fechas
      porcentajeSano = 0;
      porcentajeNoSano = 0;
      detectionError = false; // Resetear bandera de error

      growthError = false;
      growthErrorMessage = null;
    });

    try {
      final growth = await _statsService.fetchGrowthChartData(childId);
      print("data crecimiento....... ${growth.weights}");
      print("data crecimiento....... ${growth.heights}");

      if (growth.weights.isEmpty || growth.heights.isEmpty) {
        setState(() {
          growthErrorMessage =
              'No hay suficientes datos para generar los gráficos de crecimiento. Intente nuevamente actualizando datos de peso y talla del niño';
          isLoading = false; // 👈 Importante: detener el loading
        });
      } else if (growth.weights.any((w) => w == null) ||
          growth.heights.any((h) => h == null)) {
        setState(() {
          growthErrorMessage =
              'Algunos datos de crecimiento están incompletos. Intente nuevamente actualizando los dato peso y talla del niño';
          isLoading = false;
        });
      } else {
        // 👇 Parsear las fechas
        fechas =
            growth.dates.map((dateStr) => DateTime.parse(dateStr)).toList();
        print(fechas);
        // Obtener la primera fecha como fecha de registro
        final DateTime? fechaRegistro = fechas.isNotEmpty ? fechas.first : null;

        setState(() {
          /* pesoData = List.generate(
            growth.weights.length,
            (index) {
              final weight = growth.weights[index];
              return weight != null ? FlSpot(index.toDouble(), weight) : null;
            },
          ).whereType<FlSpot>().toList(); // Filtra los nulls

          tallaData = List.generate(
            growth.heights.length,
            (index) {
              final height = growth.heights[index];
              return height != null ? FlSpot(index.toDouble(), height) : null;
            },
          ).whereType<FlSpot>().toList(); */
          pesoData = List.generate(growth.weights.length, (index) {
            final weight = growth.weights[index];
            final date = fechas[index];

            // Si quieres filtrar por una fecha mínima (ej: de registro), puedes hacerlo aquí.
            return weight != null ? FlSpot(index.toDouble(), weight) : null;
          }).whereType<FlSpot>().toList();

          tallaData = List.generate(growth.heights.length, (index) {
            final height = growth.heights[index];
            final date = fechas[index];
            return height != null ? FlSpot(index.toDouble(), height) : null;
          }).whereType<FlSpot>().toList();
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

      if (detections.isEmpty) {
        setState(() {
          porcentajeNormal = 0;
          porcentajeDesnutrido = 0;
          porcentajeRiesgo = 0;
          // Opcional: podrías mostrar un SnackBar diciendo que no hay datos
        });
      } else {
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
                orElse: () => DetectionResult(
                    category: 'Riesgo en desnutrición', count: 0))
            .count;

        final total = normal + desnutrido + riesgo;
        nnormal = normal.toInt();
        nriesgo = riesgo.toInt();
        ndesnutrido = desnutrido.toInt();
        if (total > 0) {
          setState(() {
            porcentajeNormal = (normal / total) * 100;
            porcentajeDesnutrido = (desnutrido / total) * 100;
            porcentajeRiesgo = (riesgo / total) * 100;
          });
        }
      }
    } catch (e) {
      print(e);
      // Aquí puedes crear un error específico sólo para detecciones
      setState(() {
        detectionError = true; // Flag para indicar que hubo error
        porcentajeNormal = 0;
        porcentajeDesnutrido = 0;
        porcentajeRiesgo = 0;
      });
      // Opcional: podrías agregar un SnackBar para advertir que no se pudo cargar detecciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudieron cargar las detecciones.'),
          backgroundColor: Colors.red,
        ),
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
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No hay niños registrados.'),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      text: 'Registrar Niño',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterChildScreen(),
                          ),
                        ).then((_) {
                          // Cuando regrese de la pantalla de registro, recarga los niños.
                          _loadChildren();
                        });
                      },
                      width: 200,
                    ),
                  ],
                ),
              )
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
                    const Text(
                      'Toca los puntos para ver la fecha y valor en los graficos de talla y peso',
                      style: TextStyle(fontSize: 15),
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
                          if (growthErrorMessage != null) ...[
                            // 👈 Mostrar mensaje de crecimiento
                            Text(
                              growthErrorMessage!,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  CustomElevatedButton(
                                    text: 'Actualizar datos del niño',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditChildProfileScreen(
                                                  childId:
                                                      selectedChild!.childId,
                                                )),
                                      ).then((_) => _loadChildren());
                                    },
                                    width: 290,
                                  ),
                                ],
                              ),
                            )
                          ],
                          if (pesoData.isNotEmpty || tallaData.isNotEmpty) ...[
                            // Los gráficos de crecimiento, solo si hay datos

                            buildLabeledChart(
                              title: 'Peso por Mes',
                              xLabel: 'Fecha',
                              yLabel: 'Peso (kg)',
                              data: pesoData,
                            ),
                            const SizedBox(height: 24),
                            buildLabeledChart(
                              title: 'Talla por Mes',
                              xLabel: 'Fecha',
                              yLabel: 'Talla (cm)',
                              data: tallaData,
                            ),
                            const SizedBox(height: 24),
                          ],
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

  // 👇 Modificar _buildLineChart para mostrar fechas en el eje X
/*   Widget _buildLineChart(List<FlSpot> data, String yLabel) {
    if (data.isEmpty) return const Text('Sin datos disponibles.');

    double minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

    double minX = data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    double maxX = data.map((e) => e.x).reduce((a, b) => a > b ? a : b);

    double intervalY = ((maxY - minY) / 5).clamp(1, double.infinity);

    // Por ejemplo, cada 1 mes
    double intervalX = const Duration(days: 30).inMilliseconds.toDouble();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: intervalY,
                reservedSize: 40,
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
              sideTitles: SideTitles(
                showTitles: true,
                interval: intervalX,
                getTitlesWidget: (value, meta) {
                  // 👇 Buscar la fecha real más cercana al valor actual
                  final index = value.toInt();
                  if (index >= 0 && index < fechas.length) {
                    final date = fechas[index];
                    final formattedDate = DateFormat('dd/MM').format(date);
                    return Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 10),
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          minX: minX,
          maxX: maxX,
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
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: const Color(0xFF83B56A),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final index = touchedSpot.x.toInt(); // tu índice
                  String fechaTexto = '';
                  if (index >= 0 && index < fechas.length) {
                    final date = fechas[index];
                    fechaTexto = DateFormat('dd/MM/yyyy').format(date);
                  }
                  return LineTooltipItem(
                    '$fechaTexto\n${touchedSpot.y}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  } */
  Widget buildLabeledChart({
    required String title,
    required String xLabel,
    required String yLabel,
    required List<FlSpot> data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  yLabel,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(child: _buildLineChart(data, yLabel)),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            xLabel,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  List<LineChartBarData> generateColoredLineSegments(List<FlSpot> spots) {
    List<LineChartBarData> segments = [];

    if (spots.length == 1) {
      // Un solo punto
      segments.add(
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 3,
          color: const Color(0xFF83B56A),
          dotData: FlDotData(show: true), // 👈 Mostrar punto
          belowBarData: BarAreaData(show: false),
        ),
      );
      return segments;
    }

    for (int i = 0; i < spots.length - 1; i++) {
      final current = spots[i];
      final next = spots[i + 1];

      final isDescending = next.y < current.y;

      segments.add(
        LineChartBarData(
          spots: [current, next],
          isCurved: true,
          barWidth: 3,
          color: isDescending ? Colors.red : const Color(0xFF83B56A),
          dotData: FlDotData(show: true), // muestra punto solo en primero
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return segments;
  }

  Widget _buildLineChart(List<FlSpot> data, String yLabel) {
    if (data.isEmpty) return const Text('Sin datos disponibles.');

    double minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1;
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1;

    double minX = data.first.x;
    double maxX = data.last.x + 1;

    //double intervalY = ((maxY - minY) / 5).clamp(1, double.infinity);
    double rangeY = (maxY - minY);
    double rawInterval = rangeY / 5;
    double intervalY = rawInterval < 1 ? 1 : rawInterval.ceilToDouble();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 350, // Puedes ajustar este valor
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: intervalY,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1, // Cada punto
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < fechas.length) {
                      final date = fechas[index];
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(date);
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            lineBarsData: generateColoredLineSegments(data),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: const Color(0xFF83B56A),
                  tooltipMargin: 10,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    final shownX = <double>{};
                    return touchedSpots.map((touchedSpot) {
                      final x = touchedSpot.x;
                      final index = x.toInt();

                      if (!shownX.add(x)) {
                        // Ya se mostró tooltip para este punto, evitar duplicado
                        return null;
                      }

                      String fechaTexto = '';
                      if (index >= 0 && index < fechas.length) {
                        fechaTexto =
                            DateFormat('dd/MM/yyyy').format(fechas[index]);
                      }

                      return LineTooltipItem(
                        '$fechaTexto\n${touchedSpot.y}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  }),
            ),
          ),
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
          'No hay datos suficientes para mostrar el gráfico de detección. Dirijase a la opción de detección y realice su primera detección con el niño');
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
            buildLegendItem(Colors.green, 'Normal ($nnormal)'),
            buildLegendItem(Colors.redAccent, 'Desnutrido ($ndesnutrido)'),
            buildLegendItem(Colors.orange, 'Riesgo ($nriesgo)'),
          ],
        ),
      ],
    );
  }
}
