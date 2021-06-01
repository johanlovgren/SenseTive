import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/widgets/heart_rate_chart_widget.dart';
import 'package:sensetive/widgets/card_with_header.dart';

/// Widget for showing date and duration time for a reading
///
/// Se also [CardWithHeaderWidget] and [ResultBall]
class ReadingDateAndTimeWidget extends StatelessWidget {
  final DateTime _date;
  final int _durationSeconds;

  ReadingDateAndTimeWidget(this._date, this._durationSeconds);

  @override
  Widget build(BuildContext context) {
    return CardWithHeaderWidget(
        text: '${DateFormat.yMMMd().format(_date)}, '
            '${DateFormat.Hm().format(_date)}',
        startingIcon: Icon(
          Icons.calendar_today,
          color: Colors.white,
          size: 20,
        ),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ResultBall(
                  text: 'Duration\n' + durationToString(_durationSeconds),
                ),
              ],
            )
        )
    );
  }
}

/// Widget for showing the heart rate of a reading
///
/// Se also [CardWithHeaderWidget], [ResultBall] and [HearRateLineChartWidget]
class ReadingHeartRateWidget extends StatelessWidget {
  final List<int> _heartRate;

  ReadingHeartRateWidget(this._heartRate);

  @override
  Widget build(BuildContext context) {
    return _heartRate == null || _heartRate.length == 0
        ? Container(width: 0, height: 0)
        : CardWithHeaderWidget(
          text: 'Heart Rate (BPM)',
          startingIcon: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 20,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ResultBall(
                        text: '${_heartRate.reduce(min)}\nMinimum'
                    ),
                    ResultBall(
                      text: '${(_heartRate.reduce((a,b) => a + b) / _heartRate.length).round()}'
                          '\nAverage',
                    ),
                    ResultBall(
                        text: '${_heartRate.reduce(max)}\nMaximum'
                    ),
                  ],
                ),
              ),
              HearRateLineChartWidget(_heartRate)
            ],
          ),
        );
  }
}

/// Widget used to show the oxygen level from a reading
///
/// Se also [CardWithHeaderWidget] and [ResultBall]
class ReadingOxygenLevelWidget extends StatelessWidget {
  final List<int> _oxygenLevel;

  ReadingOxygenLevelWidget(this._oxygenLevel);

  @override
  Widget build(BuildContext context) {
    return _oxygenLevel == null || _oxygenLevel.length == 0
    ? Container(width: 0, height: 0)
    : CardWithHeaderWidget(
        text: 'Oxygen Level',
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ResultBall(
                  text: '${(_oxygenLevel.reduce((a,b) => a+b) / _oxygenLevel.length).round()}'
                      '%\nSpO2'
              ),
            ],
          ),
        ),
      );
  }
}

/// Widget used to show contractions from a reading
///
/// Se also [CardWithHeaderWidget] and [ResultBall]
class ReadingContractionsWidget extends StatelessWidget {
  final List<Contraction> _contractions;

  ReadingContractionsWidget(this._contractions);

  @override
  Widget build(BuildContext context) {
    return _contractions == null || _contractions.length == 0
      ? Container(width: 0, height: 0)
      : CardWithHeaderWidget(
        text: 'Contractions',
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _contractions.length,
          itemBuilder: (BuildContext context, int index) {
            Contraction _contraction = _contractions[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    '${_contraction.start}\n${_contraction.end}'
                ),
                Text(
                    _contraction.duration
                ),
                Text(
                    _contraction.freq
                ),
                Text(
                    _contraction.intensity
                ),
              ],
            );
          },
        ),
      );
  }
}

/// Widget used to show a result-text in a ball
class ResultBall extends StatelessWidget {
  final String text;
  ResultBall({ this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]
        ),
        child: CircleAvatar(
          backgroundColor: Colors.indigo.shade300,
          radius: 35,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12.0
            ),
          ),
        )
    );
  }
}