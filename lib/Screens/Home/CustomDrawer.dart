import 'package:flutter/material.dart';
import 'package:lens/Bloc/HomeScreenBloc.dart';

class CustomDrawer extends StatefulWidget {
  final AsyncSnapshot homeScreenBloc;
  CustomDrawer(this.homeScreenBloc);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation rotation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    rotation = Tween(begin: 0.5, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: 250,
      height: h,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userInfo(),
            Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(30))),
              child: _optionList(),
            ),
          ],
        ),
      ),
    );
  }

  _optionList() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Rate Our App",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Contact Us",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text("Support",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                )),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "About Us",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          )
        ],
      ),
    );
  }

  _userInfo() {
    return Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blue, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))),
        child: Row(
          children: [
            // User Profile Photo
            AnimatedBuilder(
              animation: _controller,
              builder: (ctx, _) {
                if (widget.homeScreenBloc.data == 250) {
                  _controller.forward();
                } else if (widget.homeScreenBloc.data == 0) {
                  _controller.reverse();
                }
                return RotationTransition(
                  turns: rotation,
                  child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(10),
                      child: CircleAvatar(
                          child: Image.asset("lib/Assets/user.png"))),
                );
              },
            ),
            //User Name
            Container(
                child: Expanded(
                    child: Text(
              "Hydra",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            )))
          ],
        ));
  }
}
