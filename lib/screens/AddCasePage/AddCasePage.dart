import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/screens/AddCaseMultipleMatch/AddCaseMultipleMatch.dart';
import 'package:homewardbase/screens/AddCasePotentialmatch/AddCasePotentialmatch.dart';
import 'package:homewardbase/screens/NoCaseFoundPage/NoCaseFoundPage.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCasePage extends StatefulWidget {
  @override
  _AddCasePageState createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  String fName = "", lName = "", dob = "";

  bool isDatePicked = false;
  bool isPressed = false;
  bool isFNameBlank = false;
  bool isLNameBlank = false;
  bool isDateBlank = false;

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: selectedDate, // Refer step 1
    firstDate: DateTime(1970),
    lastDate: DateTime(2025),
    builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData(
                primaryColor: selectedColor,
                accentColor: selectedColor
              ),
              child: child,
            );
          },
  );
  if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
      isDatePicked = true;
    });
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
                "Add a Case",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 40, top: 10, bottom: 20),
              child: Text(
                "Let's see if a record already exists.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontFamily: "quicksand",
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),

            ////////////////////////////// First Name Start//////////////////
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.15),
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                padding: EdgeInsets.only(top: 15, bottom: 5, right: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            fName = value;
                            isFNameBlank = false;
                          });
                        },
                        controller: fNameController,
                        autofocus: false,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter First Name",
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
                          labelText: "First Name",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )),
            
            ////////////////////// First Name End///////////////////////////////
/////////////////////////////
 isFNameBlank != true ? Container(): errorCon("First name is empty!"),
////////////////////////////////      


            ////////////////////// Last Name Start///////////////////////////////
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
                            lName = value;
                            isLNameBlank = false;
                          });
                        },
                        controller: lNameController,
                        autofocus: false,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontSize: 15,
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter Last Name",
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
                          labelText: "Last Name",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )),

            ////////////////////// Last Name End///////////////////////////////
/////////////////////////////
 isLNameBlank != true ? Container(): errorCon("Last name is empty!"),
////////////////////////////////   
              

               ////////////////////// Date Start2///////////////////////////////
            GestureDetector(
              onTap: (){
                _selectDate(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(top: isDatePicked != true ? 23 : 15,  bottom: isDatePicked != true ? 23 : 15, right: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: isDatePicked != true ? 0 : 5),
                        child: Text(
                          "Date of Birth",
                          style: TextStyle(
                                color: Color(0xff7A98A9),
                                fontSize: isDatePicked != true ? 15 : 11,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w500),
                          ),
                      ),

                     isDatePicked != true ? Container() : Container(
                        child: Text(
                          //"${selectedDate}".split(' ')[0],
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: TextStyle(
                                color: Color(0xff7A98A9),
                                fontSize: 15,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w500),
                          ),
                      )
                    ],
                  )),
            ),

                ////////////////////// Date End2///////////////////////////////
  /////////////////////////////
 isDateBlank != true ? Container(): errorCon("Date of birth is empty!"),
////////////////////////////////   
            GestureDetector(
              onTap: isPressed ? null : doSearch,
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
                      isPressed
                            ? Container(
                                height: 20,
                                child: SpinKitWave(
                                    color: selectedColor.withOpacity(0.5)))
                            : Container(),
                       isPressed
                            ? Container()
                            :Text(
                        "Search",
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



   Future<void> doSearch() async {
    setState(() {
      isPressed = true;
    });

    if(fNameController.text == ""){
      isFNameBlank = true;
      isPressed = false;
    }
    else if(lNameController.text == ""){
      isLNameBlank = true;
      isPressed = false;
    }
    else if(isDatePicked != true){
      isDateBlank = true;
      isPressed = false;
    }
     else {
      setState(() {
        isFNameBlank = false;
        isLNameBlank = false;
        isDateBlank = false;
      });

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);


      var data = {
          'first_name': fNameController.text ,
          "last_name": lNameController.text,
          "birthday": "${selectedDate.toLocal()}".split(' ')[0],
          "user_id": userData['id']
        };
        print(data);


        //  addCasePage == 1
        //             ? Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => AddCasePotentialmatch()))
                    // : Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NoCaseFoundPage()));


      var res = await CallApi().postData(data, 'check_case_general');
       var body = json.decode(res.body);
    
  if (res.statusCode != 200) {
      setState(() {
          isPressed = false;
        });

        print("Something went wrong");
    }
    else if (res.statusCode == 200 && body['data'].length == 0) {
      setState(() {
          isPressed = false;
        });
        print("length nai");
        print(body['data'].length);
        Navigator.push(context, MaterialPageRoute( builder: (context) => NoCaseFoundPage(data)));
    }
    else if (res.statusCode == 200 && body['data'].length == 1) {
      setState(() {
          isPressed = false;
        });
        print("length 1 rebo");
        print(body['data']);
      body['data'][0]['is_member'] == "no" ? Navigator.push(context, MaterialPageRoute( builder: (context) =>AddCasePotentialmatch(body['data'][0]['id']))) : 
        Navigator.push(context, MaterialPageRoute( builder: (context) =>ProfileBioPage(body['data'][0]['id']))); 
    }
    else if (res.statusCode == 200 && body['data'].length >= 2) {
      setState(() {
          isPressed = false;
        });
        print("length 1 rebo");
        print(body['data']);
        Navigator.push(context, MaterialPageRoute( builder: (context) =>AddCaseMultipleMatch(body['data'])));
    }
    else{
      print("Else o asi");
      setState(() {
          isPressed = false;
        });

    }
    }
  }
}
