import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/AddCasePotentialmatch/AddCasePotentialmatch.dart';
import 'package:homewardbase/screens/ProfileBioPage/ProfileBioPage.dart';
import 'package:homewardbase/screens/RequestSentPage/RequestSentPage.dart';

import '../../main.dart';

class AddCaseMultipleMatch extends StatefulWidget {
  final casesListData;
  AddCaseMultipleMatch(this.casesListData);
  @override
  _AddCaseMultipleMatchState createState() => _AddCaseMultipleMatchState();
}

class _AddCaseMultipleMatchState extends State<AddCaseMultipleMatch> {
  List potentialPeople = [
    {
      'pic': 'assets/image/pm1.png',
      'name': 'Skylar Pierce',
      'desc': 'Arrow Child & Family Ministries',
      'status': 'Caeeworker',
      'checked': false
    },
    {
      'pic': 'assets/image/pm2.png',
      'name': 'Scott Pierce',
      'desc': 'CPS',
      'status': 'Caseworker',
      'checked': false
    },
  ];

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
      backgroundColor: Color(0xFFF8F8FA),
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
                "Potential Case Match",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                  children: List.generate(widget.casesListData.length, (index) {
                return Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute( builder: (context) =>AddCasePotentialmatch(widget.casesListData[index]['id'])));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          widget.casesListData[index]['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 45,
                                  width: 45,
                                  child: Center(
                                      child: Text(
                                    "${widget.casesListData[index]['first_name'][0].toUpperCase()}${widget.casesListData[index]['last_name'][0].toUpperCase()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
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
                                                  CallApi().fileShowlurl +"${widget.casesListData[index]['profile_picture']}"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 45,
                                  width: 45,
                                ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "${widget.casesListData[index]['first_name']} ${widget.casesListData[index]['last_name']}",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 15,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                   Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(

                                            "${widget.casesListData[index]['birthday']}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: mainColor,
                                                fontSize: 12,
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
                  )
              );
              })),
            ),
          ]),
        ),
      ),
    );
  }
}
