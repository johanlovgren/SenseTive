/// The object representing the tick of the timer
class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks + x + 1);
  }
}
