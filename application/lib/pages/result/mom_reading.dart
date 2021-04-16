import 'package:flutter/material.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/widgets/result_widgets.dart';

/// Page showing the mothers readings
///
/// See also [ReadingDateAndTimeWidget], [ReadingHeartRateWidget]
/// [ReadingOxygenLevelWidget], [ReadingContractionsWidget]
class MomReadingWidget extends StatelessWidget {
  final Reading _reading;

  MomReadingWidget(this._reading);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: <Widget>[
            ReadingDateAndTimeWidget(_reading.date, _reading.durationSeconds),
            ReadingHeartRateWidget(_reading.heartRate),
            ReadingOxygenLevelWidget(_reading.oxygenLevel),
            ReadingContractionsWidget(_reading.contractions)
          ]
      ),
    );
  }
}
