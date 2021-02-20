import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:homewardbase/redux/actions.dart';
import 'package:homewardbase/screens/ReadyToGoPage/ReadyToGoPage.dart';
import 'package:homewardbase/screens/RegisterPage/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfilePage extends StatefulWidget {
  final mainEmail;
  final password;
  CreateProfilePage(this.mainEmail, this.password);
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  List<DropdownMenuItem<String>> _dropDownRoleItems;
  List<DropdownMenuItem<String>> _dropDownStateItems;
  List arrRole = [
    "Foster/adoptive parent",
    "Caseworker",
    "CASA/GAL",
    "Attorney ad litem",
    "Residential facility worker",
    "Other",
  ];
  List arrState = ["Select States"];
  String valRole = "",
      valState = "",
      fname = "",
      lname = "",
      roleType = "",
      city = "",
      email = "",
      mobile = "",
      homeNum = "",
      officeNum = "";
  bool emailCorrect = false,
      phoneCorrect = false,
      homePhoneCorrect = false,
      officePhoneCorrect = false;
  bool isPressed = false;
  bool isFName = true;
  bool isLName = true;
  bool isCity = true;
  bool isState = true;
  bool isOtherempty = false;
  bool emailTaken = true;

  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController roleTypeController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobNumController = new MaskedTextController(mask: '(000) 0000 000000');
  TextEditingController officeNumController = new MaskedTextController(mask: '(000) 0000 000000');
  TextEditingController homeNumController = new MaskedTextController(mask: '(000) 0000 000000');

  var jsonResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStates();
    _dropDownRoleItems = getDropDownRoleItems();
    valRole = _dropDownRoleItems[0].value;
  }

  Future<void> loadStates() async {
    String data = await rootBundle.loadString('assets/json/us_states.json');
    jsonResult = json.decode(data);
    //print(jsonResult);
    for (int i = 0; i < jsonResult.length; i++) {
      //print(jsonResult[i]['name']);
      arrState.add(jsonResult[i]['name']);
    }

    print(arrState);
    _dropDownStateItems = getDropDownStateItems();
    valState = _dropDownStateItems[0].value;
  }

  List<DropdownMenuItem<String>> getDropDownRoleItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String roleList in arrRole) {
      items.add(new DropdownMenuItem(
          value: roleList,
          child: new Text(
            roleList,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Color(0xff003A5B).withOpacity(0.6),
                fontFamily: 'quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownStateItems() {
    ////////drop down button
    List<DropdownMenuItem<String>> items = new List();
    for (String stateList in arrState) {
      items.add(new DropdownMenuItem(
          value: stateList,
          child: new Text(
            stateList,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Color(0xff003A5B).withOpacity(0.6),
                fontFamily: 'quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w600),
          )));
    }
    return items;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.chevron_left, color: Colors.black, size: 35))),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(15),
                child: Image.asset("assets/image/small_logo.png")),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
              child: Text(
                "Create your profile",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 40),
              child: Text(
                "Your details here will be visible to other Homewardbase users on associated cases.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontFamily: "quicksand",
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/image/camera.png"),
                    height: 42,
                    width: 42,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Add profile image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: "quicksand",
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Please make sure your photo clearly shows your face.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.7),
                                fontFamily: "quicksand",
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 35),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            fname = value;
                            if (fname == ""){
                              setState(() {
                                isFName = false;
                              });
                            }else{
                              isFName= true;
                            }
                          });
                        },
                        controller: fNameController,
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter your first name",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "First Name",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            lname = value;   
                            if (lname == ""){
                              setState(() {
                                isLName = false;
                              });
                            }else{
                              isLName= true;
                            }                     
                          }); 
                        },
                        controller: lNameController,
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter your last name",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
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
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      //height: 15,
                      margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                      child: Divider(
                        color: Colors.black,
                        height: 15,
                        thickness: 0.2,
                        //indent: 20,
                        endIndent: 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //height: 15,
                      margin: EdgeInsets.only(left: 5, right: 20, top: 0),
                      child: Divider(
                        color: Colors.black,
                        height: 15,
                        thickness: 0.2,
                        //indent: 20,
                        endIndent: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
/////////////////////////////
                isFName == false || isLName == false ? errorCon(" First name & last name required") : Container(),
/////////////////////////////
            Container(
              margin: EdgeInsets.only(left: 22, right: 20, top: 5),
              child: Text(
                "Select Role",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontSize: 11.5,
                    fontFamily: 'quicksand',
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 33,
              padding: EdgeInsets.only(left: 22, right: 22),
              child: DropdownButtonHideUnderline(
                child: Container(
                  child: DropdownButton(
                    //icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    // iconDisabledColor:
                    //     Color(0xFF008990),
                    iconEnabledColor: Color(0xff003A5B),
                    // iconSize: 40,

                    //hint: Text('Select Situation'),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff003A5B),
                    ),
                    value: valRole,
                    items: _dropDownRoleItems,
                    icon: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: Color(0xff003A5B),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        valRole = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            valRole != "Other"
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 20, top: 5),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                roleType = value;
                                if (roleType == ""){
                              setState(() {
                                isOtherempty = true;
                              });
                                }else{
                                  isOtherempty = false;
                                }
                              });
                            },
                            controller: roleTypeController,
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Color(0xff003A5B).withOpacity(0.6),
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "Enter Your Role",
                              hintStyle: TextStyle(
                                  color: Color(0xff003A5B).withOpacity(0.6),
                                  fontSize: 15,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600),
                              labelStyle: TextStyle(
                                  color: Color(0xff003A5B),
                                  fontSize: 15,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w500),
                              labelText: "Your Role",
                              contentPadding:
                                  EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
/////////////////////////////
                isOtherempty == true ? errorCon("Role field is required") : Container(),
/////////////////////////////
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            city = value;
                            if (city == ""){
                              setState(() {
                                isCity = false;
                              });
                            }else{
                              isCity= true;
                            }
                          });
                        },
                        controller: cityController,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "Enter your city",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "City",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
