import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/main.dart';
import 'package:homewardbase/screens/LoginPage/LoginPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingRequestPage extends StatefulWidget {

  final caseId;
  PendingRequestPage(this.caseId);
  @override
  _PendingRequestPageState createState() => _PendingRequestPageState();
}

class _PendingRequestPageState extends State<PendingRequestPage> {
  bool isLoading = true;
  bool somethingWrong = false;
  bool withdrewButtonClicked = false;

  var pendingPageData;
  List potentialPeople = [
    {
      'pic': 'assets/image/pm1.png',
      'name': 'Skylar Pierce',
      'desc': 'Arrow Child & Family Ministries',
      'status': 'Caeeworker',
    },
    {
      'pic': 'assets/image/pm2.png',
      'name': 'Scott Pierce',
      'desc': 'Arrow Child & Family Ministries',
      'status': 'Caseworker',
    },
  ];


   @override
  initState() {
    super.initState();
    _getCaseMemberData();
  }
  

  _getCaseMemberData() async {

    setState(() {
      isLoading = true;
    });
    print("hello");
    print(widget.caseId);

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);

      var data = {
          'user_id': userData['id'],
          "case_general_id": widget.caseId,
        };
        print(data);

    var res = await CallApi().postData( data, 'get_requested_member_list');
    final body = json.decode(res.body);
    print(body);

    if(res.statusCode != 200){
      print("something is wrong here");
     // _showMemberDialog(1);
      setState(() {
      somethingWrong = true;
      isLoading = false; 
      });
      
    }
     if (res.statusCode == 200 && body['success'] == true) {
      if (body['case_info'] != null) {
       print(body['data']);
       if (!mounted) return;
       setState(() {
         pendingPageData = body;
       });
      }
       if (body == null) {
       print(body['data']);
       if (!mounted) return;
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
       setState(() {
      isLoading = false;
      });
      }
      else{
        print("data empty");
      }
      setState(() {
      isLoading = false;
      });
    }
    else{
      print("nothing");
      setState(() {
      isLoading = false;
      });
    }

