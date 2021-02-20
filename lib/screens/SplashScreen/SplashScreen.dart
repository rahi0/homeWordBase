import 'dart:async';
import 'dart:convert';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/WelcomePage/WelcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation<double> animation;
  // AnimationController controller;

  bool _isLoggedin = false;
  bool isLoading = true;
  bool firstOpen = false;


  @override
  void initState() {
    super.initState(); 

  // _anim();
   loadData();
    
  }

  ////////////// Animation ///////////////////
 _anim() async {
  //  controller =
  //       AnimationController(duration: Duration(seconds: 3), vsync: this);
  //   animation = Tween<double>(begin: 0, end: 250).animate(controller);
      // ..addListener(() {
      //   // setState(() {
      //   //   loadData();
      //   //   // The state that has changed here is the animation object’s value.
      //   // });
      // });

   // controller.forward();
 }


   /////////////////// Is the first time opended////
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

   // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      //return new Timer(_duration, navigationPageHome);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');

    if(userJson != null){
      _checkIfLoggedIn();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
      
    } else {// First time
      prefs.setBool('first_time', false);
      setState(() {
        firstOpen = true;
        isLoading = false;
      });
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => firstOpen ? WelcomePage() : LoginPage()));
      
    }
  }
  /////////////////// Is the first time opended////

  void _checkIfLoggedIn() async {
    // check if token is set or not...
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    print(token);

    if (token == null) {
      // user is not logged in....
      setState(() {
        _isLoggedin = false;
        isLoading = false;
      });
    } else {
      setState(() {
        _isLoggedin = true;
        isLoading = false;
      });

      store.dispatch(new UserInfoAction(user));
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => _isLoggedin ? HomePage() : LoginPage()));
  }

 

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), startTime);
  }

  // onDoneLoading() async {
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => _isLoggedin ? HomePage() :  firstOpen ? WelcomePage() : LoginPage())); //_isLoggedin ? HomePage() :
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          //backgroundImage: ExactAssetImage('assets/logo.png'),

          maxRadius: 70,
          minRadius: 70,
          //radius: 68.0,
          child: Image.asset('assets/image/logo1.png'),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Container(
         // height: animation.value,
         // width: animation.value,
         // child: logo,
         child: Container(
        padding: EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          //backgroundImage: ExactAssetImage('assets/logo.png'),

          maxRadius: 90,
          minRadius: 90,
          //radius: 68.0,
          child: Image.asset('assets/image/logo1.png'),
        ),
      ),
        ),
      ),
    );
  }
}
