import 'package:flutter/material.dart';
import 'package:sensetive/pages/result/result.dart';
import 'package:sensetive/models/reading_models.dart';

/// Page showing the history of all readings
class History extends StatefulWidget {
  final List<Reading> readings = dummyReadings;

  //History(this.readings);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Reading> _readings;


  @override
  void initState() {
    super.initState();
    _readings = widget.readings;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _readings.length,
      itemBuilder: (BuildContext context, int index) {
        return ReadingRowWidget(index: index, reading: _readings[index]);
      },
    );
  }
}

/// Widget displaying a reading in the [ListView]
// TODO Not completed, only showing dummies!
class ReadingRowWidget extends StatelessWidget {
  final int index;
  final Reading reading;
  ReadingRowWidget({@required this.index, @required this.reading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.favorite_outline,
          size: 35,
          color: Colors.indigo.shade300,
        ),
        title: Text('Reading $index'),
        subtitle: Text(reading.toString()),
        trailing: Text(
          'Trailing $index',
          style: TextStyle(
            color: Colors.indigo.shade300
          ),
        ),
        onTap: () {
          _openReadingResult(context: context, reading: reading);
        },
      ),
    );
  }
  void _openReadingResult({BuildContext context,
    bool fullscreenDialog = false,
    Reading reading}){

    Navigator.push(
      context,
      MaterialPageRoute(
        // TODO Fix dodge with baby and mother readings!
          builder: (context) => ReadingResultWidget(reading, reading),
          fullscreenDialog: fullscreenDialog
      ),
    );
  }
}


// ************ Dummies ******************

List<Reading> dummyReadings = [
  Reading(date: DateTime.now(), durationSeconds: 500, heartRate: [60, 61, 62, 63, 62, 61, 58]),
  Reading(date: DateTime.now(), durationSeconds: 500, heartRate: [60, 61, 62, 63, 62, 61, 58]),
  Reading(date: DateTime.now(), durationSeconds: 500, heartRate: [60, 61, 62, 63, 62, 61, 58]),
];
