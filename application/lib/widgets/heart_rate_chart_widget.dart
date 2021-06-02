import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Chart for displaying the heart rate of a reading
class HearRateLineChartWidget extends StatelessWidget {
  final List<FlSpot> _values = [];
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];


  HearRateLineChartWidget(List<int> heartRate) {
    for (int i = 0; i < heartRate.length; i++) {
      _values.add(FlSpot(i.toDouble(), heartRate[i].toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0,
                    right: 32.0,
                    left: 6.0
                ),
                child: LineChart(
                    _data()
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  LineChartData _data() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),
          margin: 10,
          interval: 1,
          getTitles: (value) {
            if (value % (_values.length ~/4) != 0)
              return '';
            int _hours = (value ~/ (60 * 60));
            int _minutes = (value - _hours * (60 * 60)) ~/ 60;
            int _seconds = (value - _hours * (60 * 60) - _minutes * 60).toInt();
            return (_hours > 0 ? '$_hours:' : '') +
                (_hours > 0 && _minutes < 10? '0$_minutes:' : '$_minutes:') +
                '$_seconds';
          }
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 8,
          reservedSize: 30,
          getTitles: (value) {
            if (value.toInt() % 5 == 0)
              return value.toString();
            else
              return '';
          }
        ),
      ),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: 'BPM',
          margin: 4,
          textStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: 'Time (h:m:s)',
          margin: 0,
          textStyle: TextStyle(
              color: Colors.indigo,
              fontSize: 12,
              fontWeight: FontWeight.bold,
          ),
        )
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 2
          ),
          left: BorderSide(
            color: Colors.transparent
          ),
          right: BorderSide(
              color: Colors.transparent
          ),
          top: BorderSide(
              color: Colors.transparent
          )
        )
      ),
      minX: _values.map((spot) => spot.x).toList().reduce(min),
      maxX: _values.map((spot) => spot.x).toList().reduce(max),
      minY: _values.map((spot) => spot.y).toList().reduce(min) - 5,
      maxY: _values.map((spot) => spot.y).toList().reduce(min) + 10,
      lineBarsData: _lineBarData()
    );
  }


  List <LineChartBarData> _lineBarData() {
    LineChartBarData lineChart = LineChartBarData(
      spots: _values,
      isCurved: true,
      colors: [
        Colors.indigo.shade300
      ],
      barWidth: 0.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        gradientColorStops: [0.25, 0.5, 0.75],
        gradientFrom: Offset(0.5, 0),
        gradientTo: Offset(0.5, 1),
      )
    );
    return [lineChart];
  }
}
