import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/AddMemberPage/AddMemberPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class NoCaseFoundPage extends StatefulWidget {
  final searchedCaseData;

  NoCaseFoundPage(this.searchedCaseData);
  @override
  _NoCaseFoundPageState createState() => _NoCaseFoundPageState();
}

class _NoCaseFoundPageState extends State<NoCaseFoundPage> {

  bool isPressed = false;
  var caseData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 0, left: 0),
              child: Icon(Icons.chevron_left, color: Colors.black, size: 25)),
        ),
        title: Center(
          child: Text(
            "Add a Case",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "quicksand",
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          Container(
            child: Icon(Icons.ac_unit),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            SizedBox(height: 20),
            Container(
                margin: EdgeInsets.all(20),
                child: Image.asset(
                  "assets/image/addcase.png",
                  height: 44,
                )),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
              child: Text(
                "No case found",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 40, top: 10, bottom: 40),
              child: Text(
                "It doesn't look like we could locate a case that matched that information.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontFamily: "quicksand",
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "First Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${widget.searchedCaseData['first_name']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff354D5B),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.1,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Last Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${widget.searchedCaseData['last_name']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff354D5B),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.1,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Date of Birth",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.searchedCaseData['birthday']))}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff354D5B),
                        fontSize: 11,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.1,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            GestureDetector(
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemberPage(1)));
                _addCase();
              },
              child: Container(
                margin: EdgeInsets.all(20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selectedColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Create case",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }




  ////////////////////////  Add CAse  STart  //////////////////////
  
  void _addCase() async {
    setState(() {
      isPressed = true;
    });


    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var userData = json.decode(userJson);
    var data = {
      'first_name': widget.searchedCaseData['first_name'],
      'last_name': widget.searchedCaseData['last_name'],
      'birthday': widget.searchedCaseData['birthday'],
      'user_id': userData['id'],
    };
    
    print(data);
    //_showCloseDialog(1);

    // setState(() {
    //   isPressed = false;
    // });
    //

    var res = await CallApi().postData(data, 'post_case_general');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      _errorDialog("Something went wrong!");
        setState(() {
      isPressed = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){ 
      setState(() {
      isPressed = false;
     // caseData = body['caseGeneral'];
    });
    print(body['caseGeneral']);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => AddMemberPage(1, body['caseGeneral']))); 
    }else{
      print('did not work');
      _errorDialog("Something went wrong!");
      setState(() {
      isPressed = false;
    });
     }
  }
//////////////////////// Add CAse End /////////////////////////

////////////// Error Dialog STart //////////
  Future<Null> _errorDialog(title) async {
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
                      child:Image.asset("assets/image/accept_close.png")),
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
