import 'package:flutter/material.dart';
import 'package:sensetive/widgets/result_widgets.dart';
import 'package:sensetive/models/reading_models.dart';


/// Page for showing the baby readings
///
/// See also [ReadingDateAndTimeWidget], [ReadingHeartRateWidget]
class BabyReadingWidget extends StatelessWidget {
  final Reading _reading;

  BabyReadingWidget(this._reading);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ReadingDateAndTimeWidget(_reading.date, _reading.durationSeconds),
          ReadingHeartRateWidget(_reading.heartRate),
        ],
      ),
    );
  }
}

