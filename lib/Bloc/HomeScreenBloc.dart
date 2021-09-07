import 'dart:async';

import 'package:flutter/animation.dart';

class HomeScreenBloc {
  bool drawerOpen = false;

  final drawerStreamController = StreamController<double>();

  Stream<double> get drawerStream => drawerStreamController.stream;
  StreamSink<double> get drawerSink => drawerStreamController.sink;

  void drawerSwitch() {
    drawerOpen = !drawerOpen;
    drawerOpen ? drawerSink.add(250) : drawerSink.add(0);
  }
}
