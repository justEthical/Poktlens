import 'package:flutter/widgets.dart';
import 'package:lens/Screens/Home/Home.dart';
import 'package:lens/Test.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
