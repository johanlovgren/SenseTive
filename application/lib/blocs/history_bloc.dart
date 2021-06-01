import 'dart:async';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

/// BLoC for the [History] page
class HistoryBloc {
  /// List containing the sorting alternatives, order does matter,
  /// see _filterReadings()

  final List<String> sortAlternatives = const [
    'Most recent',
    'Oldest',
    'Longest',
    'Shortest'
  ];
  final String jwt;
  DatabaseFileRoutines _databaseFileRoutines;
  ReadingsDatabase _readingDatabase;
  List<Reading> _currentShowingReadings;

  /// Stream used for the list of readings
  final StreamController<List<Reading>> _readingListController = StreamController<List<Reading>>();
  Sink<List<Reading>> get _addReadingList => _readingListController.sink;
  Stream<List<Reading>> get readingList => _readingListController.stream;
  /// Stream used to remove a reading from the list and database
  final StreamController<int> _removeReadingController = StreamController<int>();
  Sink<int> get addRemoveReading => _removeReadingController.sink;
  Stream<int> get removeReading => _removeReadingController.stream;
  /// Stream used to filter the readings
  final StreamController<int> _filterController = StreamController<int>();
  Sink<int> get addFilter => _filterController.sink;
  Stream<int> get filter => _filterController.stream;
  /// Stream used to sort the readings
  final StreamController<String> _sortController = StreamController<String>.broadcast();
  Sink<String> get addSort => _sortController.sink;
  Stream<String> get sort => _sortController.stream;

  HistoryBloc({this.jwt}) {
    _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
    _databaseFileRoutines.readReadings().then((readingsJson) {
      _readingDatabase = readingsDatabaseFromJson(readingsJson);
      _readingDatabase.readings.sort((a, b) => b.date.compareTo(a.date));
      _currentShowingReadings = _readingDatabase.readings;
      _addReadingList.add(_currentShowingReadings);
    });
    _startListeners();
  }

  /// Starts the stream listeners
  void _startListeners() {
    removeReading.listen((index) {
      _currentShowingReadings.removeAt(index);
      _readingDatabase.readings.removeWhere((reading)
        => reading.id == _currentShowingReadings[index].id);
      _addReadingList.add(_currentShowingReadings);
      _databaseFileRoutines.writeReadings(databaseToJson(_readingDatabase));
    });
    filter.listen((filterBy) {
      _currentShowingReadings = _filterReadings(filterBy, _readingDatabase.readings);
      _addReadingList.add(_currentShowingReadings);
    });
    sort.listen((index) {
      _addReadingList.add(_sortReadings(index));
    });
  }

  /// Sorts the readings in [_readingDatabase]
  ///
  /// [sortBy] what to sort the readings by, see [sortAlternatives]
  List<Reading> _sortReadings(String sortBy) {
    if (sortBy == sortAlternatives[0])
      _currentShowingReadings.sort((a, b) => b.date.compareTo(a.date));
    else if (sortBy == sortAlternatives[1])
      _currentShowingReadings.sort((a, b) => a.date.compareTo(b.date));
    else if (sortBy == sortAlternatives[2])
      _currentShowingReadings.sort((a, b) => b.durationSeconds.compareTo(a.durationSeconds));
    else if (sortBy == sortAlternatives[3])
      _currentShowingReadings.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    return _currentShowingReadings;
  }

  /// Filters the readings
  ///
  /// [filterBy] what to filter the readings by
  /// [unfiltered] the readings to filter
  List<Reading> _filterReadings(int filterBy, List<Reading> unfiltered) {
    List<Reading> _filtered;
    switch (filterBy) {
      case 0:
        _filtered = unfiltered.where((reading)
        => reading.date.year == DateTime.now().year
            && reading.date.month == DateTime.now().month
            && reading.date.day == DateTime.now().day).toList();
        break;
      case 1:
        _filtered = unfiltered.where((reading)
        => reading.date.isAfter(DateTime.now().subtract(Duration(days: 7)))).toList();
        break;
      case 2:
        _filtered = unfiltered.where((reading)
        => reading.date.isAfter(DateTime.now().subtract(Duration(days: 4*7)))).toList();
        break;
      default:
        _filtered = unfiltered;
    }
    return _filtered;
  }

  /// Dispose and close all streams
  void dispose() {
    _readingListController.close();
    _filterController.close();
    _removeReadingController.close();
    _sortController.close();
  }
}