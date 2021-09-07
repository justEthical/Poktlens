import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lens/Wrapper.dart';
import 'package:lens/Screens/Home/CustomDrawer.dart';

import 'Test.dart';

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}