import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/HomePage/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldpassController = new TextEditingController();
  TextEditingController newpassController = new TextEditingController();
  TextEditingController conpassController = new TextEditingController();
  bool isPressed = false;
  bool oldpassSeen = false;
  bool oldpassBlank = false; 
  String oldpassword = "";

  bool newpassSeen = false;
  bool newpassBlank = false;
  String newpassword = "";

  bool conpassSeen = false;
  bool conpassBlank = false;
  String conpassword = "";

 bool validPass = true;
 bool passMatch = true;
  bool validateStructure(String value){
        String  pattern = r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$';
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(value);
  }


  ////////////////// Error Container Start //////////////
    Container errorCon(String title){
        return Container(
                      margin: EdgeInsets.only(
                          left: 22, right: 20, top: 5, bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: "quicksand",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
      }
//////////////Error container end //////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 0, left: 0),
                    child: Icon(Icons.chevron_left,
                        color: Colors.black, size: 25)),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "quicksand",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(right: 0, left: 0),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: "quicksand",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.15),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          oldpassword = value;
                          oldpassBlank = false;
                        });
                      },
                      controller: oldpassController,
                      obscureText: oldpassSeen ? false : true,
                      autofocus: false,
                      style: TextStyle(
                          color: Color(0xff003A5B).withOpacity(0.6),
                          fontSize: 15,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        labelStyle: TextStyle(
                            color: Color(0xff7A98A9),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w500),
                        labelText: "Old Password",
                        contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (oldpassSeen) {
                          oldpassSeen = false;
                        } else {
                          oldpassSeen = true;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        oldpassSeen ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black38,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )),
//////////////////////////////////////
            oldpassBlank ?  errorCon("Old password field is blank") : Container(),
//////////////////////////////////////
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.15),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(

                      onChanged: (value) {
                                if(!validateStructure(newpassController.text)){
                                      setState(() {
                                          validPass= false;
                                          newpassword = value;
                                          newpassBlank = false;
                                      });
                                  }else{
                                    setState(() {
                                      validPass = true;
                                    });
                                  }
                              },
                      // onChanged: (value) {
                      //   setState(() {
                      //     newpassword = value;
                      //     newpassBlank = false;
                      //   });
                      // },
                      controller: newpassController,
                      obscureText: newpassSeen ? false : true,
                      autofocus: false,
                      style: TextStyle(
                          color: Color(0xff003A5B).withOpacity(0.6),
                          fontSize: 15,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        labelStyle: TextStyle(
                            color: Color(0xff7A98A9),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w500),
                        labelText: "New Password",
                        contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (newpassSeen) {
                          newpassSeen = false;
                        } else {
                          newpassSeen = true;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        newpassSeen ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black38,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )),
         
//////////////////////////////////////
              validPass != true ? 
              errorCon("Minimum 8 characters, 1 uppercase & 1 number required") : Container(),
//////////////////////////////////////         
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.15),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          conpassword = value;
                          conpassBlank = false;
                        });
                      },
                      controller: conpassController,
                      obscureText: conpassSeen ? false : true,
                      autofocus: false,
                      style: TextStyle(
                          color: Color(0xff003A5B).withOpacity(0.6),
                          fontSize: 15,
                          fontFamily: 'quicksand',
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        labelStyle: TextStyle(
                            color: Color(0xff7A98A9),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w500),
                        labelText: "Confirm New Password",
                        contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (conpassSeen) {
                          conpassSeen = false;
                        } else {
                          conpassSeen = true;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        conpassSeen ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black38,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )),
//////////////////////////////////////
              passMatch != true ? 
              errorCon("Password didin't match") : Container(),
//////////////////////////////////////         
         
          GestureDetector(
            onTap: () {
              isPressed ? null : doUpdate();
            },
            child: Container(
              margin: EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                margin: EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    color: isPressed ? Colors.white : selectedColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selectedColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isPressed
                        ? Container(
                            height: 20,
                            child: SpinKitWave(
                                color: selectedColor.withOpacity(0.5)))
                        : Container(),
                    isPressed
                        ? Container()
                        : Text(
                            "Update password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isPressed ? selectedColor : Colors.white,
                                fontSize: 16,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w700),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




Future<void> doUpdate() async {
    setState(() {
      isPressed = true;
    });

    if(oldpassController.text == ""){
      oldpassBlank = true;
      isPressed = false;
    }
    else if(!validateStructure(newpassController.text)){
       setState(() {
          validPass= false;
          isPressed = false;
      });
    }
    else if (newpassController.text != conpassController.text) {
      setState(() {
        passMatch = false;
        isPressed = false;
      });
    } else {
      setState(() {
        validPass= true;
        passMatch = true;
      });

      

      
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);

      var data = {
          'user_id': userData['id'],
          'current_password': oldpassController.text ,
          "new_password": newpassController.text,
        };
        print(data);


      var res = await CallApi().postData(data, 'changePassword');
      var body = json.decode(res.body);
    
  if (res.statusCode != 200) {

      setState(() {
          isPressed = false;
        });
        _errorDialog("Something went wrong", 1);
        print("Something went wrong");
    }
     if (res.statusCode == 200 && body['success'] == true) {

      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));

      setState(() {
          isPressed = false;
        });
    }    
    else if(res.statusCode == 200 && body['msg'] == "Password does not matchs"){

      _errorDialog("Password does not matchs", 1);

      setState(() {
          isPressed = false;
        });   
    }
    else{

      _errorDialog("Something went wrong", 1);

      setState(() {
          isPressed = false;
        });
    
    }
    }
  }


  ////////////// Error Dialog STart //////////
  Future<Null> _errorDialog(title, number) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      width: 55,
                      height: 55,
                      margin: EdgeInsets.all(15),
                      child: number == 1 ? Image.asset("assets/image/accept_removal.png")
                      : Image.asset("assets/image/case_created.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.white)),
                //   padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                //   child: Text(
                //     number == 1
                //         ? "You have already sent a request to this case"
                //         : "You are already a member to this case",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontFamily: 'quicksand',
                //         color: Color(0xff7A98A9),
                //         fontWeight: FontWeight.w400,
                //         fontSize: 11),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 30, right: 30),
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Done",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: "quicksand"))),
                  ),
                ),
              ],
            ),
          );
        });
  }
////////////// Errort Dialog End //////////
  
}
