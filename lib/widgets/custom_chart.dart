import 'dart:math';

import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Color> colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.cyan, Colors.purple];

double getMaxValue(Iterable<double> values) {
  if (values.isEmpty) return 10;

  double maxValue = values.reduce((a, b) => a > b ? a : b);

  if (maxValue <= 10) return 10;

  int magnitude = maxValue == 0 ? 0 : maxValue.floor().toString().length - 1;
  double factor = pow(10, magnitude).toDouble();

  return ((maxValue / factor).ceil() * factor).toDouble();
}

class CustomBarChart extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const CustomBarChart({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final labels = data.keys.toList();
    final values = data.values.toList();
    final maxY = getMaxValue(values);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(-1.0, -1.0)),
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(3.0, 3.0)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CustomText(title, color: Theme.of(context).colorScheme.primary, fontSize: 16.0, fontWeight: FontWeight.bold),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: maxY,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.0,
                      getTitlesWidget: (value, meta) => Text(labels[value.toInt().clamp(0, labels.length - 1)]),
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40.0)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: List.generate(
                  values.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [BarChartRodData(color: colors[index], toY: values[index], width: 12.0)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLineChart extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final List<String> keys, labels;

  const CustomLineChart({super.key, required this.title, required this.data, required this.keys, required this.labels});

  @override
  Widget build(BuildContext context) {
    final allValues = <double>[];

    for (var entry in data) {
      for (var key in keys) {
        if (entry.containsKey(key) && entry[key] != null) {
          allValues.add((entry[key] as num).toDouble());
        }
      }
    }

    final maxY = getMaxValue(allValues);
    final lines = <LineChartBarData>[];
    final months = data.map((e) => e["month"]!.toString()).toList();

    for (int i = 0; i < keys.length; i++) {
      final label = keys[i];
      final spots = <FlSpot>[];

      for (int j = 0; j < data.length; j++) {
        if (data[j].containsKey(label) && data[j][label] != null) {
          spots.add(FlSpot(j.toDouble(), (data[j][label] as num).toDouble()));
        }
      }

      lines.add(LineChartBarData(isCurved: true, color: colors[i % colors.length], barWidth: 3.0, spots: spots, dotData: FlDotData(show: true)));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(-1.0, -1.0)),
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(3.0, 3.0)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CustomText(title, color: Theme.of(context).colorScheme.primary, fontSize: 16.0, fontWeight: FontWeight.bold),
          Expanded(
            child: data.isNotEmpty
                ? LineChart(
                    LineChartData(
                      maxY: maxY,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1.0,
                            reservedSize: 28.0,
                            getTitlesWidget: (value, meta) => Text(months[value.toInt().clamp(0, labels.length - 1)]),
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40.0)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: lines,
                    ),
                  )
                : Center(child: CustomText(Globalization.msgEmptyData.tr, fontSize: 16.0)),
          ),
          Wrap(
            spacing: 8.0,
            children: List.generate(
              labels.length,
              (index) => Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6.0,
                children: <Widget>[
                  Container(color: colors[index % colors.length], height: 10.0, width: 10.0),
                  CustomText(labels[index], fontSize: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const CustomPieChart({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final labels = data.keys.toList();
    final values = data.values.toList();
    final total = values.fold<double>(0.0, (a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(-1.0, -1.0)),
          BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: Offset(3.0, 3.0)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CustomText(title, color: Theme.of(context).colorScheme.primary, fontSize: 16.0, fontWeight: FontWeight.bold),
          Expanded(
            child: Row(
              spacing: 16.0,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;

                      return PieChart(
                        PieChartData(
                          centerSpaceRadius: 0.0,
                          sectionsSpace: 0.0,
                          sections: List.generate(
                            values.length,
                            (index) => PieChartSectionData(
                              color: colors[index % colors.length],
                              radius: size * 0.45,
                              value: values[index],
                              title: "${(values[index] / total * 100).toStringAsFixed(1)}%",
                              titleStyle: const TextStyle(color: Colors.black54, fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: labels.length,
                    itemBuilder: (_, index) => Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6.0,
                      children: <Widget>[
                        Container(color: colors[index % colors.length], height: 10.0, width: 10.0),
                        Expanded(child: CustomText("${labels[index]} (${values[index]})", fontSize: 12.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
