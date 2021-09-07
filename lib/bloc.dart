import 'dart:async';

class Bloc {
  final boxStream = StreamController<double>();
  Stream<double> get h => boxStream.stream;
  StreamSink<double> get hput => boxStream.sink;

  bool hSwitch = false;
  change() {
    hSwitch = !hSwitch;
    hSwitch? hput.add(0): hput.add(250);
  }
}
