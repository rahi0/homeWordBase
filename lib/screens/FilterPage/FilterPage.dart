import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:homewardbase/screens/LanguageSeeAll/LanguageSeeAll.dart';
import 'package:homewardbase/screens/RaceSeeAll/RaceSeeAll.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double st = 0.0, end = 25.0;
  double minValue = 0.0;
  double maxValue = 25.0;
  int startingAge = 0,
      endingAge = 0,
      typeIndex = -1,
      gender = -1,
      ethnicity = -1,
      inCareSiblings = -1,
      notInCareSiblings = -1,
      siblingAge = -1,
      parentRight = -1;

  List adaptiveType = [
    {"name": "Foster", "status": 0},
    {"name": "Adoptive", "status": 0},
    {"name": "Residential", "status": 0},
    {"name": "Emergency", "status": 0},
    {"name": "Kinship", "status": 0},
  ];

  List placementAdaptive = [];
  List genderList = [];
  List ethnicityList = [];
  List parentalList = [];
  List inCareSiblingAgeList = [];
  List notInCareSiblingAgeList = [];

  var inCareThreePluss = "no";
  var notInCareThreePluss = "no";

  @override
  void initState() {
    super.initState();

    // if (adaptiveType.length != 0) {
    //   if (adaptiveType.length == 1) {
    //     typeIndex = 0;
    //   } else {
    //     typeIndex = 1;
    //   }
    // }
  }

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
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 13,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Filter",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "quicksand",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    st = 0.0;
                    end = 25.0;
                    // if (adaptiveType.length != 0) {
                    //   if (adaptiveType.length == 1) {
                    //     typeIndex = 0;
                    //   } else {
                    //     typeIndex = 1;
                    //   }
                    // }
                    gender = -1;
                    listLanguage = [];
                    listRace = [];
                    ethnicity = -1;
                    inCareSiblings = -1;
                    notInCareSiblings = -1;
                    siblingAge = -1;
                    parentRight = -1;
                    typeIndex = -1;
                    for (int i = 0; i < adaptiveType.length; i++) {
                      adaptiveType[i]['status'] = 0;
                    }
                    placementAdaptive = [];
                    genderList = [];
                    ethnicityList = [];
                    parentalList = [];
                    inCareSiblingAgeList = [];
                    notInCareSiblingAgeList = [];
                    inCareThreePluss = "no";
                    notInCareThreePluss = "no";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 0, left: 0),
                  child: Center(
                      child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Color(0xff7A98A9),
                        fontSize: 13,
                        fontFamily: "quicksand",
                        fontWeight: FontWeight.w400),
                  )),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Age",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff354D5B),
                          fontFamily: "quicksand",
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 0, left: 0),
                      child: Center(
                          child: Text(
                        "${st.toInt()} - ${end.toInt()}",
                        style: TextStyle(
                            color: Color(0xff7A98A9),
                            fontSize: 13,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w400),
                      )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: FlutterSlider(
                handlerHeight: 30,
                //handlerWidth: 15,
                tooltip: FlutterSliderTooltip(
                  //alwaysShowTooltip: true,
                  // leftPrefix: Icon(
                  //   Icons.account_circle,
                  //   size: 19,
                  //   color: Colors.black45,
                  // ),
                  // rightSuffix: Icon(
                  //   Icons.attach_money,
                  //   size: 19,
                  //   color: Colors.black45,
                  // ),
                  disabled: true,
                ),
                handlerAnimation: FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.bounceIn,
                    duration: Duration(milliseconds: 500),
                    scale: 1.5),
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 3,
                  inactiveTrackBar: BoxDecoration(color: Color(0xffDCF7EE)),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: selectedColor),
                ),
                jump: true,
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Material(
                      type: MaterialType.canvas,
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                          child: Image.asset("assets/image/slider.png"))),
                ),
                rightHandler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Material(
                      type: MaterialType.canvas,
                      color: Colors.transparent,
                      elevation: 0,
                      child: Container(
                          child: Image.asset("assets/image/slider.png"))),
                ),
                values: [st, end],
                min: minValue,
                max: maxValue,
                rangeSlider: true,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  // print(lowerValue);
                  // print(upperValue);
                  setState(() {
                    st = lowerValue;
                    end = upperValue;

                    print(st);
                    print(end);
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Placement type",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Wrap(
                  children: List.generate(adaptiveType.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      //typeIndex = index;
                      if (adaptiveType[index]['status'] == 0) {
                        adaptiveType[index]['status'] = 1;
                        placementAdaptive.add(adaptiveType[index]['name']);
                      } else {
                        adaptiveType[index]['status'] = 0;
                        placementAdaptive.remove(adaptiveType[index]['name']);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 17, right: 17),
                      margin: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                          color: adaptiveType[index]['status'] == 1
                              ? selectedColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: adaptiveType[index]['status'] == 1
                                  ? selectedColor
                                  : Color(0xfff1f1f1))),
                      child: Text(
                        "${adaptiveType[index]['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: adaptiveType[index]['status'] == 1
                                ? Colors.white
                                : Color(0xff333333),
                            fontSize: 14,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                );
              })),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                          if (genderList.contains("Male")) {
                            genderList.remove("Male");
                          } else {
                            genderList.add("Male");
                          }
                        });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            genderList.contains("Male")
                                ? "assets/image/gender_yes.png"
                                : "assets/image/gender_no.png",
                            height: 21,
                            width: 21,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(
                              "Male",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                          if (genderList.contains("Female")) {
                            genderList.remove("Female");
                          } else {
                            genderList.add("Female");
                          }
                        });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            genderList.contains("Female")
                                ? "assets/image/gender_yes.png"
                                : "assets/image/gender_no.png",
                            height: 21,
                            width: 21,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 7),
                            child: Text(
                              "Female",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontFamily: "quicksand",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Language",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff354D5B),
                          fontFamily: "quicksand",
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector( 
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageSeeAll()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 0, left: 0),
                      child: Center(
                          child: Text(
                        "See All",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 12,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w400),
                      )),
                    ),
                  )
                ],
              ),
            ),
            listLanguage.length == 0
                ? Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 2, left: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Please select language/s from 'See All'",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 12,
                          fontFamily: "quicksand",
                          fontWeight: FontWeight.w400),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Wrap(
                        children: List.generate(listLanguage.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            listLanguage.remove("${listLanguage[index]}");
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 17),
                            margin: EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: selectedColor)),
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 2.5),
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 14)),
                                SizedBox(width: 10),
                                Text(
                                  "${listLanguage[index]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "quicksand",
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
                  ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Race",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff354D5B),
                          fontFamily: "quicksand",
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RaceSeeAll()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 0, left: 0),
                      child: Center(
                          child: Text(
                        "See All",
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 12,
                            fontFamily: "quicksand",
                            fontWeight: FontWeight.w400),
                      )),
                    ),
                  )
                ],
              ),
            ),
            listRace.length == 0
                ? Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 2, left: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Please select race/s from 'See All'",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 12,
                          fontFamily: "quicksand",
                          fontWeight: FontWeight.w400),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                    child: Wrap(
                        children: List.generate(listRace.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            listRace.remove("${listRace[index]}");
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 17),
                            margin: EdgeInsets.only(top: 0),
                            decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: selectedColor)),
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 2.5),
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 14)),
                                SizedBox(width: 10),
                                Text(
                                  "${listRace[index]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "quicksand",
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
                  ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Ethnicity",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (ethnicityList.contains("Hispanic")) {
                            ethnicityList.remove("Hispanic");
                          } else {
                            ethnicityList.add("Hispanic");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color: ethnicityList.contains("Hispanic")
                                  ? selectedColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: ethnicityList.contains("Hispanic")
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Hispanic",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ethnicityList.contains("Hispanic")
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (ethnicityList.contains("Non-hispanic")) {
                            ethnicityList.remove("Non-hispanic");
                          } else {
                            ethnicityList.add("Non-hispanic");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color: ethnicityList.contains("Non-hispanic")
                                  ? selectedColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: ethnicityList.contains("Non-hispanic")
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Non-hispanic",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ethnicityList.contains("Non-hispanic")
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Siblings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          inCareSiblings = 0;
                          //inCareSiblingAgeList = [];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color:
                                  inCareSiblings == 0 ? selectedColor : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: inCareSiblings == 0
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "In care",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inCareSiblings == 0
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          inCareSiblings = 1;
                          //inCareSiblingAgeList = [];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color:
                                  inCareSiblings == 1 ? selectedColor : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: inCareSiblings == 1
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Not in care",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: inCareSiblings == 1
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), 

            /////////////////// In Care Count Start ////////////////////
            inCareSiblings == 0 ? Container(
              margin: EdgeInsets.only(left: 20, top: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xffF6F4F4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (inCareSiblingAgeList.contains("0")) {
                            inCareSiblingAgeList.remove("0");
                          } else {
                            inCareSiblingAgeList.add("0");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: inCareSiblingAgeList.contains("0")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "0",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inCareSiblingAgeList.contains("0")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (inCareSiblingAgeList.contains("1")) {
                            inCareSiblingAgeList.remove("1");
                          } else {
                            inCareSiblingAgeList.add("1");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: inCareSiblingAgeList.contains("1")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "1",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inCareSiblingAgeList.contains("1")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (inCareSiblingAgeList.contains("2")) {
                            inCareSiblingAgeList.remove("2");
                          } else {
                            inCareSiblingAgeList.add("2");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: inCareSiblingAgeList.contains("2")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inCareSiblingAgeList.contains("2")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (inCareThreePluss == "no") {
                            inCareThreePluss = "yes";
                          } else {
                            inCareThreePluss = "no";
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: inCareThreePluss == "yes"
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "3+",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inCareThreePluss == "yes"
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ) :
            //////////////////// In Care Count End ////////////////////
            
            /////////////////// Not In Care Count Start ////////////////////
           Container(
              margin: EdgeInsets.only(left: 20, top: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xffF6F4F4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (notInCareSiblingAgeList.contains("0")) {
                            notInCareSiblingAgeList.remove("0");
                          } else {
                            notInCareSiblingAgeList.add("0");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notInCareSiblingAgeList.contains("0")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "0",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: notInCareSiblingAgeList.contains("0")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (notInCareSiblingAgeList.contains("1")) {
                            notInCareSiblingAgeList.remove("1");
                          } else {
                            notInCareSiblingAgeList.add("1");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notInCareSiblingAgeList.contains("1")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "1",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: notInCareSiblingAgeList.contains("1")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (notInCareSiblingAgeList.contains("2")) {
                            notInCareSiblingAgeList.remove("2");
                          } else {
                            notInCareSiblingAgeList.add("2");
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notInCareSiblingAgeList.contains("2")
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "2",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: notInCareSiblingAgeList.contains("2")
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (notInCareThreePluss == "no") {
                            notInCareThreePluss = "yes";
                          } else {
                            notInCareThreePluss = "no";
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: notInCareThreePluss == "yes"
                              ? selectedColor
                              : Color(0xffF6F4F4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "3+",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: notInCareThreePluss == "yes"
                                  ? Colors.white
                                  : mainColor,
                              fontSize: 12,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //////////////////// Not In Care Count End ////////////////////
            Container(
              margin: EdgeInsets.only(left: 20, top: 25),
              alignment: Alignment.centerLeft,
              child: Text(
                "Parental Rights Status",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff354D5B),
                    fontFamily: "quicksand",
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (parentalList.contains("Terminated")) {
                            parentalList.remove("Terminated");
                          } else {
                            parentalList.add("Terminated");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color: parentalList.contains("Terminated")
                                  ? selectedColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: parentalList.contains("Terminated")
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Terminated",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: parentalList.contains("Terminated")
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (parentalList.contains("Not terminated")) {
                            parentalList.remove("Not terminated");
                          } else {
                            parentalList.add("Not terminated");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 17, right: 17),
                          margin: EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              color: parentalList.contains("Not terminated")
                                  ? selectedColor
                                  : Colors.white, 
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: parentalList.contains("Not terminated")
                                      ? selectedColor
                                      : Color(0xfff1f1f1))),
                          child: Text(
                            "Not terminated",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: parentalList.contains("Not terminated")
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 14,
                                fontFamily: "quicksand",
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: <Widget>[
          Container(
            //height: 15,
            margin: EdgeInsets.only(left: 0, right: 0, top: 5),
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
              _applyButton();
              
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
                      "Apply",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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


  void _applyButton() async{

     var data = {
          'to_age': st.toInt(),
          "from_age": end.toInt(),
          "placement_type": placementAdaptive,
          "gender": genderList,
          "language":listLanguage,
          "race": listRace,
          "ethnicity": ethnicityList,
          "parental_right_status": parentalList,
          "sibling_status": [
            {
               "status":'In_care',
               "sibling_number": inCareSiblingAgeList,
               "three_plus_siblings": inCareThreePluss
            },
            {
               "status":'Not_in_care',
               "sibling_number": notInCareSiblingAgeList,
               "three_plus_siblings": notInCareThreePluss
            }
          ],
        };
        print(data);
        
        SharedPreferences localStorage = await SharedPreferences.getInstance(); 
        localStorage.remove('filter');
        localStorage.setString('filter', json.encode(data));

        Navigator.pop(context);
  }
}