///////////////////////////////
            isCity == false ? errorCon(" City field is blank") : Container(),
////////////////////////////////
            Container(
              margin: EdgeInsets.only(left: 22, right: 20, top: 15),
              child: Text(
                "State",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontSize: 11.5,
                    fontFamily: 'quicksand',
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              height: 33,
              padding: EdgeInsets.only(left: 22, right: 22),
              child: DropdownButtonHideUnderline(
                child: Container(
                  child: DropdownButton(
                    //icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    // iconDisabledColor:
                    //     Color(0xFF008990),
                    iconEnabledColor: Color(0xff003A5B),
                    // iconSize: 40,

                    //hint: Text('Select Situation'),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff003A5B),
                    ),
                    value: valState,
                    items: _dropDownStateItems,
                    icon: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: Color(0xff003A5B),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        valState = value;
                        if (valState == "Select States" || valState == ""){
                              setState(() {
                                isState = false;
                              });
                            }else{
                              isState= true;
                            }
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
///////////////////////////////
            isState == false ? errorCon(" State is not selected") : Container(),
////////////////////////////////
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            if (email.contains('@') && email.contains(".")) {
                              emailCorrect = true;
                            } else {
                              emailCorrect = false;
                            }
                          });
                        },
                        controller: emailController,
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "abc@xyz.com",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "Email (Optional)",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    email == ""
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: emailCorrect
                                    ? selectedColor
                                    : Colors.redAccent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              emailCorrect ? Icons.done : Icons.close,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                  ],
                )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            mobile = value;
                            if (!mobile.contains(new RegExp(r'[a-zA-Z]'))) {
                              phoneCorrect = true;
                            } else {
                              phoneCorrect = false;
                            }
                          });
                        },
                        controller: mobNumController,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "(---) ---- ---",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "Mobile Phone Number (Optional)",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    mobile == ""
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: phoneCorrect
                                    ? selectedColor
                                    : Colors.redAccent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              phoneCorrect ? Icons.done : Icons.close,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                  ],
                )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            officeNum = value;
                            if (!officeNum.contains(new RegExp(r'[a-zA-Z]'))) {
                              officePhoneCorrect = true;
                            } else {
                              officePhoneCorrect = false;
                            }
                          });
                        },
                        controller: officeNumController,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "(---) ---- ---",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "Office Phone Number (Optional)",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    officeNum == ""
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: officePhoneCorrect
                                    ? selectedColor
                                    : Colors.redAccent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              officePhoneCorrect ? Icons.done : Icons.close,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                  ],
                )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 10, right: 20, top: 15),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            homeNum = value;
                            if (!homeNum.contains(new RegExp(r'[a-zA-Z]'))) {
                              homePhoneCorrect = true;
                            } else {
                              homePhoneCorrect = false;
                            }
                          });
                        },
                        controller: homeNumController,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: Color(0xff003A5B).withOpacity(0.6),
                            fontFamily: 'quicksand',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: "(---) ---- ---",
                          hintStyle: TextStyle(
                              color: Color(0xff003A5B).withOpacity(0.6),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(
                              color: Color(0xff003A5B),
                              fontSize: 15,
                              fontFamily: 'quicksand',
                              fontWeight: FontWeight.w500),
                          labelText: "Home Phone Number (Optional)",
                          contentPadding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    homeNum == ""
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: homePhoneCorrect
                                    ? selectedColor
                                    : Colors.redAccent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20)),
                            child: Icon(
                              homePhoneCorrect ? Icons.done : Icons.close,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                  ],
                )),
            Container(
              //height: 15,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 0.15,
                //indent: 20,
                endIndent: 0,
              ),
            ),
            GestureDetector(
                onTap: isPressed ? null : createButton,
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
                                "Create account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isPressed
                                        ? selectedColor
                                        : Colors.white,
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
      ),
    );
  }

  void createButton() async {
    setState(() {
      isPressed = true;
     // emailBlank = true;
    });

    if (fname == "") {
      setState(() {
         isFName = false;
         isPressed = false;
      });
    } else if(lname == "") {
      setState(() {
         isLName = false;
         isPressed = false;
      });
    } 
     else if(valRole == "Other" && roleTypeController.text == "") {
      setState(() {
         isOtherempty = true;
         isPressed = false;
      });
    } 
    else if(city == "") {
      setState(() {
         isCity = false;
         isPressed = false;
      });
    } else if(valState == "Select States" || valState == "") {
      setState(() {
         isState = false;
         isPressed = false;
      });
    }
    else {
      setState(() {
        isFName = true;
        isLName= true;
        isCity = true;
        isState = true;
      });

      var data = {
          'first_name': fname ,
          "last_name": lname,
          "email": widget.mainEmail,
          "password": widget.password,
          "optional_email": emailController.text,
          "city": cityController.text,
          "state": valState,
          "mobile" : mobNumController.text,
          "home_phone": homeNumController.text,
          "office_phone": officeNumController.text,
          "profile_picture" : null,
          "user_type" : valRole != "Other" ? valRole : roleTypeController.text,
        };
        print(data);


      var res = await CallApi().withoutTokenPostData(data, 'register');
       var body = json.decode(res.body);
    
   if(res.statusCode == 400){
      setState(() {
          isPressed = false;
        });

        print("email taken");

        //_showMemberDialog(1);

        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => RegisterPage(emailTaken)));
   }else if (res.statusCode != 200) {

      setState(() {
          isPressed = false;
        });

        print("Something went wrong");
    }else{

      var token = body['token'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', token);
      localStorage.setString('user', json.encode(body['user']));
      print(body);
      store.dispatch(new UserInfoAction(body['user']));

      setState(() {
          isPressed = false;
        });

     //Navigator.push(context,MaterialPageRoute(builder: (context) => ReadyToGoPage()));
  
     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => ReadyToGoPage()));
    //   Timer(Duration(microseconds: 300), () {
       
    //   });

    }

     
     }
  }




  Future<Null> _showMemberDialog(number) async {
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
                      child: Image.asset(number == 1
                          ? "assets/image/success.png"
                          : "assets/image/unsuccess.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    number == 1 ? "Success" : "New member rejected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff003A5B),
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    number == 1
                        ? "Philippa Jordan has been successfully added to this case"
                        : "You have successfully rejected Jill Smith's attempt to join this case. They will have to request again to join or be invited if this was a mistake.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
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




}
