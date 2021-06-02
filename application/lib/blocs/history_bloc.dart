import 'dart:async';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/services/backend_api.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

/// BLoC for the [History] page
class HistoryBloc {
  /// List containing the sorting alternatives, order does matter,
  /// see _filterReadings()

  static const List<String> sortAlternatives = const [
    'Most recent',
    'Oldest',
    'Longest',
    'Shortest'
  ];
  final String jwt;
  DatabaseFileRoutines _databaseFileRoutines;
  ReadingsDatabase _readingDatabase;
  List<Reading> _currentShowingReadings;
  BackendApi _backendApi = BackendService();

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

  final StreamController<String> _errorController = StreamController.broadcast();
  Sink<String> get _addError => _errorController.sink;
  Stream<String> get getError => _errorController.stream;

  HistoryBloc({this.jwt}) {
    _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
    _databaseFileRoutines.readReadings().then((readingsJson) {
      _readingDatabase = readingsDatabaseFromJson(readingsJson);
      _fetchRemoteReadings(jwtToken: jwt).then((remoteReadings) {
        if (remoteReadings.length == 0)
          return;
        remoteReadings.forEach((r) => _readingDatabase.readings.putIfAbsent(r.id, () => r));
        _databaseFileRoutines.writeReadings(databaseToJson(_readingDatabase));
        _currentShowingReadings = List<Reading>.from(_readingDatabase.readings.values);
        _currentShowingReadings.sort((a, b) => b.date.compareTo(a.date));
        _addReadingList.add(_currentShowingReadings);
      });
      _currentShowingReadings = List<Reading>.from(_readingDatabase.readings.values);
      _currentShowingReadings.sort((a, b) => b.date.compareTo(a.date));
      _addReadingList.add(_currentShowingReadings);
    });
    _startListeners();
  }

  Future<List<Reading>> _fetchRemoteReadings({String jwtToken}) async {
    try {
      List<Reading> remoteReadings;
      if (_readingDatabase.readings.length == 0 || _readingDatabase.updatedAt == null) {
        remoteReadings = await _backendApi.fetchReadings(jwtToken: jwt);
      } else {
        DateTime mostRecent = _readingDatabase.updatedAt;
        remoteReadings = await _backendApi.fetchReadings(jwtToken: jwt, date: mostRecent);
      }
      _readingDatabase.updatedAt = DateTime.now();
      return remoteReadings;
    } catch (e) {
      _addError.add(e.message);
      return [];
    }
  }

  /// Starts the stream listeners
  void _startListeners() {
    removeReading.listen((index) async {
      String readingId = _currentShowingReadings[index].id;
      _readingDatabase.readings.remove(readingId);
      _currentShowingReadings.removeAt(index);
      _addReadingList.add(_currentShowingReadings);
      _databaseFileRoutines.writeReadings(databaseToJson(_readingDatabase));
      try {
        await _backendApi.deleteReading(jwtToken: jwt, readingId: readingId);
      } catch (e) {
        _addError.add(e.message);
      }
    });
    filter.listen((filterBy) {
      _currentShowingReadings = _filterReadings(filterBy, List<Reading>.from(_readingDatabase.readings.values));
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
    _errorController.close();
  }
}