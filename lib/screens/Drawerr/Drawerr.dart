import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:homewardbase/screens/MyProfilePage/MyProfilePage.dart';
import 'package:homewardbase/screens/NotificationPage/NotificationPage.dart';
import 'package:homewardbase/screens/SecurityPage/SecurityPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


class Drawerr extends StatefulWidget {
  @override
  _DrawerrState createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
String _projectVersion = '', _projectCode = '';
var userData;
   @override
  initState() {
    super.initState();
    _getUser();
    initPlatformState();
  }

  Future<Null> _getUser() async {
    
    setState(() {
      userData = store.state.userInfoState;
     // userData = user;
    });
  }

   initPlatformState() async {
    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
      _projectCode = projectCode;
    });
  }


  ////////////////// Drawer element Container Start //////////////
    Container drawerCon(String img, String title){
        return Container(
                              margin: EdgeInsets.only(top: 30, left: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset(img),
                                    height: 25,
                                    width: 25,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "quicksand",
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );
      }
//////////////Drawer element container end //////////////
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: SafeArea(
          child: Container(
            color: mainColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              children: <Widget>[
                                userData['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 63,
                                  width: 63,
                                  child: Center(
                                      child: Text(
                                    "${userData['first_name'][0].toUpperCase()}${userData['last_name'][0].toUpperCase()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  )),
                                )
                              :
                                Container(
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                                  CallApi().fileShowlurl +"${userData['profile_picture']}"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 63,
                                  width: 63,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 15),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${userData['first_name']} ${userData['last_name']}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "quicksand",
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${userData['user_type']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "quicksand",
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);

                             // currentDrawer == 'cases' ? null :
                              Navigator.push(context, MaterialPageRoute( builder: (context) => HomePage()));
                            },
                            child: drawerCon("assets/image/bag.png", "Cases"),
                          ),


                          GestureDetector(
                            onTap: () {

                              Navigator.pop(context);

                             // currentDrawer == 'profile' ? null :
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyProfilePage()));
                            },
                            child: drawerCon("assets/image/pp.png", "Profile") 
                          ),

                          
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);

                            //  currentDrawer == 'notifications' ? null :
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationPage()));
                            },
                            child: drawerCon("assets/image/bell.png", "Notifications"),
                          ),


                          GestureDetector(
                            onTap: () {
                               Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecurityPage()));
                            },
                            child: drawerCon("assets/image/shield.png", "Security"),
                          ),


                          GestureDetector(
                            onTap: () {
                              // Navigator.pop(context);
                            },
                            child: drawerCon("assets/image/question.png", "Help"),
                          ),


                          GestureDetector(
                            onTap: () {
                             //  Navigator.pop(context);
                            },
                            child: drawerCon("assets/image/feedback.png", "Feedback"),
                          ),

                          GestureDetector(
                            onTap: _logout,
                            child: drawerCon("assets/image/logout.png", "Logout"),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Privacy Policy ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "|",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Terms of Use",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "V$_projectVersion ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "|",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " © Homeardsbase, Inc",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "quicksand",
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }


  ////////////////////////  Log Out Start  //////////////////////
  void _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    //Navigator.push(context, SlideRightRoute(page: LoginPage()));
  }
  ///////////////////////////  Log Out End /////////////////////////
}