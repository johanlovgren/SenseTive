import 'package:flutter/material.dart';
import 'package:sensetive/blocs/history_bloc.dart';
import 'package:sensetive/pages/result/result.dart';
import 'package:sensetive/models/reading_models.dart';

/// Page showing the history of all readings
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  HistoryBloc _historyBloc;
  int _filter = 3;
  String sortBy;

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc();
    sortBy = _historyBloc.sortAlternatives[0];
  }


  @override
  void dispose() {
    _historyBloc.dispose();
    super.dispose();
  }

  /// Build listens to the History BLoC readings stream. When readings
  /// are loaded the UI is built.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _historyBloc.readingList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            _buildSliverList(snapshot)
          ],
        );
      },
    );
  }

  /// Builds the [SliverAppBar] containing filter and buttons
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      forceElevated: true,
      title: _filterChipRow(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSortButtonStreamBuilder()
          ],
        ),
      ),
    );
  }

  /// Builds the sort button, [PopupMenuButton] by listening at the
  /// history BLoC sort stream.
  StreamBuilder<String> _buildSortButtonStreamBuilder() {
    return StreamBuilder(
      initialData: sortBy,
      stream: _historyBloc.sort,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return PopupMenuButton<String>(
          onSelected: (sortBy) {
            setState(() {
              print(sortBy);
              this.sortBy = sortBy;
              _historyBloc.addSort.add(sortBy);
            });
          },
          onCanceled: () {
            print('Canceled');
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.unfold_more,
                  color: Colors.indigo,
                ),
                Text(
                  snapshot.data,
                  style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 14
                  ),
                )
              ],
            ),
          ),
          itemBuilder: (BuildContext context) {
            return _historyBloc.sortAlternatives.map((alternative) =>
                PopupMenuItem<String>(
                    child: Text(alternative),
                    value: alternative
                )).toList();
          },
        );
      },
    );
  }

  /// Builds the list of readings in a [SliverList]
  ///
  /// [snapshot] the [AsyncSnapshot] received from the stream containing the
  /// List with all readings
  Widget _buildSliverList(AsyncSnapshot snapshot) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data[index].id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return _showDeleteDialog();
                  },
                  child: ReadingRowWidget(index: index, reading: snapshot.data[index]),
                  onDismissed: (direction) async {
                    _historyBloc.addRemoveReading.add(index);
                  },
                );
              },
          childCount: snapshot.data.length,
        )
    );
  }

  /// Builds the row with filter chips, when filter is chosen, filter index is
  /// added to the History BLoC filter stream.
  Row _filterChipRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterChip(
          label: Text('Today'),
          selected: _filter == 0,
          onSelected: (value) {
            setState(() {
              _filter = _filter == 0 ? 3 : 0;
              _historyBloc.addFilter.add(_filter);
            });
          },
        ),
        FilterChip(
          label: Text('7 d.'),
          selected: _filter == 1,
          onSelected: (value) {
            setState(() {
              _filter = _filter == 1 ? 3 : 1;
              _historyBloc.addFilter.add(_filter);
            });
          },
        ),
        FilterChip(
          label: Text('4 w.'),
          selected: _filter == 2,
          onSelected: (value) {
            setState(() {
              _filter = _filter == 2 ? 3 : 2;
              _historyBloc.addFilter.add(_filter);
            });
          },
        ),
        FilterChip(
          label: Text('All'),
          selected: _filter == 3,
          onSelected: (value) {
            setState(() {
              _filter = _filter == 3 ? 3 : 3;
              _historyBloc.addFilter.add(_filter);
            });
          },
        ),
      ],
    );
  }

  /// Used to show a dialog ensuring that the user wants to delete a reading
  Future<bool> _showDeleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete reading'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          );
        });
  }
}

/// Widget displaying a reading in the [SliverList], when a reading is pressed,
/// the UI navigates to show that reading in detail
class ReadingRowWidget extends StatelessWidget {
  final int index;
  final Reading reading;
  ReadingRowWidget({@required this.index, @required this.reading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: ,
        title: Text(reading.toString()),
        subtitle: Text(
            'Duration: ' +
                durationToString(reading.durationSeconds) +
                ', avg. HR: ' +
                (reading.momAvgHeartRate != null ? '${reading.momAvgHeartRate}/' : '/') +
                (reading.babyAvgHeartRate != null ? '${reading.babyAvgHeartRate}' : '')
                + ' bpm'
        ),
        // trailing: ,
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
          builder: (context) => ReadingResultWidget(reading),
          fullscreenDialog: fullscreenDialog
      ),
    );
  }
}