    // setState(() {
    //   isLoading = false;
    // });

    
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
                    child: Icon(Icons.chevron_left,
                        color: Colors.black, size: 25)),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    "Pending Request",
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
      body: isLoading ? 
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : Container(
      child: somethingWrong ?
        Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(
                          "Something went wrong",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w600),
                        ),
      ),
    ) : SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(20),
                        child: Image.asset(
                          "assets/image/pendingReq.png",
                          height: 47,
                          width: 47,
                        )),
                    GestureDetector(
                      onTap: () {
                        _showWithdrawDialog();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 14, right: 14),
                        decoration: BoxDecoration(
                            color: Color(0xFFF9423A),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Withdraw request",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 0),
                child: Text(
                  "Pending request",
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
                  "You have requested to join a case base on the following information.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Color(0xff003A5B),
                      fontFamily: "quicksand",
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                margin: EdgeInsets.only(top: 0, left: 23, right: 23),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      //spreadRadius: 5,
                      blurRadius: 1,
                      offset: Offset(0, .5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      "Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 14,
                          fontFamily: "quicksand",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    //height: 15,
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
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
                    padding: EdgeInsets.only(left: 15, right: 15),
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
                          "${pendingPageData['case_info']['first_name']}",
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
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
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
                    padding: EdgeInsets.only(left: 15, right: 15),
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
                          "${pendingPageData['case_info']['last_name']}",
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
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
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
                    padding: EdgeInsets.only(left: 15, right: 15),
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
                          "${DateFormat('dd-MM-yyyy').format(DateTime.parse(pendingPageData['case_info']['birthday']))}",
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
                ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                margin: EdgeInsets.only(top: 20, left: 23, right: 23),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      //spreadRadius: 5,
                      blurRadius: 1,
                      offset: Offset(0, .5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Request Sent",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 14,
                              fontFamily: "quicksand",
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: mainColor,
                                size: 15,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "02-02-2020",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 12,
                                    fontFamily: "quicksand",
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //height: 15,
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 15),
                    child: Divider(
                      color: Colors.black,
                      height: 2,
                      thickness: 0.1,
                      //indent: 20,
                      endIndent: 0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                        children: List.generate(pendingPageData['user_list'].length, (index) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20, right: 5),
                              child: Row(
                                children: <Widget>[
                                  pendingPageData['user_list'][index]['profile_picture'] == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                    margin: EdgeInsets.only(left: 0),
                                    child: Center(
                                        child: Text(
                                      "${pendingPageData['user_list'][index]['first_name'][0].toUpperCase()}${pendingPageData['user_list'][index]['last_name'][0].toUpperCase()}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: "quicksand",
                                          fontWeight: FontWeight.w600),
                                    )),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(24),
                                    margin: EdgeInsets.only(left: 0),
                                    decoration: BoxDecoration(
                                        color: selectedColor,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/image/pm2.png"),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    height: 45,
                                    width: 45,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                      "${pendingPageData['user_list'][index]['first_name']} ${pendingPageData['user_list'][index]['last_name']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "quicksand",
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5, right: 30),
                                                  padding: EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffDCF7EE)
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    "${pendingPageData['user_list'][index]['user_type']}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: selectedColor,
                                                        fontSize: 9,
                                                        fontFamily: "quicksand",
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            pendingPageData['user_list'][index]['organization'] == null ? "" :
                                           "${pendingPageData['user_list'][index]['organization']}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: mainColor,
                                                fontSize: 12,
                                                fontFamily: "quicksand",
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pendingPageData['user_list'].length - 1 == index
                                ? Container()
                                : Container(
                                    //height: 15,
                                    margin: EdgeInsets.only(
                                        left: 0, right: 0, top: 15, bottom: 15),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 2,
                                      thickness: 0.1,
                                      //indent: 20,
                                      endIndent: 0,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    })),
                  ),
                ]),
              )
            ]),
          ),
        ),
    ),
    );
  }

  Future<Null> _showWithdrawDialog() async {
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
                      child: Image.asset("assets/image/accept_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Are you sure?",
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
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    "If you withdraw this request to join, you will need to make a new request or be invited.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'quicksand',
                        color: Color(0xff7A98A9),
                        fontWeight: FontWeight.w400,
                        fontSize: 11),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                top: 0, bottom: 20, left: 0, right: 2.5),
                            decoration: BoxDecoration(
                              color: Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Color(0xff003A5B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "quicksand"))),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                        //   withdrewButtonClicked ? null :
                            _doWithdrew();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 20, left: 2.5, right: 0),
                              decoration: BoxDecoration(
                                color: Color(0xffF9423A),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("Withdraw request",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "quicksand"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDoneDialog() async {
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
                      child: Image.asset("assets/image/reject_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Request withdrawn",
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
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    "Your request to join this case has been withdrawn. If you would like to join, you will need to submit another request or be invited.",
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
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 50, right: 50),
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

////////////// Error Dialog STart //////////
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
                      child: Image.asset(number == 2
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
                    number == 1 ? "Already Sent" : "Already a member",
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
                        ? "You have already sent a request to this case"
                        : "You are already a member to this case",
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
////////////// Error Dialog End //////////


////////// withdraw error dialog /////////
Future<Null> _showErrorDialog() async {
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
                      child: Image.asset("assets/image/reject_removal.png")),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Request withdrawn",
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
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    "Your request to join this case has been withdrawn. If you would like to join, you will need to submit another request or be invited.",
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
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            top: 0, bottom: 20, left: 50, right: 50),
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
////////// withdraw error dialog /////////



//////////////////////// Withdrew request  STart  //////////////////////
  
  void _doWithdrew() async {
    setState(() {
      withdrewButtonClicked = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);
    var data = {
      'user_id': userData['id'],
      'case_general_id': widget.caseId
    };
    setState(() {
      withdrewButtonClicked = false;
    });
    // Navigator.pop(context);
    // _showDoneDialog();

    print(data);
    var res = await CallApi().postData(data, 'withdrawRequest');
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode != 200) {
      // show error msg
      print('error');
      Navigator.pop(context);
      _showErrorDialog();
        setState(() {
      withdrewButtonClicked = false;
    });
    } else if (res.statusCode == 200 && body['success'] == true){
       for(var d in store.state.homepageCaseState['withdrawalRequest']){
        if(d['id'] ==  widget.caseId){
          print(d);
          store.state.homepageCaseState['withdrawalRequest'].remove(d);
          //print(store.state.homepageCaseState['New_Case_Invite']);
          break;
        }
      }
      Navigator.pop(context);
      _showDoneDialog();
      setState(() {
      withdrewButtonClicked = false;
    });
    }else{
      print('Already withdrawn');
      Navigator.pop(context);
      _showErrorDialog();
      setState(() {
      withdrewButtonClicked = false;
    });
    }
  }
//////////////////////// Withdrew request End /////////////////////////


}
