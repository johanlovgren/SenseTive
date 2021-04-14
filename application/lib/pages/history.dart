import 'package:flutter/material.dart';
import 'package:sensetive/pages/result/result.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';

/// Page showing the history of all readings
class History extends StatefulWidget {
  final List<Reading> readings = dummyReadings;

  //History(this.readings);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Database _database;
  //List<Reading> _readings;


  @override
  void initState() {
    super.initState();
    //_readings = widget.readings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: [],
      future: _loadReadings(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : _buildListView(snapshot);
      },
    );
  }

  Future<List<Reading>> _loadReadings() async {
    await DatabaseFileRoutines().readReadings().then((readingsJson) {
      _database = databaseFromJson(readingsJson);
      _database.readings.sort((a, b) => b.date.compareTo(a.date));
    });
    return _database.readings;
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(snapshot.data[index].id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ReadingRowWidget(index: index, reading: snapshot.data[index]),
          onDismissed: (direction) {
            setState(() {
              _database.readings.removeAt(index);
            });
            DatabaseFileRoutines().writeReadings(databaseToJson(_database));
          },
        );
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
