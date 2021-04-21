import 'package:flutter/material.dart';
import 'package:sensetive/pages/result/result.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';

/// Page showing the history of all readings
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Database _readingDatabase;

  @override
  void initState() {
    super.initState();
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
      _readingDatabase = databaseFromJson(readingsJson);
      _readingDatabase.readings.sort((a, b) => b.date.compareTo(a.date));
    });
    return _readingDatabase.readings;
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(snapshot.data[index].id.toString()),
          direction: DismissDirection.startToEnd,
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
              _readingDatabase.readings.removeAt(index);
            });
            DatabaseFileRoutines().writeReadings(databaseToJson(_readingDatabase));
          },
        );
      },
    );
  }
}

/// Widget displaying a reading in the [ListView]
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
          builder: (context) => ReadingResultWidget(reading),
          fullscreenDialog: fullscreenDialog
      ),
    );
  }
}



