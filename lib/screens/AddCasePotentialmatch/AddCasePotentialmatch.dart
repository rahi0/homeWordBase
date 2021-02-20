import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homewardbase/api/api.dart';
import 'package:homewardbase/screens/RequestSentPage/RequestSentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class AddCasePotentialmatch extends StatefulWidget {
  final caseId;
  AddCasePotentialmatch(this.caseId);
  @override
  _AddCasePotentialmatchState createState() => _AddCasePotentialmatchState();
}

class _AddCasePotentialmatchState extends State<AddCasePotentialmatch> {

  bool isLoading = true;
  bool isPressed = false;
  bool userChecked = false;
  bool noData = false;
  var matchData;
  List reqUserId = List();
  // List potentialPeople = [
  //   {
  //     'pic': 'assets/image/pm1.png',
  //     'name': 'Skylar Pierce',
  //     'desc': 'Arrow Child & Family Ministries',
  //     'status': 'Caeeworker',
  //     'checked': false,
  //     'id': 1
  //   },
  //   {
  //     'pic': 'assets/image/pm2.png',
  //     'name': 'Scott Pierce',
  //     'desc': 'CPS',
  //     'status': 'Caseworker',
  //     'checked': false,
  //     'id': 1
  //   },
  // ];

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

    var res = await CallApi().getData('member_of_case/${widget.caseId}');
    final body = json.decode(res.body);
    print(body);

    if(res.statusCode != 200){
      print("something is wrong here");
      setState(() {
      isLoading = false;
      });
      
    }
     if (res.statusCode == 200 && body['success'] == true) {
      if (body['data'].length >= 1) {
       print(body['data']);
       if (!mounted) return;

       setState(() {
         matchData = body['data'];
       });
      }
      else{
         setState(() {
           noData = true;
           isLoading = false;
         });
      }
      setState(() {
      isLoading = false;
      });
    }
    else{
      print("nothing");
      setState(() {
        noData = true;
      isLoading = false;
      });
    }

    
  }

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
      body: isLoading ? 
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : 

    noData == true ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(
                "This case is closed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: mainColor,
                    fontFamily: "quicksand",
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
      ),
    ) :
    SingleChildScrollView(
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
                "Potential match",
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
                "if you recognize anyone listed below, you can send them a request to add you to the case.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Color(0xff003A5B),
                    fontFamily: "quicksand",
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                  children: List.generate(matchData.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      //checkPotentialList.add(index);
                      if (matchData[index]['checked'] == false) {
                        matchData[index]['checked'] = true;
                        reqUserId.add(matchData[index]['id']);
                      } else {
                        matchData[index]['checked'] = false;
                        reqUserId.remove(matchData[index]['id']);
                      }
                    });
                  },
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: 
                                      matchData[index]['checked'] == true
                                          ? mainColor :
                                           Color(0xffD4DDE3),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.done,
                                      color: matchData[index]['checked'] == true
                                          ? Colors.white
                                          : Color(0xffD4DDE3),
                                      size: 15)),
                              matchData[index]['profile_picture'] == null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 45,
                                  width: 45,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Center(
                                      child: Text(
                                    "${matchData[index]['first_name'][0].toUpperCase()}${matchData[index]['last_name'][0].toUpperCase()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: "quicksand",
                                        fontWeight: FontWeight.w600),
                                  )),
                                )
                              : Container(
                                padding: EdgeInsets.all(24),
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    color: selectedColor,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/image/pm1.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(100)),
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
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: Text(
                                                  "${matchData[index]['first_name']} ${matchData[index]['last_name']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 15,
                                                      fontFamily: "quicksand",
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
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                "${matchData[index]['user_type']}",
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
                                       matchData[index]['organization'] == null ? "" : "${matchData[index]['organization']}",
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
                        matchData.length - 1 == index
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
                  ),
                );
              })),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
         isPressed ? null : _requestSendButton();//
        },
        child: Container(
          margin: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
                color: isPressed ? Colors.white :selectedColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selectedColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  isPressed ? "" : "Send request",
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
    );
  }

////////////// New Member Request Dialog STart //////////
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
////////////// New Member Request Dialog End //////////


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
                      child: Image.asset("assets/image/unsuccess.png")),
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


Future<void> _requestSendButton() async {
    setState(() {
      isPressed = true;
    });

    print(reqUserId);

    if(reqUserId.length == 0){
      isPressed = false;
      print("No one selected");
      _errorDialog("No one selected");
    }
  
     else {

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var userJson = localStorage.getString('user');
      var userData = json.decode(userJson);

      var data = {
          'user_id': userData['id'],
          "case_general_id": widget.caseId,
          "to_user_id": reqUserId,
        };
        print(data);



      var res = await CallApi().postData(data, 'joining_a_case');
       var body = json.decode(res.body);
    
  if (res.statusCode != 200) {
      setState(() {
          isPressed = false;
        });
        _errorDialog("Something went wrong");
        print("Something went wrong");
    }
    else if (res.statusCode == 200 && body['msg'] == "Already Sent") {
      setState(() {
          isPressed = false;
        });
        _showMemberDialog(1);
        print('Already Sent');
    }
    else if (res.statusCode == 200 && body['msg'] == "You are already a member") {
      setState(() {
          isPressed = false;
        });
        _showMemberDialog(2);
        print("You are already a member");
    }
    else if (res.statusCode == 200 && body['success'] == true) {
      setState(() {
          isPressed = false;
        });

         Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => RequestSentPage()));
       //  Navigator.push(context, MaterialPageRoute(builder: (context) => RequestSentPage()));
        
    }
    else{
      print("Else o asi");
       _errorDialog("Something went wrong");
      setState(() {
          isPressed = false;
        });

   }
    }
  }
  
}
